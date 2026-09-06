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

--fix can rebuild an existing tree block and insert missing canonical entries
in existing routes. It plans changes in memory and checks the entire result
before writing INDEX.md. It refuses ambiguous IDs/sections, duplicates, stale
links, or invalid domain/risk state; repair these explicitly. It does not delete
whole lines to fix broken links. It rechecks source state before applying.

The test suite uses in-memory counterexamples and isolated temporary CLI
fixtures, with target-checked cleanup. It never edits the working INDEX.

Not verified: source-claim truth, remote URLs, runtime behavior, or agent
effectiveness. Use relevant source inspection or a fresh behavior replay for
those claims.

Known gap from the legacy comparison: duplicate relationship entries within
REFERENCES or a related-resource section are collapsed instead of rejected.
Proposed follow-up: restore explicit duplicate rejection with regression cases.
Removing the launchers does not change this Node behavior.
