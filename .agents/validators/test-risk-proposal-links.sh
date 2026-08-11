#!/usr/bin/env bash
set -u
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATOR="$SCRIPT_DIR/validate-risk-proposal-links.sh"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/risk-proposal-validator.XXXXXX")"
trap 'rm -rf "$TMP_ROOT"' EXIT

failures=0

make_fixture() {
  python3 - "$1" <<'PY'
import sys
from pathlib import Path

root = Path(sys.argv[1])
risks = root / "docs-harness" / "risks"
proposals = root / "docs-harness" / "proposals"
risks.mkdir(parents=True)
proposals.mkdir(parents=True)
(risks / "README.md").write_text("", encoding="utf-8")
(proposals / "README.md").write_text("", encoding="utf-8")
(root / "docs-harness" / "INDEX.md").write_text(
    """# Harness Index

## TAG: [RISK]

Folder: [risks/](risks/risks/)

Purpose: canonical risk routing.

Read when: validating risk findings.

Skip when: no risk context is relevant.

Resources:

- [#001_RISK_0810 Risk sample](risks/0810-risk-sample.md) — PRIORITY: [CRITIAL]
  - Proposal: [#002_RISK_0810 Proposal sample](proposals/0810-proposal-sample.md)

## Supporting Folders

### proposals/

Folder: [proposals/](proposals/)

Purpose: proposals are reached through nested risk links.

Read when: following a related risk.

Skip when: no risk relationship is relevant.

Resources:

Proposals are reached through nested links under TAG: [RISK].
""",
    encoding="utf-8",
)
(risks / "0810-risk-sample.md").write_text(
    """ID: #001_RISK_0810
TAG: [RISK]
PRIORITY: [CRITIAL]
TITLE: Risk sample
CREATED: 2026-08-10
STATUS: OPEN
REFERENCES:
- [#002_RISK_0810 Proposal sample](../proposals/0810-proposal-sample.md)

## Risk

Sample risk.

## Evidence

src/sample.cs:10, SampleSymbol, first-party execution path.

## Impact

Sample impact.

## Indicators

Sample indicator.

## Mitigation

No safe mitigation identified.

## Verification

Investigation required.

## Related Proposals

- [#002_RISK_0810 Proposal sample](../proposals/0810-proposal-sample.md)
""",
    encoding="utf-8",
)
(proposals / "0810-proposal-sample.md").write_text(
    """ID: #002_RISK_0810
TAG: [RISK]
PRIORITY: [CRITIAL]
TITLE: Proposal sample
CREATED: 2026-08-10
STATUS: PROPOSED
REFERENCES:
- [#001_RISK_0810 Risk sample](../risks/0810-risk-sample.md)

## Problem

Sample problem.

## Context

Sample context.

## Related Risks

- [#001_RISK_0810 Risk sample](../risks/0810-risk-sample.md)

## Options

No safe mitigation identified; investigate first.

## Recommendation

Investigate before selecting mitigation.

## Decision

User decision required.

## Consequences

Residual exposure remains.

## Residual Risk

Sample residual risk.

## Rollback

No mitigation deployed; rollback not applicable.
""",
    encoding="utf-8",
)
PY
}

clone_valid() {
  cp -R "$VALID_FIXTURE/." "$1/"
}

mutate_file() {
  python3 - "$1" "$2" "$3" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
old = sys.argv[2].replace("\\n", "\n")
new = sys.argv[3].replace("\\n", "\n")
text = path.read_text(encoding="utf-8")
if old not in text:
    raise SystemExit(f"mutation anchor not found: {old}")
path.write_text(text.replace(old, new, 1), encoding="utf-8")
PY
}

run_case() {
  name="$1"
  expected="$2"
  root="$3"
  pattern="${4:-}"
  set +e
  output="$($VALIDATOR --root "$root" 2>&1)"
  actual=$?
  set -e
  if [ "$actual" -ne "$expected" ]; then
    printf 'FAIL|%s|expected=%s|actual=%s\n%s\n' "$name" "$expected" "$actual" "$output"
    failures=$((failures + 1))
    return
  fi
  if [ -n "$pattern" ] && ! printf '%s\n' "$output" | grep -q "$pattern"; then
    printf 'FAIL|%s|missing-diagnostic=%s\n%s\n' "$name" "$pattern" "$output"
    failures=$((failures + 1))
    return
  fi
  printf 'PASS|%s|exit=%s\n' "$name" "$actual"
}

set -e
EMPTY_FIXTURE="$TMP_ROOT/empty"
mkdir -p "$EMPTY_FIXTURE/docs-harness/risks" "$EMPTY_FIXTURE/docs-harness/proposals"
touch "$EMPTY_FIXTURE/docs-harness/risks/README.md" "$EMPTY_FIXTURE/docs-harness/proposals/README.md"
printf '%s\n' '# Harness Index' '## TAG: [RISK]' 'Resources:' 'No risk resources are indexed yet.' '## Supporting Folders' '### proposals/' 'Resources:' 'Proposals are reached through nested links under TAG: [RISK].' > "$EMPTY_FIXTURE/docs-harness/INDEX.md"
run_case "empty-state" 0 "$EMPTY_FIXTURE" 'PASS|SUMMARY|risks=0|proposals=0'

VALID_FIXTURE="$TMP_ROOT/valid"
mkdir -p "$VALID_FIXTURE"
make_fixture "$VALID_FIXTURE"
run_case "valid-pair" 0 "$VALID_FIXTURE" 'PASS|SUMMARY|risks=1|proposals=1'

CASE="$TMP_ROOT/metadata"
mkdir -p "$CASE"
clone_valid "$CASE"
mutate_file "$CASE/docs-harness/risks/0810-risk-sample.md" 'PRIORITY: [CRITIAL]' 'PRIORITY: [URGENT]'
run_case "invalid-metadata" 1 "$CASE" 'ERROR|META|'

CASE="$TMP_ROOT/id"
mkdir -p "$CASE"
clone_valid "$CASE"
mutate_file "$CASE/docs-harness/proposals/0810-proposal-sample.md" 'ID: #002_RISK_0810' 'ID: #001_RISK_0810'
run_case "duplicate-id" 1 "$CASE" 'ERROR|ID|'

CASE="$TMP_ROOT/path"
mkdir -p "$CASE"
clone_valid "$CASE"
mutate_file "$CASE/docs-harness/risks/0810-risk-sample.md" 'proposals/0810-proposal-sample.md' 'proposals/0810-missing.md'
run_case "invalid-path" 1 "$CASE" 'ERROR|PATH|'

CASE="$TMP_ROOT/reciprocal"
mkdir -p "$CASE"
clone_valid "$CASE"
mutate_file "$CASE/docs-harness/proposals/0810-proposal-sample.md" '## Related Risks\n\n- [#001_RISK_0810 Risk sample](../risks/0810-risk-sample.md)' '## Related Risks\n\nNo reciprocal link.'
run_case "one-way-link" 1 "$CASE" 'ERROR|FORMAT|'

CASE="$TMP_ROOT/orphan"
mkdir -p "$CASE"
clone_valid "$CASE"
cp "$CASE/docs-harness/proposals/0810-proposal-sample.md" "$CASE/docs-harness/proposals/0810-orphan.md"
mutate_file "$CASE/docs-harness/proposals/0810-orphan.md" '#002_RISK_0810' '#003_RISK_0810'
mutate_file "$CASE/docs-harness/proposals/0810-orphan.md" 'Proposal sample' 'Orphan proposal'
run_case "orphan-proposal" 1 "$CASE" 'ERROR|RECIPROCAL|'

CASE="$TMP_ROOT/index"
mkdir -p "$CASE"
clone_valid "$CASE"
mutate_file "$CASE/docs-harness/INDEX.md" '  - Proposal: [#002_RISK_0810 Proposal sample](proposals/0810-proposal-sample.md)\n' ''
run_case "index-missing-nested-proposal" 1 "$CASE" 'ERROR|INDEX|'

CASE="$TMP_ROOT/snapshot"
mkdir -p "$CASE"
clone_valid "$CASE"
(
  sleep 0.1
  printf '\n' >> "$CASE/docs-harness/INDEX.md"
) &
writer_pid=$!
set +e
output="$(HARNESS_VALIDATOR_TEST_DELAY_MS=300 "$VALIDATOR" --root "$CASE" 2>&1)"
actual=$?
set -e
wait "$writer_pid"
if [ "$actual" -eq 2 ] && printf '%s\n' "$output" | grep -q 'FATAL|SNAPSHOT|'; then
  printf 'PASS|snapshot-drift|exit=%s\n' "$actual"
else
  printf 'FAIL|snapshot-drift|expected=2\n%s\n' "$output"
  failures=$((failures + 1))
fi

if [ "$failures" -ne 0 ]; then
  printf 'SUMMARY|status=FAIL|cases_failed=%s\n' "$failures"
  exit 1
fi
printf '%s\n' 'SUMMARY|status=PASS|all validator cases passed'
