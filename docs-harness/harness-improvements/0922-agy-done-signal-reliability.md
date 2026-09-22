# Harness Improvement Resource

ID: #029_IMPROVE_HARNESS_0922
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Document Herdr `--kind agy` (Antigravity) done-signal unreliability as expected, not exceptional
CREATED: 2026-09-22
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/HERDR-AGENTS.md
- .agents/skills/herdr-coordinate-agents/SKILL.md
- .agents/skills/herdr-coordinate-agents/references/herdr-runtime.md
- .claude/skills/herdr-coordinate-agents/references/herdr-runtime.md
- .agents/skills/herdr-coordinate-agents/references/task-contract.md
- docs-harness/harness-improvements/0922-opencode-go-tight-handoff-wait-timeout.md
- docs/evaluations/pelican-bicycle-antigravity.html

## Objective

Make the Herdr coordination guidance explicit that, for a `--kind agy`
(Antigravity) worker, a coordinator should expect to reobserve
(`agent wait`/`agent read`) and verify via receipt-plus-artifact multiple
times before trusting any single `agent_status: "done"` signal — because this
adapter's own status detection has now been observed to false-positive
repeatedly within one real turn — rather than treating that reobservation
loop as an exceptional fallback the way it is currently documented for
providers in general.

## Purposes

- [x] Prevent a future Bale session (or a different coordinator entirely)
  from trusting the first `agy` "done" signal and accepting an unfinished
  worker's output, by naming the specific, now-observed failure mode instead
  of relying on the generic "reobserve if ambiguous" language to cover it.
- [x] Keep this scoped narrowly to the `agy`/Antigravity provider note; do not
  change the general reobservation rule, the "at most 60 seconds per
  observation" bound, or the reobserve-not-resend rule for other providers.
- [x] Explicitly interlock the new `agy`-specific note with the existing
  general "reobserve on ambiguous state" rule, so a clean-looking `done` from
  `agy` is not mistakenly read as unambiguous (and therefore not read as an
  exemption from verification) by a future session applying the general rule
  literally.
- [ ] Decide whether the same narrow note should also mention the two other
  Antigravity model entries in the catalog that share the `agy` transport
  (only `antigravity-gemini-3.8-flash` at effort `high` was actually
  exercised in this trial) — left open pending a future replay on a
  different Antigravity model/effort, since generalizing beyond the observed
  case is not yet evidenced.

## Current State

Live bounded trial on 2026-09-22 (same session as
`#028_IMPROVE_HARNESS_0922`, after the User manually re-selected the worker
profile in `docs-harness/HERDR-AGENTS.md`: unchecked
`opencode-go-deepseek-v4.1-flash`/`max`, checked
`antigravity-gemini-3.8-flash` with effort `high` and Fast `standard`). Bale
(Claude Sonnet 5, primary session) resolved the exact provider model ID
natively via `agy models` (`gemini-3.8-flash-high`, since the catalog entry
lists two possible IDs and does not map effort labels to IDs), then launched
worker `pelican-agy-01` via
`herdr agent start pelican-agy-01 --kind agy --pane <id> -- --dangerously-skip-permissions --model gemini-3.8-flash-high --effort high`.
Post-launch check confirmed effective state from the native TUI header:
account `lxbach1608@gmail.com` (Google AI Pro), model `Gemini 3.8 Flash
(High)`, cwd `D:\repos\base-harness-repo`.

Bale dispatched the same pelican-bicycle SVG task used in the original
OpenCode Go trial (output redirected to
`docs/evaluations/pelican-bicycle-antigravity.html` to avoid overwriting the
existing accepted file), using the now-current no-`--timeout` guidance from
`#028_IMPROVE_HARNESS_0922`. The result:

- `herdr agent prompt pelican-agy-01 "<prompt>" --wait --until done` returned
  `agent_status: "done"` after only ~11 seconds. Bale did not trust this
  alone; it checked for `receipt.json` and the expected output file (both
  absent) and read a recent terminal snapshot, which showed the worker still
  actively reasoning ("Considering animation options...", reading
  `docs-harness/INDEX.md`) — i.e. genuinely still working, not settled.
- Per `task-contract.md`'s existing "settled state but no matching receipt"
  recovery rule, Bale did not resend the prompt. It reobserved with
  `herdr agent wait pelican-agy-01` (no `--timeout`, per the current
  guidance) and rechecked receipt/artifact/screen each time.
- This same false-"done"-then-still-working pattern repeated **six times**
  across the turn (state_change_seq 239, 245, 251, 259, 261, 263 before a
  seventh wait at 269 finally coincided with real settlement, confirmed by a
  terminal summary block and a present `receipt.json`). One of the
  intermediate observations even returned `agent_status: "idle"` (not
  `"done"`) while the worker was still visibly composing between tool calls,
  showing the false signal is not limited to one specific status value.
- The task ultimately succeeded: `docs/evaluations/pelican-bicycle-antigravity.html`
  (42 KB) was created, containing a recognizable pelican and bicycle, 13x
  `animateTransform` with `repeatCount="indefinite"`, and 13x CSS
  `animation: ... infinite`. Bale independently verified this structurally
  (SVG tag-balance 45/45, no `<script>`, `git status` confirming
  `docs/evaluations/pelican-bicycle.html` was left untouched) and visually
  (two independently captured headless-Edge screenshots at different virtual
  times, showing pedal/leg and wheel-spoke position differences between
  frames). The Bale code-review gate recorded `status: "passed"`, no
  findings.
- The account's own `Session Limit` indicator (shown in the agy TUI status
  bar) was at 99% at launch and 94% by task completion — a separate,
  account-level observation noted for context, not part of this record's
  scope.

This record is therefore a coordination-reliability observation about the
`agy` adapter's status-signal maturity, consistent with the catalog's own
existing caution ("a bounded Antigravity calculator trial has exercised the
local transport, but its provider settings proof is still incomplete") — this
trial adds a specific, reproducible symptom (repeated false "done"/"idle"
signals within a single turn) rather than a generic incompleteness note.

Baseline revision: `2c9c2afc49e979a3e1486ab07392611e5cd01183` on `main`.
Baseline worktree status: `docs-harness/HERDR-AGENTS.md` modified (the
User's own manual checkbox reselection, pre-existing before this record) and
the accepted, untracked `docs/evaluations/pelican-bicycle-antigravity.html`
from this trial.

## Proposed Improvement

In the "Provider adapter matrix" row for `agy` in
`docs-harness/HERDR-AGENTS.md`, and in the relevant launch/observe guidance of
`.agents/skills/herdr-coordinate-agents/references/herdr-runtime.md` (and its
`.claude/` mirror), add a narrow, `agy`-scoped note stating: this adapter's
`agent_status` (`done`/`idle`) has been observed to fire multiple times while
the worker is still actively working within a single turn (2026-09-22 trial:
six false settlements before genuine completion); a coordinator dispatching
an `agy` worker should treat repeated `agent wait` reobservation with
receipt-plus-artifact verification as the **expected** pattern for this kind,
not an exceptional fallback, and must not accept a result on status alone.

This must not change: the general "reobserve on ambiguous state, never
resend" rule for other providers, the "at most 60 seconds per observation"
bound, the reobserve-not-resend recovery rule itself, or the receipt-first
observation principle (which already existed and is what caught every false
signal in this trial — the gap is that its necessity for `agy` specifically
was not called out, not that the rule itself was missing or wrong).

## Scope

May change:

- the `agy` row of the "Provider adapter matrix" and any directly adjacent
  `agy`-specific text in `docs-harness/HERDR-AGENTS.md`;
- `.agents/skills/herdr-coordinate-agents/references/herdr-runtime.md` and its
  `.claude/skills/herdr-coordinate-agents/references/herdr-runtime.md` mirror,
  scoped to the `agy`/Antigravity launch-and-observe guidance;
- this improvement record and its INDEX entry.

Must not change:

- the general reobservation/timeout guidance for other Herdr kinds
  (`codex`, `opencode`, etc.), including the changes just made under
  `#028_IMPROVE_HARNESS_0922`;
- the "at most 60 seconds per observation" bound or the reobserve-not-resend
  recovery rule in `SKILL.md`/`task-contract.md`;
- the Bale code-review gate or the receipt/acceptance contract;
- the default two-live-worker limit or other providers'/models' catalog
  entries;
- any repository validation or dispatch automation.

## Progress

- 2026-09-22: Baseline captured from the live trial described above. This
  record is created before any intervention edit, per the `improve-harness`
  skill's step 1, and kept separate from `#028_IMPROVE_HARNESS_0922` at the
  User's explicit request ("tách riêng nhé" — keep them separate) after Bale
  offered to combine or split the two findings.
- 2026-09-22: User approved applying the change ("có"). Applied the smallest
  `agy`-scoped edit to the `agy` row and a new "`agy` done-signal note" in
  `docs-harness/HERDR-AGENTS.md`'s Provider adapter matrix section, and to
  the `--kind agy` launch guidance in both `herdr-runtime.md` copies.
  `SKILL.md` and `task-contract.md` were left untouched, matching Scope.
- 2026-09-22: Ran a fresh-agent retrieval check (independent
  `general-purpose` subagent, no session memory) against the new wording.
  Result: guidance judged clear and correctly scoped to `agy` only (low risk
  of misapplying to `codex`/`opencode`/`claude`), but it flagged a real gap —
  the general reobservation rule in `SKILL.md` only calls for reobserving on
  a *timeout or ambiguous state*, and a clean-looking `done` from `agy` is
  not literally ambiguous under that wording, so the new `agy` note and the
  general rule were not explicitly interlocked. It also flagged that the
  same incident is now described three times (table cell, `HERDR-AGENTS.md`
  note, `herdr-runtime.md` paragraph) with slightly different phrasing, a
  minor future-drift risk.
- 2026-09-22: Applied a follow-up edit to close the interlock gap: both
  `herdr-runtime.md` copies and the `HERDR-AGENTS.md` note now state that,
  for `agy` specifically, a settled `done`/`idle` signal *counts as
  ambiguous evidence under the general reobservation rule even when it looks
  clean*, until receipt and artifact both confirm it — removing the implicit
  reading that a clean `done` could be treated as an exemption from
  verification. The three-way duplication the subagent flagged was left as
  an accepted minor limitation (see Risks) rather than restructured, since
  each occurrence serves a different reader entry point (provider matrix
  scan, dedicated note, launch-sequence guidance) and consolidating them
  would be a larger, out-of-scope restructuring of the file.
- 2026-09-22: Re-verified mirror parity between the two `herdr-runtime.md`
  copies after the follow-up edit (identical content, confirmed via `diff`
  ignoring line-ending differences).

## Validation

- Native/local proof: inspected the diff of `docs-harness/HERDR-AGENTS.md`
  and both `herdr-runtime.md` copies; confirmed `SKILL.md` and
  `task-contract.md` show no diff (the "at most 60 seconds per observation"
  bound and the reobserve-not-resend rule text are untouched), the two
  `herdr-runtime.md` copies remain byte-identical modulo line endings, and
  the new ID `#029_IMPROVE_HARNESS_0922` is unique and correctly indexed in
  `docs-harness/INDEX.md`.
- Fresh-agent scenario (first pass): an independent subagent read both edited
  spots and reported the guidance clear and correctly `agy`-scoped, and
  surfaced the interlock gap and the three-way duplication described in
  Progress above.
- Applied fix: added the explicit "counts as ambiguous evidence... even when
  it looks clean" interlock sentence to both `herdr-runtime.md` copies and
  the `HERDR-AGENTS.md` note, directly closing the gap the fresh-agent check
  found. No second fresh-agent pass was run after this specific wording
  fix; the remaining validation gap is recorded below.

## Risks

- A single trial (six false signals in one turn) may not be representative;
  the false-done rate could vary by task shape, effort, or Antigravity model.
  Mitigation: phrase the guidance as an observed, dated caution with a
  concrete example count, not a universal quantitative claim, and revisit if
  a future replay contradicts or refines it.
- Narrowly scoping the note to `agy` could under-generalize if other,
  less-proven Herdr kinds (for example a future `claude` or `gemini` adapter)
  exhibit the same class of issue. Mitigation: out of scope for this record;
  a future trial on another kind gets its own evidence-backed record rather
  than an assumed extension of this one.
- Over-documenting reobservation-as-normal for `agy` could make a future Bale
  session slower to trust a genuinely fast, correct `agy` completion.
  Mitigation: the note describes expected behavior (verify before trusting),
  not a mandatory fixed number of extra waits; a worker that settles
  correctly on the first observation is still accepted immediately once
  receipt and artifact both check out.
- **Accepted, minor**: the same incident is now described in three places
  (the `agy` table-cell status note, the dedicated "`agy` done-signal note"
  paragraph, and the `herdr-runtime.md` launch-sequence paragraph) with
  slightly different phrasing each time, flagged by the fresh-agent check as
  a future-drift risk if only one copy is updated later. Mitigation: accepted
  rather than restructured in this pass, since each copy serves a different
  reader entry point; a future edit to any one of the three should grep for
  "2026-09-22" and "six false settlements" across all three (plus the
  `.claude/` mirror) to keep them synchronized.
- The interlock fix (settled `done` "counts as ambiguous evidence... even
  when it looks clean") was not re-verified by a second fresh-agent pass or
  a second live `agy` replay after being applied — see Decision and Result
  for this as an explicit, named limitation rather than an assumed pass.

## Decision and Result

Keep. The User approved the proposal ("có"); the `agy`-scoped wording was
applied to `docs-harness/HERDR-AGENTS.md` (provider matrix row plus a
dedicated note) and both `herdr-runtime.md` copies, without touching
`SKILL.md`, `task-contract.md`, or any other provider's guidance. A
fresh-agent retrieval check found the guidance clear and correctly scoped,
and surfaced one real gap (the new `agy` note was not explicitly interlocked
with the general "reobserve on ambiguous state" rule, so a clean-looking
`done` could be misread as exempt from verification) — Bale closed that gap
with a follow-up edit stating a settled `agy` signal counts as ambiguous
evidence even when it looks clean.

This is proven for one live trial (`pelican-agy-01`,
`antigravity-gemini-3.8-flash` effort `high`) and one fresh-agent reading of
the *first* version of the wording; the interlock fix itself was not
re-verified by a second fresh-agent pass or a second live `agy` replay, which
is an explicit, named limitation rather than an assumed pass. It is also not
yet known whether six false settlements in one turn is typical for `agy` or
specific to this turn's tool-call cadence — a future `agy` replay (same or
different model/effort) would strengthen or revise this note, and should
also spot-check the three near-duplicate incident descriptions for drift
before further editing any one of them.
