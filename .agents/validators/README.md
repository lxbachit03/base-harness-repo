# Harness Structural Validation

Uses Node.js; verified in this task on v24.18.0. No package dependencies.
Other runtime versions are not certified by this replay.

Run from the repository root:

- node .agents/validators/sync-harness-index.js --check
- node --test .agents/validators/sync-harness-index.test.js
- git diff --check

When invoking the engine from another working directory, supply --root with
the repository path. The engine defaults to the current working directory.

## What the engine checks

The JavaScript file is the single implementation and command-line entry point.
Run it directly with Node; Python and Bash launchers are no longer maintained.
Historical plans may name removed launchers as evidence of past executions;
use the current commands above for new work.

Checks cover the complete folder tree; folder route metadata and Resources
blocks; local INDEX links including templates; canonical classification and
lifecycle routes; duplicate full IDs and numeric sequences; concrete metadata;
domain layout, confirmation state and freshness/status; and reciprocal
risk/proposal references with required evidence sections.

Both risks/ and proposals/ must be real, flat directories containing Markdown
files only (README.md is guidance, not a paired resource). Each relationship
block requires one counterpart per bullet: a Markdown link with the target's
exact ID and title, a canonical relative path, or an immutable resource ID.
Malformed entries and duplicate counterparts are rejected, including aliases
that resolve to the same resource. REFERENCES and related sections must name
the same counterparts, and every counterpart must link back.

Domain IDs retain creation kind after confirmation. One canonical resource can
appear in multiple appropriate routes but once per route. Ticket bodies and
unidentified supporting artifacts are not canonical resources. The engine
does not follow symlinked directories and fails with an explicit scope error.

Risk/proposal routes use the same canonical entry format as other resources.
The earlier nested-proposal-only INDEX grammar and its special log format are
retired. Reciprocal references and related sections remain required.
The full --check command includes risk/proposal links and routing. The Node
regression suite includes risk/proposal cases; passing it does not establish
full legacy parity.

## Check, fix, and limits

Check mode reads only. Exit 0 means the named structural checks passed, 1 means
invalid content, and 2 means usage/tooling or concurrent snapshot change.
Markdown is decoded as strict UTF-8. Snapshot comparison hashes raw bytes for
all scoped files, so line-ending and non-Markdown content changes are detected
even when their parsed content is unchanged.

--fix can rebuild an existing tree block and insert missing canonical entries
in existing routes. It plans changes in memory and checks the entire result
before writing INDEX.md. It refuses ambiguous IDs/sections, duplicates, stale
links, or invalid domain/risk state; repair these explicitly. It does not delete
whole lines to fix broken links. It rechecks source state before applying.

The test suite uses in-memory counterexamples and isolated temporary CLI
fixtures, with target-checked cleanup. It never edits the working INDEX.
If authority is limited to read-only proof, use:

- node --test --test-skip-pattern '^(CLI|concurrent)' .agents/validators/sync-harness-index.test.js

This excludes filesystem-mutating CLI/concurrency fixtures; it is not a full
suite result. Do not substitute a negative --test-name-pattern: a file-ancestor
match can cause its descendant fixture tests to run.

Not verified: source-claim truth, remote URLs, runtime behavior, or agent
effectiveness. Use relevant source inspection or a fresh behavior replay for
those claims.

The behavior-parity audit in docs-harness/plans/active/0906-behavior-parity-audit.md
records restored checks, named evidence, and unresolved policy choices. Old
Python/Bash entry points remain deleted by User request. Changed INDEX grammar,
CLI/log formatting, and conservative fix behavior are not legacy-compatible
interfaces merely because the restored checks pass.
