#!/usr/bin/env python3
"""Read-only Harness drift check.

Usage (from any directory):
    python -I .agents/skills/harness-check/scripts/harness_check.py
        [--quick] [--requirements] [--root PATH]

--quick         run only INDEX's session-start alignment check
--requirements  also print docs/raw-requirements/ as indented text for the
                agent's requirement comparison
--root PATH     check another checkout (default: the repository that holds
                this script)

The script only reads files and writes only to stdout.
Exit code: 0 clean, 1 drift found, 2 error.
Every check names the rule it enforces and that rule's owner. The script
judges structure only, never business facts or what a requirement means.
"""

import argparse
import json
import os
import re
import sys
import urllib.parse
from collections import Counter

INDEX_RULE = "docs-harness/INDEX.md > Session retrieval"
IDENTITY_RULE = "docs-harness/templates/README.md > Immutable identity"
METADATA_RULE = "docs-harness/templates/README.md > Common metadata"
ENTRY_RULE = "docs-harness/INDEX.md > Resource Routing Rules"
LINK_RULE = "docs-harness/templates/README.md > Routing and proof"
MIRROR_RULE = "docs/tools/claude/README.md > 7.1"
README_RULE = "docs/raw-requirements/skills/init-harness-repo.json > Yêu cầu 1.6"
REQUIREMENTS_RULE = "docs/raw-requirements/README.md > JSON format"

PRIORITIES = ("[CRITIAL]", "[MEDIUM]", "[NORMAL]")
REQUIRED_FIELDS = ("ID", "PRIORITY", "TITLE", "CREATED", "STATUS", "REFERENCES")
SKIPPED_DIRS = (".claude/skills", "docs-harness/templates")

FENCE_RE = re.compile(r"^\s*(```|~~~)")
INLINE_CODE_RE = re.compile(r"(`+)(.+?)\1")
LINK_RE = re.compile(r"\]\((<[^>\n]*>|[^)\s]+)(?:\s+\"[^\"\n]*\")?\)")
HEADING_RE = re.compile(r"^#{1,6}\s+(.*?)\s*#*\s*$")
ANCHOR_ATTR_RE = re.compile(r"""\b(?:id|name)\s*=\s*["']([^"']+)["']""")
SCHEME_RE = re.compile(r"^[A-Za-z][A-Za-z0-9+.-]*:")
FIELD_RE = re.compile(r"^([A-Z]+):\s*(.*)$")
ID_RE = re.compile(r"^#(\d{3,})_([A-Z][A-Z_]*)_(\d{4})$")
DATE_RE = re.compile(r"^\d{4}-(\d{2})-(\d{2})$")
INDEX_ENTRY_RE = re.compile(
    "^- \\[[^\\]]*\\]\\(([^)\\s]+)\\)\\s*—\\s*`(#\\d{3,}_[A-Z][A-Z_]*_\\d{4})`,"
    "\\s*`PRIORITY:\\s*(\\[[A-Z]+\\])`")
TREE_LINE_RE = re.compile(
    "^((?:│   |    )*)(?:├── |└── )(.+?)\\s*$")


def key(path):
    """Comparable form of a path (case-insensitive where the OS is)."""
    return os.path.normcase(os.path.abspath(path))


def read_bytes(path):
    with open(path, "rb") as handle:
        return handle.read()


def strip_code(text, inline=True):
    """Blank fenced blocks (and inline code spans) while keeping line count."""
    lines, fence = [], None
    for line in text.split("\n"):
        match = FENCE_RE.match(line)
        if match:
            if fence is None:
                fence = match.group(1)
            elif match.group(1) == fence:
                fence = None
            lines.append("")
        elif fence is not None:
            lines.append("")
        else:
            lines.append(INLINE_CODE_RE.sub(" ", line) if inline else line)
    return "\n".join(lines)


def heading_slugs(heading, seen):
    """GitHub-style anchor for a heading, plus an underscore-free variant."""
    text = re.sub(r"!?\[([^\]]*)\]\([^)]*\)", r"\1", heading)
    text = re.sub(r"<[^>]+>", "", text)
    text = re.sub(r"[`*~]", "", text)
    base = re.sub(r"[^\w\- ]", "", text.strip().lower()).replace(" ", "-")
    count = seen[base]
    seen[base] += 1
    slug = base if count == 0 else "%s-%d" % (base, count)
    return {slug, slug.replace("_", "")}


def metadata(text):
    """Fields such as ID or STATUS written before the first level-two heading."""
    head = re.split(r"^## ", text, maxsplit=1, flags=re.M)[0]
    fields = {}
    for line in head.split("\n"):
        match = FIELD_RE.match(line.strip())
        if match and match.group(1) not in fields:
            fields[match.group(1)] = match.group(2).strip()
    return fields


def folder_tree(index_text):
    """Folder paths drawn in INDEX's Folder Tree block, or None if absent."""
    lines = index_text.split("\n")
    start = next((i for i, line in enumerate(lines)
                  if line.strip() == "## Folder Tree"), None)
    if start is None:
        return None
    opened, tree, stack = False, set(), []
    for line in lines[start + 1:]:
        if FENCE_RE.match(line):
            if opened:
                break
            opened = True
            continue
        if not opened:
            if line.startswith("## "):
                return None
            continue
        match = TREE_LINE_RE.match(line)
        if not match or not match.group(2).endswith("/"):
            continue
        depth = len(match.group(1)) // 4
        stack = stack[:depth] + [match.group(2)[:-1]]
        tree.add("/".join(stack))
    return tree if opened else None


def tree_files(base):
    files = {}
    for dirpath, dirnames, filenames in os.walk(base):
        dirnames[:] = sorted(d for d in dirnames if d != "__pycache__")
        for name in filenames:
            path = os.path.join(dirpath, name)
            files[os.path.relpath(path, base).replace(os.sep, "/")] = path
    return files


def requirement_lines(node, depth=0):
    title = str(node.get("title", "")).strip()
    text = str(node.get("text", "")).strip().replace("\n", " ¶ ")
    yield "  " * depth + "- " + title + (": " + text if text else "")
    for child in node.get("children") or []:
        for line in requirement_lines(child, depth + 1):
            yield line


class Report:
    def __init__(self):
        self.rows = []

    def add(self, status, check, owner, summary, items=()):
        self.rows.append((status, check, owner, summary, list(items)))

    def drift(self):
        return sum(1 for row in self.rows if row[0] == "drift")

    def emit(self):
        for status, check, owner, summary, items in self.rows:
            print("[%s] %s: %s (rule: %s)" % (status, check, summary, owner))
            for item in items:
                print("    - " + item)


class Checker:
    def __init__(self, root):
        self.root = root
        self.harness = os.path.join(root, "docs-harness")
        self.index = os.path.join(self.harness, "INDEX.md")
        self._text, self._anchors, self._names = {}, {}, {}

    # File access -------------------------------------------------------

    def text(self, path):
        k = key(path)
        if k not in self._text:
            with open(path, encoding="utf-8", errors="replace") as handle:
                self._text[k] = handle.read().replace("\r\n", "\n")
        return self._text[k]

    def rel(self, path):
        return os.path.relpath(path, self.root).replace(os.sep, "/")

    def hrel(self, path):
        return os.path.relpath(path, self.harness).replace(os.sep, "/")

    def names(self, folder):
        k = key(folder)
        if k not in self._names:
            self._names[k] = set(os.listdir(folder))
        return self._names[k]

    def exact_case(self, path):
        """False when the path exists only through a case-insensitive file system."""
        relative = os.path.relpath(path, self.root)
        if relative.startswith(os.pardir):
            return True
        current = self.root
        for part in relative.split(os.sep):
            if part in ("", "."):
                continue
            if part not in self.names(current):
                return False
            current = os.path.join(current, part)
        return True

    # Links ---------------------------------------------------------------

    def links(self, path):
        for match in LINK_RE.finditer(strip_code(self.text(path))):
            target = match.group(1)
            if target.startswith("<") and target.endswith(">"):
                target = target[1:-1]
            yield target

    def resolve(self, source, target):
        """(destination, fragment) of a local link; None for an external one."""
        if SCHEME_RE.match(target) or target.startswith("//"):
            return None
        path_part, _, fragment = target.partition("#")
        path_part = urllib.parse.unquote(path_part)
        if not path_part:
            dest = source
        elif path_part.startswith("/"):
            dest = os.path.join(self.root, path_part.lstrip("/"))
        else:
            dest = os.path.join(os.path.dirname(source), path_part)
        return os.path.normpath(dest), urllib.parse.unquote(fragment)

    def anchors(self, path):
        k = key(path)
        if k not in self._anchors:
            found, seen = set(), Counter()
            for line in strip_code(self.text(path), inline=False).split("\n"):
                heading = HEADING_RE.match(line)
                if heading:
                    found.update(heading_slugs(heading.group(1), seen))
                for attr in ANCHOR_ATTR_RE.finditer(line):
                    found.add(attr.group(1).lower())
            self._anchors[k] = found
        return self._anchors[k]

    def local_link(self, source, target):
        """(is_local, problem); problem is None when the link resolves."""
        resolved = self.resolve(source, target)
        if resolved is None:
            return False, None
        dest, fragment = resolved
        if not os.path.exists(dest):
            return True, "missing target"
        if not self.exact_case(dest):
            return True, "letter case differs from disk"
        if fragment and os.path.isfile(dest) and dest.lower().endswith(".md"):
            if fragment.lower() not in self.anchors(dest):
                return True, "missing anchor"
        return True, None

    # Resources -----------------------------------------------------------

    def resources(self):
        """(path, fields) for every docs-harness/ Markdown file with an ID line."""
        found = []
        for dirpath, dirnames, filenames in os.walk(self.harness):
            dirnames.sort()
            if key(dirpath) == key(self.harness):
                dirnames[:] = [d for d in dirnames if d != "templates"]
            for name in sorted(filenames):
                if name.endswith(".md"):
                    path = os.path.join(dirpath, name)
                    fields = metadata(self.text(path))
                    if "ID" in fields:
                        found.append((path, fields))
        return found

    def index_readmes(self):
        """docs-harness README.md files that INDEX links: the lists it routes."""
        readmes, seen = [], set()
        inside = key(self.harness) + os.sep
        for target in self.links(self.index):
            resolved = self.resolve(self.index, target)
            if resolved is None:
                continue
            dest = resolved[0]
            if (os.path.basename(dest) == "README.md" and os.path.isfile(dest)
                    and key(dest).startswith(inside) and key(dest) not in seen):
                seen.add(key(dest))
                readmes.append(dest)
        return readmes

    def routes(self):
        """Files INDEX links directly, and files a folder README it links links."""
        direct, via_readme = set(), set()
        for target in self.links(self.index):
            resolved = self.resolve(self.index, target)
            if resolved is not None:
                direct.add(key(resolved[0]))
        for readme in self.index_readmes():
            for target in self.links(readme):
                resolved = self.resolve(readme, target)
                if resolved is not None:
                    via_readme.add(key(resolved[0]))
        return direct, via_readme

    # Quick checks (INDEX session-start alignment) ------------------------

    def check_routing(self, report, resources):
        direct, via_readme = self.routes()
        unrouted, readme_only = [], []
        for path, fields in resources:
            label = "%s (%s)" % (self.rel(path), fields["ID"])
            if key(path) in direct:
                continue
            (readme_only if key(path) in via_readme else unrouted).append(label)
        if unrouted:
            report.add("drift", "routing", INDEX_RULE,
                       "%d resource(s) with an ID that INDEX does not route"
                       % len(unrouted), unrouted)
        else:
            report.add("ok", "routing", INDEX_RULE,
                       "all %d resources with an ID are routed" % len(resources))
        if readme_only:
            report.add("info", "routing", INDEX_RULE,
                       "%d resource(s) routed through a folder README that INDEX links"
                       % len(readme_only))

    def check_index_links(self, report):
        checked, problems = 0, []
        for target in self.links(self.index):
            is_local, problem = self.local_link(self.index, target)
            checked += is_local
            if problem:
                problems.append("%s (%s)" % (target, problem))
        if problems:
            report.add("drift", "index-links", INDEX_RULE,
                       "%d of %d local INDEX links fail" % (len(problems), checked),
                       problems)
        else:
            report.add("ok", "index-links", INDEX_RULE,
                       "%d local INDEX links resolve" % checked)

    def check_folder_tree(self, report):
        tree = folder_tree(self.text(self.index))
        if tree is None:
            report.add("drift", "folder-tree", INDEX_RULE,
                       "INDEX has no Folder Tree code block")
            return
        disk = set()
        for dirpath, dirnames, _ in os.walk(self.harness):
            for name in dirnames:
                disk.add(self.hrel(os.path.join(dirpath, name)))
        items = (["on disk, missing from Folder Tree: " + p for p in sorted(disk - tree)]
                 + ["in Folder Tree, missing on disk: " + p for p in sorted(tree - disk)])
        if items:
            report.add("drift", "folder-tree", INDEX_RULE,
                       "%d folder mismatch(es)" % len(items), items)
        else:
            report.add("ok", "folder-tree", INDEX_RULE,
                       "%d folders match the Folder Tree" % len(disk))

    # Full checks ---------------------------------------------------------

    def check_ids(self, report, resources):
        by_full, by_number, problems = {}, {}, []
        for path, fields in resources:
            match = ID_RE.match(fields["ID"])
            if not match:
                problems.append("%s: malformed ID '%s'" % (self.rel(path), fields["ID"]))
                continue
            by_full.setdefault(fields["ID"], []).append(self.rel(path))
            by_number.setdefault(int(match.group(1)), set()).add(fields["ID"])
            mmdd = match.group(3)
            named = os.path.basename(os.path.dirname(path)) \
                if os.path.basename(path) == "README.md" else os.path.basename(path)
            prefix = re.match(r"^(\d{4})-", named)
            if prefix and prefix.group(1) != mmdd:
                problems.append("%s: name prefix %s differs from ID date %s"
                                % (self.rel(path), prefix.group(1), mmdd))
            created = DATE_RE.match(fields.get("CREATED", ""))
            if created and created.group(1) + created.group(2) != mmdd:
                problems.append("%s: CREATED %s differs from ID date %s"
                                % (self.rel(path), fields["CREATED"], mmdd))
        for full, paths in sorted(by_full.items()):
            if len(paths) > 1:
                problems.append("duplicate ID %s: %s" % (full, ", ".join(paths)))
        for number, fulls in sorted(by_number.items()):
            if len(fulls) > 1:
                problems.append("sequence %03d reused: %s" % (number, ", ".join(sorted(fulls))))
        numbers = sorted(by_number)
        span = "#%03d-#%03d" % (numbers[0], numbers[-1]) if numbers else "none"
        if problems:
            report.add("drift", "ids", IDENTITY_RULE,
                       "%d problem(s) among %d IDs (%s)" % (len(problems), len(by_full), span),
                       problems)
        else:
            report.add("ok", "ids", IDENTITY_RULE,
                       "%d unique IDs, %s, dates consistent" % (len(by_full), span))
        if numbers:
            gaps = [n for n in range(numbers[0], numbers[-1] + 1) if n not in by_number]
            if gaps:
                report.add("info", "ids", IDENTITY_RULE,
                           "unused sequence numbers (a retired number stays consumed): "
                           + ", ".join("%03d" % n for n in gaps))

    def check_metadata(self, report, resources):
        problems, statuses = [], Counter()
        for path, fields in resources:
            where = self.hrel(path)
            needed = REQUIRED_FIELDS if where.startswith("plans/") else REQUIRED_FIELDS + ("TAG",)
            missing = [name for name in needed if name not in fields]
            if missing:
                problems.append("%s: missing %s" % (self.rel(path), ", ".join(missing)))
            if "PRIORITY" in fields and fields["PRIORITY"] not in PRIORITIES:
                problems.append("%s: PRIORITY %s is not one of %s"
                                % (self.rel(path), fields["PRIORITY"], " ".join(PRIORITIES)))
            if "CREATED" in fields and not DATE_RE.match(fields["CREATED"]):
                problems.append("%s: CREATED %s is not YYYY-MM-DD"
                                % (self.rel(path), fields["CREATED"]))
            status = fields.get("STATUS", "")
            statuses[status or "(none)"] += 1
            if where.startswith("plans/completed/") and status.lower() != "completed":
                problems.append("%s: STATUS %s in plans/completed/ (plans/README.md > Lifecycle)"
                                % (self.rel(path), status or "(none)"))
            if where.startswith("plans/active/") and status.lower() == "completed":
                problems.append("%s: STATUS completed in plans/active/ (plans/README.md > Lifecycle)"
                                % self.rel(path))
        summary = "%d resources; STATUS %s" % (
            len(resources), ", ".join("%s %d" % item for item in sorted(statuses.items())))
        if problems:
            report.add("drift", "metadata", METADATA_RULE, summary, problems)
        else:
            report.add("ok", "metadata", METADATA_RULE, summary)

    def check_index_entries(self, report, resources):
        by_key = dict((key(path), fields) for path, fields in resources)
        problems, seen, count = [], set(), 0
        for source in [self.index] + self.index_readmes():
            section = self.hrel(source)
            for line in strip_code(self.text(source), inline=False).split("\n"):
                if line.startswith("#"):
                    section = "%s > %s" % (self.hrel(source), line.lstrip("#").strip())
                    continue
                match = INDEX_ENTRY_RE.match(line)
                if not match:
                    continue
                count += 1
                target, entry_id, priority = match.groups()
                dest = os.path.normpath(os.path.join(os.path.dirname(source),
                                                     urllib.parse.unquote(target)))
                fields = by_key.get(key(dest))
                if fields is None:
                    problems.append("[%s] %s: target has no ID metadata" % (section, target))
                    continue
                if fields["ID"] != entry_id:
                    problems.append("[%s] %s: entry says %s, file says %s"
                                    % (section, target, entry_id, fields["ID"]))
                if fields.get("PRIORITY") != priority:
                    problems.append("[%s] %s: entry says %s, file says %s"
                                    % (section, target, priority, fields.get("PRIORITY")))
                if (section, key(dest)) in seen:
                    problems.append("[%s] %s: listed twice in one route" % (section, target))
                seen.add((section, key(dest)))
        where = "INDEX and its folder READMEs"
        if problems:
            report.add("drift", "index-entries", ENTRY_RULE,
                       "%d problem(s) in %d ID entries in %s" % (len(problems), count, where),
                       problems)
        else:
            report.add("ok", "index-entries", ENTRY_RULE,
                       "%d ID entries in %s match their files' ID and PRIORITY" % (count, where))

    def check_links(self, report):
        skipped = set(key(os.path.join(self.root, p)) for p in SKIPPED_DIRS)
        files, checked, problems = 0, 0, []
        for dirpath, dirnames, filenames in os.walk(self.root):
            dirnames[:] = sorted(
                d for d in dirnames
                if d not in (".git", "node_modules")
                and key(os.path.join(dirpath, d)) not in skipped)
            for name in sorted(filenames):
                if not name.endswith(".md"):
                    continue
                path = os.path.join(dirpath, name)
                files += 1
                for target in self.links(path):
                    is_local, problem = self.local_link(path, target)
                    checked += is_local
                    if problem:
                        problems.append("%s: %s (%s)" % (self.rel(path), target, problem))
        summary = "%d of %d local links in %d Markdown files fail" % (len(problems), checked, files) \
            if problems else "%d local links in %d Markdown files resolve" % (checked, files)
        summary += "; skipped %s" % ", ".join(SKIPPED_DIRS)
        report.add("drift" if problems else "ok", "links", LINK_RULE, summary, problems)

    def check_mirror(self, report):
        source = os.path.join(self.root, ".agents", "skills")
        mirror = os.path.join(self.root, ".claude", "skills")
        if not (os.path.isdir(source) and os.path.isdir(mirror)):
            report.add("info", "skill-mirror", MIRROR_RULE,
                       "no .agents/skills or .claude/skills folder; nothing compared")
            return
        left, right = tree_files(source), tree_files(mirror)
        items, line_endings = [], []
        items += ["only in .agents/skills: " + p for p in sorted(set(left) - set(right))]
        items += ["only in .claude/skills: " + p for p in sorted(set(right) - set(left))]
        for path in sorted(set(left) & set(right)):
            a, b = read_bytes(left[path]), read_bytes(right[path])
            if a == b:
                continue
            if a.replace(b"\r\n", b"\n") == b.replace(b"\r\n", b"\n"):
                line_endings.append(path)
            else:
                items.append("content differs: " + path)
        skills = len(set(p.split("/")[0] for p in left))
        if items:
            report.add("drift", "skill-mirror", MIRROR_RULE,
                       "%d difference(s) across %d skills" % (len(items), skills), items)
        else:
            report.add("ok", "skill-mirror", MIRROR_RULE,
                       "%d skills, %d files identical" % (skills, len(left)))
        if line_endings:
            report.add("info", "skill-mirror", MIRROR_RULE,
                       "%d file(s) differ only in line endings" % len(line_endings),
                       line_endings)

    def check_readmes(self, report):
        missing, folders = [], 0
        for dirpath, dirnames, filenames in os.walk(self.harness):
            dirnames.sort()
            where = self.hrel(dirpath)
            if where.startswith("templates/"):
                continue
            folders += 1
            if "README.md" not in filenames:
                missing.append("docs-harness" if where == "." else "docs-harness/" + where)
        if missing:
            report.add("drift", "folder-readmes", README_RULE,
                       "%d of %d folders have no README.md (template scaffolds excluded)"
                       % (len(missing), folders), missing)
        else:
            report.add("ok", "folder-readmes", README_RULE,
                       "all %d folders have README.md (template scaffolds excluded)" % folders)

    def requirements(self, report):
        """Parse docs/raw-requirements/ and return its text lines for the agent."""
        base = os.path.join(self.root, "docs", "raw-requirements")
        lines, problems, count = [], [], 0
        if not os.path.isdir(base):
            report.add("info", "requirements", REQUIREMENTS_RULE, "docs/raw-requirements/ is absent")
            return lines
        for dirpath, dirnames, filenames in os.walk(base):
            dirnames.sort()
            for name in sorted(filenames):
                if not name.endswith(".json"):
                    continue
                path = os.path.join(dirpath, name)
                try:
                    node = json.loads(self.text(path))
                except ValueError as exc:
                    problems.append("%s: not valid JSON (%s)" % (self.rel(path), exc))
                    continue
                count += 1
                lines.append("### " + self.rel(path))
                lines.extend(requirement_lines(node))
        if problems:
            report.add("drift", "requirements", REQUIREMENTS_RULE,
                       "%d requirement file(s) unreadable" % len(problems), problems)
        else:
            report.add("ok", "requirements", REQUIREMENTS_RULE,
                       "%d requirement files parsed; printed below for comparison" % count)
        return lines


def default_root():
    here = os.path.dirname(os.path.abspath(__file__))
    return os.path.abspath(os.path.join(here, os.pardir, os.pardir, os.pardir, os.pardir))


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Read-only Harness drift check. Exit 0 clean, 1 drift, 2 error.")
    parser.add_argument("--quick", action="store_true",
                        help="only INDEX's session-start alignment check")
    parser.add_argument("--requirements", action="store_true",
                        help="also print docs/raw-requirements/ for the agent's comparison")
    parser.add_argument("--root", help="repository root to check (default: this script's repository)")
    args = parser.parse_args(argv)
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")

    root = os.path.abspath(args.root) if args.root else default_root()
    checker = Checker(root)
    if not os.path.isfile(checker.index):
        print("[error] no docs-harness/INDEX.md under %s" % root)
        return 2

    report = Report()
    resources = checker.resources()
    checker.check_routing(report, resources)
    checker.check_index_links(report)
    checker.check_folder_tree(report)
    requirement_text = []
    if not args.quick:
        checker.check_ids(report, resources)
        checker.check_metadata(report, resources)
        checker.check_index_entries(report, resources)
        checker.check_links(report)
        checker.check_mirror(report)
        checker.check_readmes(report)
        if args.requirements:
            requirement_text = checker.requirements(report)

    print("harness-check %s | root: %s" % ("quick" if args.quick else "full",
                                            root.replace(os.sep, "/")))
    report.emit()
    if requirement_text:
        print()
        print("## docs/raw-requirements (User-owned: compare with the implementation, never edit)")
        for line in requirement_text:
            print(line)
    drift = report.drift()
    print("RESULT: %s" % ("clean (exit 0)" if not drift
                          else "drift in %d check(s) (exit 1)" % drift))
    return 1 if drift else 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as exc:  # an unexpected failure is reported, never hidden
        print("[error] %s: %s" % (type(exc).__name__, exc))
        sys.exit(2)
