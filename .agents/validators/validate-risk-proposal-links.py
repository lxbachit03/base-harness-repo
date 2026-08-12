#!/usr/bin/env python3
"""Static validator for reciprocal risk/proposal Markdown relationships."""

from __future__ import annotations

import hashlib
import os
import re
import sys
import time
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Set, Tuple, Union


ID_RE = re.compile(r"^#\d{3}_RISK_\d{4}$")
FILENAME_RE = re.compile(r"^(\d{4})-[a-z0-9]+(?:-[a-z0-9]+)*\.md$")
LINK_RE = re.compile(r"\[([^\]]+)\]\(([^)]+)\)")
META_RE = re.compile(r"^(ID|TAG|PRIORITY|TITLE|CREATED|STATUS|REFERENCES):(?:[ \t]*(.*))?$")
TOP_INDEX_RE = re.compile(
    r"^- \[([^\]]+)\]\(([^)]+)\) — PRIORITY: \[(CRITIAL|MEDIUM|NORMAL)\]$"
)
NESTED_INDEX_RE = re.compile(r"^  - Proposal: \[([^\]]+)\]\(([^)]+)\)$")

REQUIRED_METADATA = ("ID", "TAG", "PRIORITY", "TITLE", "CREATED", "STATUS", "REFERENCES")
REQUIRED_SECTIONS = {
    "risks": (
        "## Risk",
        "## Evidence",
        "## Impact",
        "## Indicators",
        "## Mitigation",
        "## Verification",
        "## Related Proposals",
    ),
    "proposals": (
        "## Problem",
        "## Context",
        "## Related Risks",
        "## Options",
        "## Recommendation",
        "## Decision",
        "## Consequences",
        "## Residual Risk",
        "## Rollback",
    ),
}


@dataclass
class Link:
    label: str
    target: str
    line: int
    resolved_rel: Optional[str] = None
    target_id: Optional[str] = None


@dataclass
class Resource:
    kind: str
    path: Path
    rel: str
    lines: List[str]
    values: Dict[str, List[str]] = field(default_factory=dict)
    resource_id: Optional[str] = None
    title: Optional[str] = None
    priority: Optional[str] = None
    refs: List[Link] = field(default_factory=list)
    related: List[Link] = field(default_factory=list)


class Validator:
    def __init__(self, root: Path) -> None:
        self.root = root.resolve()
        self.errors: List[Tuple[bool, str, str, int, str]] = []
        self.resources: Dict[str, Resource] = {}
        self.id_index: Dict[str, Resource] = {}
        self.resource_paths: List[Path] = []
        self.index_lines: List[str] = []
        self.fatal = False

    def rel(self, path: Path) -> str:
        try:
            return path.resolve().relative_to(self.root).as_posix()
        except (OSError, ValueError):
            return "."

    def error(
        self,
        rule: str,
        path: Union[Path, str],
        line: int,
        message: str,
        fatal: bool = False,
    ) -> None:
        path_text = path if isinstance(path, str) else self.rel(path)
        self.errors.append((fatal, rule, path_text, line, message))
        self.fatal = self.fatal or fatal

    def snapshot(self) -> Tuple[Tuple[str, str], ...]:
        """Hash the validator scope without following symlinks."""

        paths: Set[Path] = {self.root / "docs-harness" / "INDEX.md"}
        for folder_name in ("risks", "proposals"):
            folder = self.root / "docs-harness" / folder_name
            paths.add(folder)
            if not folder.exists() or folder.is_symlink():
                continue
            for current, dirnames, filenames in os.walk(folder, followlinks=False):
                current_path = Path(current)
                for name in dirnames:
                    paths.add(current_path / name)
                for name in filenames:
                    paths.add(current_path / name)
                dirnames[:] = [
                    name for name in dirnames if not (current_path / name).is_symlink()
                ]

        result: List[Tuple[str, str]] = []
        for path in sorted(paths, key=self.rel):
            relative = self.rel(path)
            try:
                if path.is_symlink():
                    value = "symlink:" + os.readlink(path)
                elif path.is_file():
                    value = hashlib.sha256(path.read_bytes()).hexdigest()
                elif path.is_dir():
                    value = "directory"
                else:
                    value = "missing"
            except OSError as exc:
                self.error("TOOLING", relative, 0, f"cannot snapshot path: {exc}", fatal=True)
                value = "snapshot-error"
            result.append((relative, value))
        return tuple(result)

    def validate_scope(self) -> None:
        docs_harness = self.root / "docs-harness"
        index = docs_harness / "INDEX.md"
        if index.is_symlink():
            self.error("SCOPE", index, 0, "INDEX.md must not be a symlink")
        elif not index.is_file():
            self.error("SCOPE", index, 0, "INDEX.md is required")

        if not docs_harness.is_dir() or docs_harness.is_symlink():
            self.error("SCOPE", docs_harness, 0, "docs-harness must be a real directory")

        for folder_name in ("risks", "proposals"):
            folder = docs_harness / folder_name
            if folder.is_symlink() or not folder.is_dir():
                self.error("SCOPE", folder, 0, "canonical resource directory is required")
                continue
            for entry in sorted(folder.iterdir(), key=lambda item: item.name):
                if entry.is_symlink():
                    self.error("SCOPE", entry, 0, "symlinks are not canonical resources")
                    continue
                if entry.is_dir():
                    self.error("SCOPE", entry, 0, "nested resource directories are not allowed")
                    continue
                if entry.name == "README.md":
                    continue
                if entry.suffix != ".md":
                    self.error("SCOPE", entry, 0, "canonical resource files must be Markdown")
                    continue
                self.resource_paths.append(entry)

    def read_lines(self, path: Path) -> List[str]:
        try:
            return path.read_text(encoding="utf-8").splitlines()
        except (OSError, UnicodeError) as exc:
            self.error("PARSE", path, 0, f"cannot read UTF-8 Markdown: {exc}", fatal=True)
            return []

    def parse_resource(self, path: Path) -> Resource:
        kind = path.parent.name
        resource = Resource(kind, path, self.rel(path), self.read_lines(path))
        values: Dict[str, List[str]] = {key: [] for key in REQUIRED_METADATA}

        for line in resource.lines:
            if line.startswith("## "):
                break
            match = META_RE.match(line)
            if match:
                values.setdefault(match.group(1), []).append((match.group(2) or "").strip())

        resource.values = values
        for key in REQUIRED_METADATA:
            if not values.get(key):
                self.error("META", path, 0, f"missing required metadata: {key}")
        for key in REQUIRED_METADATA:
            if key != "TAG" and len(values.get(key, [])) > 1:
                self.error("META", path, 0, f"duplicate metadata: {key}")

        resource.resource_id = (values.get("ID") or [None])[0]
        resource.title = (values.get("TITLE") or [None])[0]
        resource.priority = (values.get("PRIORITY") or [None])[0]
        self.validate_metadata(resource)
        resource.refs = self.parse_reference_links(resource)
        related_heading = "## Related Proposals" if kind == "risks" else "## Related Risks"
        resource.related = self.parse_section_links(resource, related_heading)
        return resource

    def validate_metadata(self, resource: Resource) -> None:
        path = resource.path
        if resource.resource_id and not ID_RE.fullmatch(resource.resource_id):
            self.error("ID", path, 0, f"invalid immutable risk ID: {resource.resource_id}")
        if not any(value == "[RISK]" for value in resource.values.get("TAG", [])):
            self.error("META", path, 0, "canonical risk/proposal resources require TAG: [RISK]")
        if resource.priority not in {"[CRITIAL]", "[MEDIUM]", "[NORMAL]"}:
            self.error("META", path, 0, "PRIORITY must be [CRITIAL], [MEDIUM], or [NORMAL]")
        if not resource.title:
            self.error("META", path, 0, "TITLE must not be empty")
        if not (resource.values.get("STATUS") or [""])[0]:
            self.error("META", path, 0, "STATUS must not be empty")

        created = (resource.values.get("CREATED") or [""])[0]
        created_date: Optional[datetime] = None
        try:
            created_date = datetime.strptime(created, "%Y-%m-%d")
        except ValueError:
            self.error("META", path, 0, "CREATED must use YYYY-MM-DD")

        filename_match = FILENAME_RE.fullmatch(path.name)
        if not filename_match:
            self.error("FILENAME", path, 0, "filename must use <MMDD>-<lowercase-kebab-case>.md")
        elif resource.resource_id:
            if filename_match.group(1) != resource.resource_id[-4:]:
                self.error("FILENAME", path, 0, "filename MMDD must match immutable ID date")
            if created_date and filename_match.group(1) != created_date.strftime("%m%d"):
                self.error("FILENAME", path, 0, "filename MMDD must match CREATED")

        headings = {line.strip() for line in resource.lines if line.startswith("## ")}
        for section in REQUIRED_SECTIONS[resource.kind]:
            if section not in headings:
                self.error("SECTION", path, 0, f"missing required section: {section}")

        if resource.resource_id:
            previous = self.id_index.get(resource.resource_id)
            if previous:
                self.error(
                    "ID",
                    path,
                    0,
                    f"duplicate immutable ID also used by {previous.rel}: {resource.resource_id}",
                )
            else:
                self.id_index[resource.resource_id] = resource

    def parse_reference_links(self, resource: Resource) -> List[Link]:
        try:
            start = next(index for index, line in enumerate(resource.lines) if line == "REFERENCES:")
        except StopIteration:
            return []

        end = len(resource.lines)
        for index in range(start + 1, len(resource.lines)):
            if resource.lines[index].startswith("## "):
                end = index
                break

        links: List[Link] = []
        for index in range(start + 1, end):
            line = resource.lines[index]
            if not line.strip():
                continue
            matches = list(LINK_RE.finditer(line))
            if not line.startswith("- ") or len(matches) != 1 or line.strip() != "- " + matches[0].group(0):
                self.error(
                    "FORMAT",
                    resource.path,
                    index + 1,
                    "REFERENCES must contain only canonical Markdown link bullets",
                )
                continue
            links.append(Link(matches[0].group(1), matches[0].group(2), index + 1))

        if not links:
            self.error("RELATION", resource.path, start + 1, "REFERENCES must contain at least one relationship link")
        return links

    def parse_section_links(self, resource: Resource, heading: str) -> List[Link]:
        try:
            start = next(index for index, line in enumerate(resource.lines) if line.strip() == heading)
        except StopIteration:
            return []

        end = len(resource.lines)
        for index in range(start + 1, len(resource.lines)):
            if resource.lines[index].startswith("## "):
                end = index
                break

        links: List[Link] = []
        for index in range(start + 1, end):
            line = resource.lines[index]
            if not line.strip():
                continue
            matches = list(LINK_RE.finditer(line))
            if not line.startswith("- ") or len(matches) != 1 or line.strip() != "- " + matches[0].group(0):
                self.error(
                    "FORMAT",
                    resource.path,
                    index + 1,
                    f"{heading} must contain only canonical Markdown link bullets",
                )
                continue
            links.append(Link(matches[0].group(1), matches[0].group(2), index + 1))

        if not links:
            self.error("RELATION", resource.path, start + 1, f"{heading} must contain at least one relationship link")
        return links

    def target_from_link(self, source: Resource, link: Link) -> Optional[Resource]:
        target = link.target.strip()
        if (
            not target
            or target.startswith(("/", "\\", "~"))
            or re.match(r"^[A-Za-z][A-Za-z0-9+.-]*:", target)
            or "#" in target
            or "?" in target
            or "\\" in target
        ):
            self.error("PATH", source.path, link.line, f"link target is not a relative Markdown path: {target}")
            return None

        candidate = (source.path.parent / target).resolve()
        try:
            relative = candidate.relative_to(self.root).as_posix()
        except ValueError:
            self.error("PATH", source.path, link.line, f"link escapes repository root: {target}")
            return None

        target_resource = self.resources.get(relative)
        if not target_resource:
            self.error("PATH", source.path, link.line, f"link target does not resolve to a canonical resource: {target}")
            return None

        expected_folder = "proposals" if source.kind == "risks" else "risks"
        if target_resource.kind != expected_folder:
            self.error("PATH", source.path, link.line, f"{source.kind} resources must link to {expected_folder}/")
            return None

        if not target_resource.resource_id:
            return None

        label_parts = link.label.strip().split(None, 1)
        label_id = label_parts[0] if label_parts else ""
        label_title = label_parts[1] if len(label_parts) == 2 else ""
        if label_id != target_resource.resource_id:
            self.error("LINK", source.path, link.line, "link label ID does not match target resource ID")
        if label_title != (target_resource.title or ""):
            self.error("LINK", source.path, link.line, "link label title does not match target TITLE")

        link.resolved_rel = relative
        link.target_id = target_resource.resource_id
        return target_resource

    def validate_relationships(self) -> None:
        for resource in self.resources.values():
            resolved_refs: List[Link] = []
            resolved_related: List[Link] = []
            for link in resource.refs:
                if self.target_from_link(resource, link):
                    resolved_refs.append(link)
            for link in resource.related:
                if self.target_from_link(resource, link):
                    resolved_related.append(link)

            ref_ids = [link.target_id for link in resolved_refs if link.target_id]
            related_ids = [link.target_id for link in resolved_related if link.target_id]
            if len(ref_ids) != len(set(ref_ids)):
                self.error("RELATION", resource.path, 0, "REFERENCES contains a duplicate relationship")
            if len(related_ids) != len(set(related_ids)):
                self.error("RELATION", resource.path, 0, "related-resource section contains a duplicate relationship")
            ref_links = {(link.label.strip(), link.target.strip()) for link in resolved_refs}
            related_links = {(link.label.strip(), link.target.strip()) for link in resolved_related}
            if ref_links != related_links:
                self.error(
                    "RECIPROCAL",
                    resource.path,
                    0,
                    "REFERENCES and related-resource Markdown link sets must be identical",
                )
            if not ref_ids or not related_ids:
                self.error("RELATION", resource.path, 0, "every canonical resource needs at least one relationship")
            resource.refs = resolved_refs
            resource.related = resolved_related

        for resource in self.resources.values():
            for link in resource.related:
                target = self.resources.get(link.resolved_rel or "")
                if not target:
                    continue
                target_ids = {item.target_id for item in target.related}
                if resource.resource_id not in target_ids:
                    self.error(
                        "RECIPROCAL",
                        resource.path,
                        link.line,
                        f"target {target.rel} does not link back to {resource.resource_id}",
                    )

    def index_target(self, target: str, line: int) -> Optional[str]:
        target = target.strip()
        if (
            not target
            or target.startswith(("/", "\\", "~"))
            or re.match(r"^[A-Za-z][A-Za-z0-9+.-]*:", target)
            or "#" in target
            or "?" in target
            or "\\" in target
        ):
            self.error("INDEX", "docs-harness/INDEX.md", line, f"INDEX link is not a relative path: {target}")
            return None

        candidate = (self.root / "docs-harness" / target).resolve()
        try:
            return candidate.relative_to(self.root).as_posix()
        except ValueError:
            self.error("INDEX", "docs-harness/INDEX.md", line, f"INDEX link escapes repository: {target}")
            return None

    def validate_index_link(
        self,
        label: str,
        target: str,
        line: int,
        expected_kind: str,
        priority: Optional[str] = None,
    ) -> Optional[Resource]:
        relative = self.index_target(target, line)
        resource = self.resources.get(relative or "")
        if not resource:
            self.error("INDEX", "docs-harness/INDEX.md", line, f"INDEX target is not a canonical resource: {target}")
            return None
        if resource.kind != expected_kind:
            self.error("INDEX", "docs-harness/INDEX.md", line, f"INDEX target must be under {expected_kind}/")

        label_parts = label.strip().split(None, 1)
        label_id = label_parts[0] if label_parts else ""
        label_title = label_parts[1] if len(label_parts) == 2 else ""
        if label_id != resource.resource_id:
            self.error("INDEX", "docs-harness/INDEX.md", line, "INDEX label ID does not match target resource")
        if label_title != (resource.title or ""):
            self.error("INDEX", "docs-harness/INDEX.md", line, "INDEX label title does not match target TITLE")
        if priority and f"[{priority}]" != resource.priority:
            self.error("INDEX", "docs-harness/INDEX.md", line, "INDEX priority does not match resource PRIORITY")
        return resource

    def validate_index(self) -> None:
        index_path = self.root / "docs-harness" / "INDEX.md"
        self.index_lines = self.read_lines(index_path)
        if not self.index_lines and not index_path.is_file():
            return

        resource_risks = {
            resource.rel: resource for resource in self.resources.values() if resource.kind == "risks"
        }
        resource_proposals = {
            resource.rel: resource for resource in self.resources.values() if resource.kind == "proposals"
        }
        risk_heading = next(
            (index for index, line in enumerate(self.index_lines) if line.strip() == "## TAG: [RISK]"),
            None,
        )
        risk_entries: List[Tuple[int, Resource, List[Resource]]] = []
        allowed_index_links: Set[Tuple[int, str]] = set()

        if risk_heading is None:
            self.error("INDEX", index_path, 0, "TAG: [RISK] section is required")
        if not any(line.strip() == "### proposals/" for line in self.index_lines):
            self.error("INDEX", index_path, 0, "supporting proposals/ routing section is required")

        if risk_heading is not None:
            section_end = len(self.index_lines)
            for index in range(risk_heading + 1, len(self.index_lines)):
                if self.index_lines[index].startswith("## "):
                    section_end = index
                    break

            resources_heading = next(
                (
                    index
                    for index in range(risk_heading + 1, section_end)
                    if self.index_lines[index].strip() == "Resources:"
                ),
                None,
            )
            current: Optional[Tuple[int, Resource, List[Resource]]] = None
            if resources_heading is not None:
                for index in range(resources_heading + 1, section_end):
                    line = self.index_lines[index]
                    top_match = TOP_INDEX_RE.match(line)
                    nested_match = NESTED_INDEX_RE.match(line)
                    if top_match:
                        resource = self.validate_index_link(
                            top_match.group(1),
                            top_match.group(2),
                            index + 1,
                            "risks",
                            top_match.group(3),
                        )
                        if resource:
                            current = (index + 1, resource, [])
                            risk_entries.append(current)
                            allowed_index_links.add((index + 1, top_match.group(2)))
                        else:
                            current = None
                    elif nested_match:
                        if current is None:
                            self.error("INDEX", index_path, index + 1, "proposal link must be nested under a risk")
                        else:
                            proposal = self.validate_index_link(
                                nested_match.group(1),
                                nested_match.group(2),
                                index + 1,
                                "proposals",
                            )
                            allowed_index_links.add((index + 1, nested_match.group(2)))
                            if proposal:
                                current[2].append(proposal)
                    elif LINK_RE.search(line) and any(
                        part in line for part in ("risks/", "proposals/")
                    ):
                        self.error(
                            "INDEX",
                            index_path,
                            index + 1,
                            "canonical INDEX links must use the strict risk/nested-proposal grammar",
                        )
            else:
                self.error("INDEX", index_path, 0, "TAG: [RISK] section must contain a Resources: block")

        indexed_paths = [resource.rel for _, resource, _ in risk_entries]
        if len(indexed_paths) != len(set(indexed_paths)):
            self.error("INDEX", index_path, 0, "each risk must appear exactly once in INDEX.md")
        if set(indexed_paths) != set(resource_risks):
            self.error("INDEX", index_path, 0, "INDEX risk entries must match canonical risk files exactly")

        indexed_ids = [resource.resource_id for _, resource, _ in risk_entries]
        expected_ids = sorted(
            resource.resource_id for _, resource, _ in risk_entries if resource.resource_id
        )
        if indexed_ids != expected_ids:
            self.error("INDEX", index_path, 0, "risk INDEX entries must be sorted by immutable ID")

        for _, resource, proposals in risk_entries:
            proposal_ids = [proposal.resource_id for proposal in proposals if proposal.resource_id]
            if len(proposal_ids) != len(set(proposal_ids)):
                self.error("INDEX", index_path, 0, f"nested proposals for {resource.rel} contain duplicates")
            if proposal_ids != sorted(proposal_ids):
                self.error("INDEX", index_path, 0, f"nested proposals for {resource.rel} must be sorted by immutable ID")
            expected_related_ids = {link.target_id for link in resource.related if link.target_id}
            if set(proposal_ids) != expected_related_ids:
                self.error("INDEX", index_path, 0, f"nested proposals for {resource.rel} must match all related proposals")

        for index, line in enumerate(self.index_lines, start=1):
            for match in LINK_RE.finditer(line):
                target = match.group(2).strip()
                if not (target.startswith("risks/") or target.startswith("proposals/")):
                    continue
                relative = self.index_target(target, index)
                if relative in resource_risks or relative in resource_proposals:
                    if (index, target) not in allowed_index_links:
                        self.error(
                            "INDEX",
                            index_path,
                            index,
                            "canonical resources may only be reached through the risk-only INDEX grammar",
                        )

    def run(self) -> int:
        before = self.snapshot()
        self.validate_scope()
        for path in sorted(self.resource_paths, key=self.rel):
            resource = self.parse_resource(path)
            self.resources[resource.rel] = resource
        self.validate_relationships()
        self.validate_index()

        delay_text = os.environ.get("HARNESS_VALIDATOR_TEST_DELAY_MS", "0")
        try:
            delay_ms = int(delay_text)
        except ValueError:
            self.error("TOOLING", ".", 0, "HARNESS_VALIDATOR_TEST_DELAY_MS must be an integer", fatal=True)
            delay_ms = 0
        if delay_ms > 0:
            time.sleep(delay_ms / 1000.0)

        after = self.snapshot()
        if before != after:
            self.error("SNAPSHOT", "docs-harness", 0, "validator scope changed during the run", fatal=True)

        code = 2 if self.fatal else (1 if self.errors else 0)
        if self.errors:
            for fatal, rule, path, line, message in sorted(
                self.errors, key=lambda item: (item[2], item[3], item[1], item[4])
            ):
                level = "FATAL" if fatal else "ERROR"
                location = f"{path}:{line}" if line else path
                print(f"{level}|{rule}|{location}|{message}")
            print(
                f"SUMMARY|status=FAIL|risks={sum(r.kind == 'risks' for r in self.resources.values())}"
                f"|proposals={sum(r.kind == 'proposals' for r in self.resources.values())}|exit={code}"
            )
        else:
            relationship_count = sum(len(resource.related) for resource in self.resources.values())
            print(
                "PASS|SUMMARY|"
                f"risks={sum(r.kind == 'risks' for r in self.resources.values())}|"
                f"proposals={sum(r.kind == 'proposals' for r in self.resources.values())}|"
                f"relationships={relationship_count}|snapshot=stable|exit=0"
            )
        return code


def main(argv: Sequence[str]) -> int:
    if len(argv) != 1:
        print("FATAL|USAGE|.|validator core expects exactly one repository root path")
        return 2
    return Validator(Path(argv[0])).run()


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
