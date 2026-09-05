#!/usr/bin/env python3
"""Utility script to verify and synchronize docs-harness/ filesystem with INDEX.md."""

from __future__ import annotations

import argparse
import os
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Set, Tuple

LINK_RE = re.compile(r"\[([^\]]+)\]\(([^)]+)\)")
TAG_RE = re.compile(r"^TAG:\s*(.*)$")
META_RE = re.compile(r"^(ID|TAG|PRIORITY|TITLE|CREATED|STATUS|REFERENCES):(?:[ \t]*(.*))?$")

CANONICAL_FOLDERS = (
    "harness-constraints",
    "decisions",
    "domain",
    "harness-improvements",
    "plans/active",
    "plans/completed",
    "tickets/active",
    "tickets/completed",
    "proposals",
    "risks",
)
DOMAIN_FOLDER = "domain"
DOMAIN_FOLDER_RE = re.compile(r"^(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])-[a-z0-9]+(?:-[a-z0-9]+)*$")


@dataclass
class ResourceItem:
    path: Path
    rel_path: str  # relative to docs-harness, e.g. "plans/active/0816-sample.md"
    resource_id: Optional[str] = None
    title: Optional[str] = None
    priority: Optional[str] = None
    created: Optional[str] = None
    status: Optional[str] = None
    references: List[str] = field(default_factory=list)
    tags: List[str] = field(default_factory=list)


def parse_resource_metadata(
    file_path: Path, docs_harness_root: Path, allow_readme: bool = False
) -> Optional[ResourceItem]:
    if (file_path.name == "README.md" and not allow_readme) or file_path.suffix != ".md":
        return None

    try:
        content = file_path.read_text(encoding="utf-8")
    except (OSError, UnicodeDecodeError):
        return None

    rel_path = file_path.relative_to(docs_harness_root).as_posix()
    item = ResourceItem(path=file_path, rel_path=rel_path)

    in_references = False
    for line in content.splitlines():
        if line.startswith("## "):
            break
        match = META_RE.match(line.strip())
        if match:
            key, val = match.group(1), (match.group(2) or "").strip()
            if key == "ID" and not item.resource_id:
                item.resource_id = val
            elif key == "TITLE" and not item.title:
                item.title = val
            elif key == "PRIORITY" and not item.priority:
                item.priority = val
            elif key == "CREATED" and not item.created:
                item.created = val
            elif key == "STATUS" and not item.status:
                item.status = val
            elif key == "REFERENCES":
                in_references = True
                if val:
                    item.references.append(val)
            elif key == "TAG":
                item.tags.append(val)
            if key != "REFERENCES":
                in_references = False
            continue
        if in_references and line.strip().startswith("- "):
            item.references.append(line.strip()[2:].strip())

    if not item.title:
        # Fallback to first heading if TITLE meta not explicitly found
        for line in content.splitlines():
            if line.startswith("# "):
                item.title = line[2:].strip()
                break
        if not item.title:
            item.title = file_path.stem

    if not item.priority:
        item.priority = "[NORMAL]"

    return item


def tag_tokens(tags: List[str]) -> List[str]:
    tokens: List[str] = []
    for tag in tags:
        matches = re.findall(r"\[([^\]]+)\]", tag)
        tokens.extend(matches or ([tag] if tag else []))
    return list(dict.fromkeys(tokens))


def target_sections(item: ResourceItem) -> List[str]:
    tokens = tag_tokens(item.tags)
    sections: List[str] = []
    domain_state = next(
        (token for token in tokens if token in {"CONFIRMED", "UNCERTAIN"}),
        None,
    )

    if "DOMAIN" in tokens and domain_state:
        sections.append(f"### [{domain_state}]")

    for token in tokens:
        if token in {"CONFIRMED", "UNCERTAIN"}:
            continue
        sections.append(f"## TAG: [{token}]")

    parts = item.rel_path.split("/")
    if len(parts) > 1 and parts[0] != DOMAIN_FOLDER:
        sections.append(f"### {'/'.join(parts[:2])}/")
    sections.append(f"### {parts[0]}/")
    return list(dict.fromkeys(sections))


def validate_domain_resource(
    file_path: Path, item: ResourceItem, docs_harness_root: Path
) -> List[str]:
    try:
        content = file_path.read_text(encoding="utf-8")
    except (OSError, UnicodeDecodeError):
        return [
            f"{file_path.relative_to(docs_harness_root).as_posix()}: "
            "cannot read README.md"
        ]

    rel_path = file_path.relative_to(docs_harness_root).as_posix()
    errors: List[str] = []
    required_metadata = (
        "ID",
        "TAG",
        "PRIORITY",
        "TITLE",
        "CREATED",
        "STATUS",
        "REFERENCES",
    )
    for key in required_metadata:
        if not re.search(rf"^{key}:", content, re.MULTILINE):
            errors.append(f"{rel_path}: missing {key} metadata")

    tokens = tag_tokens(item.tags)
    if "DOMAIN" not in tokens:
        errors.append(f"{rel_path}: TAG [DOMAIN] is required")
    if "CONFIRMED" not in tokens and "UNCERTAIN" not in tokens:
        errors.append(
            f"{rel_path}: TAG [CONFIRMED] or TAG [UNCERTAIN] is required"
        )
    if not item.resource_id or "<" in item.resource_id:
        errors.append(f"{rel_path}: concrete ID is required")
    if not item.priority or "<" in item.priority:
        errors.append(f"{rel_path}: concrete PRIORITY is required")
    if not item.title or "<" in item.title:
        errors.append(f"{rel_path}: concrete TITLE is required")
    if not re.fullmatch(r"\d{4}-\d{2}-\d{2}", item.created or ""):
        errors.append(f"{rel_path}: CREATED must be YYYY-MM-DD")
    if not item.status or "<" in item.status:
        errors.append(f"{rel_path}: concrete STATUS is required")
    if not item.references or any("<" in reference for reference in item.references):
        errors.append(
            f"{rel_path}: at least one concrete REFERENCES entry is required"
        )

    for heading in (
        "Domain Statement",
        "Evidence/Authority",
        "Freshness",
        "Confidence",
        "Open Questions",
    ):
        if not re.search(rf"^## {re.escape(heading)}$", content, re.MULTILINE):
            errors.append(f"{rel_path}: missing ## {heading} section")

    freshness_match = re.search(r"^Freshness:\s*(CURRENT|STALE)\s*$", content, re.MULTILINE)
    if not freshness_match:
        errors.append(f"{rel_path}: Freshness must be CURRENT or STALE")
    elif freshness_match.group(1) == "STALE" and item.status != "needs-review":
        errors.append(f"{rel_path}: STALE freshness requires STATUS: needs-review")
    elif item.status == "needs-review" and freshness_match.group(1) != "STALE":
        errors.append(
            f"{rel_path}: STATUS: needs-review requires Freshness: STALE"
        )

    return errors


class IndexSync:
    def __init__(self, root: Path) -> None:
        self.root = root.resolve()
        self.docs_harness = self.root / "docs-harness"
        self.index_path = self.docs_harness / "INDEX.md"
        self.resources: Dict[str, ResourceItem] = {}
        self.layout_errors: List[str] = []
        self.duplicate_ids: List[str] = []

    def discover_resources(self) -> None:
        self.resources.clear()
        self.layout_errors.clear()
        self.duplicate_ids.clear()
        if not self.docs_harness.exists():
            return

        for folder_rel in CANONICAL_FOLDERS:
            folder = self.docs_harness / folder_rel
            if not folder.exists():
                continue
            if folder_rel == DOMAIN_FOLDER:
                for entry in sorted(folder.iterdir()):
                    if entry.is_dir():
                        if not DOMAIN_FOLDER_RE.fullmatch(entry.name):
                            self.layout_errors.append(
                                f"domain/{entry.name}: folder name must match "
                                "<MMDD>-<lowercase-kebab-case-name>"
                            )
                        readme = entry / "README.md"
                        if not readme.is_file():
                            self.layout_errors.append(
                                f"{entry.relative_to(self.docs_harness).as_posix()}: "
                                "README.md is required"
                            )
                            continue
                        item = parse_resource_metadata(
                            readme, self.docs_harness, allow_readme=True
                        )
                        if item:
                            self.resources[item.rel_path] = item
                            self.layout_errors.extend(
                                validate_domain_resource(
                                    readme, item, self.docs_harness
                                )
                            )
                    elif entry.is_file() and entry.suffix == ".md" and entry.name != "README.md":
                        self.layout_errors.append(
                            f"{entry.relative_to(self.docs_harness).as_posix()}: "
                            "domain resources must use a date-prefixed folder with README.md"
                        )
                        item = parse_resource_metadata(entry, self.docs_harness)
                        if item:
                            self.resources[item.rel_path] = item
                            self.layout_errors.extend(
                                validate_domain_resource(
                                    entry, item, self.docs_harness
                                )
                            )
                continue
            for entry in sorted(folder.glob("*.md")):
                if entry.name == "README.md":
                    continue
                item = parse_resource_metadata(entry, self.docs_harness)
                if item:
                    self.resources[item.rel_path] = item

        seen_ids: Dict[str, str] = {}
        for item in self.resources.values():
            if not item.resource_id:
                continue
            if item.resource_id in seen_ids:
                self.duplicate_ids.append(
                    f"{item.resource_id}: {seen_ids[item.resource_id]}, {item.rel_path}"
                )
            else:
                seen_ids[item.resource_id] = item.rel_path

    def check(self) -> Tuple[List[str], List[str]]:
        """Returns (missing_in_index, stale_in_index)."""
        self.discover_resources()
        if not self.index_path.exists():
            return [f"INDEX.md not found at {self.index_path}"], []

        index_content = self.index_path.read_text(encoding="utf-8")
        indexed_links = set()
        for match in LINK_RE.finditer(index_content):
            target = match.group(2).strip()
            if not target.startswith(("http://", "https://", "#", "mailto:")):
                # normalize relative path
                clean_target = target.split("#")[0].split("?")[0]
                indexed_links.add(clean_target)

        missing_in_index: List[str] = []
        for rel_path, item in self.resources.items():
            if rel_path not in indexed_links:
                missing_in_index.append(rel_path)

        stale_in_index: List[str] = []
        for target in indexed_links:
            # Check if target is inside docs-harness canonical paths
            target_path = self.docs_harness / target
            is_canonical = any(
                target == cf or target.startswith(f"{cf}/")
                for cf in CANONICAL_FOLDERS
            )
            if is_canonical and not target_path.exists():
                stale_in_index.append(target)

        return sorted(missing_in_index), sorted(stale_in_index)

    def fix(self) -> bool:
        """Fixes missing and stale links in INDEX.md."""
        missing, stale = self.check()
        if self.layout_errors or self.duplicate_ids:
            return False
        if not missing and not stale:
            return False

        if not self.index_path.exists():
            print(f"Error: {self.index_path} does not exist.")
            return False

        lines = self.index_path.read_text(encoding="utf-8").splitlines()
        new_lines: List[str] = []

        # 1. Remove stale lines referencing deleted canonical files
        for line in lines:
            matches = list(LINK_RE.finditer(line))
            is_stale_line = False
            for m in matches:
                target = m.group(2).strip()
                if target in stale:
                    is_stale_line = True
                    break
            if not is_stale_line:
                new_lines.append(line)

        lines = new_lines

        # 2. Insert missing resources into matching sections
        for rel_path in missing:
            item = self.resources.get(rel_path)
            if not item:
                continue

            id_str = f"`{item.resource_id}`, " if item.resource_id else ""
            entry_line = f"- [{item.title}]({item.rel_path}) — {id_str}`PRIORITY: {item.priority}`"

            # Determine target section headers
            section_headers = target_sections(item)

            inserted = False
            for sec_header in section_headers:
                for idx, line in enumerate(lines):
                    if line.strip() == sec_header:
                        # Find "Resources:" under this section
                        for res_idx in range(idx + 1, min(idx + 30, len(lines))):
                            if lines[res_idx].strip() == "Resources:":
                                # Check if already added or "No ... indexed yet."
                                next_line_idx = res_idx + 1
                                while next_line_idx < len(lines) and not lines[next_line_idx].strip():
                                    next_line_idx += 1
                                if (
                                    next_line_idx < len(lines)
                                    and "No " in lines[next_line_idx]
                                    and "indexed yet" in lines[next_line_idx]
                                ):
                                    # Replace placeholder
                                    lines[next_line_idx] = entry_line
                                else:
                                    lines.insert(res_idx + 2, entry_line)
                                inserted = True
                                break
                        if inserted:
                            break
                if inserted:
                    break

            if not inserted:
                # Fallback: append at end of plans/active or supporting folder
                lines.append(entry_line)

        self.index_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
        return True


def main() -> int:
    parser = argparse.ArgumentParser(description="Synchronize docs-harness filesystem with INDEX.md")
    parser.add_argument("--root", type=str, default=".", help="Repository root directory")
    parser.add_argument("--fix", action="store_true", help="Automatically fix discrepancies in INDEX.md")
    parser.add_argument("--check", action="store_true", help="Check synchronization status (default)")

    args = parser.parse_args()
    root_path = Path(args.root).resolve()
    syncer = IndexSync(root_path)

    if args.fix:
        syncer.check()
        if syncer.layout_errors or syncer.duplicate_ids:
            print("Synchronization check: FAILED")
            if syncer.layout_errors:
                print(f"Invalid domain layout ({len(syncer.layout_errors)}):")
                for error in syncer.layout_errors:
                    print(f"  - {error}")
            if syncer.duplicate_ids:
                print(f"Duplicate resource IDs ({len(syncer.duplicate_ids)}):")
                for duplicate in syncer.duplicate_ids:
                    print(f"  - {duplicate}")
            return 1
        modified = syncer.fix()
        if modified:
            print("Successfully synchronized and updated docs-harness/INDEX.md.")
        else:
            print("docs-harness/INDEX.md is already up-to-date.")
        return 0
    else:
        missing, stale = syncer.check()
        if missing or stale or syncer.layout_errors or syncer.duplicate_ids:
            print("Synchronization check: FAILED")
            if missing:
                print(f"Missing from INDEX.md ({len(missing)}):")
                for item in missing:
                    print(f"  + {item}")
            if stale:
                print(f"Stale links in INDEX.md ({len(stale)}):")
                for item in stale:
                    print(f"  - {item}")
            if syncer.layout_errors:
                print(f"Invalid domain layout ({len(syncer.layout_errors)}):")
                for error in syncer.layout_errors:
                    print(f"  - {error}")
            if syncer.duplicate_ids:
                print(f"Duplicate resource IDs ({len(syncer.duplicate_ids)}):")
                for duplicate in syncer.duplicate_ids:
                    print(f"  - {duplicate}")
            print("\nRun with --fix to automatically synchronize docs-harness/INDEX.md.")
            return 1
        else:
            print("Synchronization check: PASSED (docs-harness and INDEX.md are in sync).")
            return 0


if __name__ == "__main__":
    sys.exit(main())
