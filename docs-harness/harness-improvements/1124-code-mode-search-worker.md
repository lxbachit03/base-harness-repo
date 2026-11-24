# Harness Improvement Resource

ID: #105_IMPROVE_HARNESS_1124
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Route Claude Desktop searches through a persistent Code Mode worker in Herdr
CREATED: 2026-11-24
STATUS: completed
REFERENCES:
- docs-harness/claude-instructions/research-subagents.md
- docs-harness/claude-instructions/README.md
- docs-harness/HERDR-APP.md
- docs-harness/harness-improvements/1124-code-mode-claude-p-worker.md
- docs-harness/harness-constraints/1120-session-role-and-judgment.md

## Objective

A Claude session sends every search of code or file content to one `claude` Code Mode
worker on Haiku 5.5 that runs in a Herdr app space for the whole session, and asks the
User what to do when that worker cannot run.

## Purposes

- [x] Keep the coordinator's context small: search output stays in the worker and only
  the answer returns (User request, 2026-11-24; large-task test in #103: +4K kept by a
  relay against +30K done directly).
- [x] Pay the worker's start-up once per session instead of once per search, as each
  Explore subagent did (~40–46K per spawn in today's replays).
- [x] Let the User choose the fallback when Herdr or the worker fails.

## Current State

Baseline: `main` at `07f3846`, clean. `claude-instructions/research-subagents.md` sends
code research to Haiku Explore subagents after asking the User, and keeps direct reads
of one or two files in the session. User decisions on 2026-11-24 (one question round):
worker in Herdr, running for the session; Haiku 5.5; every search goes to the worker,
small ones included; when Herdr or the worker fails, ask the User. Evidence: #103 (Code
Mode in Herdr works after clearing `CLAUDE*`; two-turn and 13-file relays correct).

## Proposed Improvement

Rewrite `research-subagents.md` in place (the filename stays, so the links in #074 and
the README keep resolving) and update its README line.

## Scope

Changes: that file, its README line, this record, the improvements README. Not changed:
`agy-instructions/`, `HERDR-APP.md`, #074 (its link still names the file that says
which research helpers are allowed), User settings.

## Progress

2026-11-24: record created; instruction rewritten; README line updated;
`harness_check.py` clean (105 IDs). Replay 1 exposed gaps; step 1 and 2 revised; replay
2 passed; a Git Bash `$` escaping clause added after it (see Decision and Result).
Same day, User request: a "Code Mode worker on" checkbox (marked by default); unmarked
returns to Haiku Explore subagents with the previous ask-first rule and the one-or-two
file exemption. Replay 3 on the unmarked branch passed (see Decision and Result).

## Validation

Native: `harness_check.py` and a diff review. Behavior: a fresh planning replay of the
rewritten file; a live run of the per-search cost is not yet measured.

## Risks

- Per-search cost of a persistent worker is unmeasured; a one-file lookup now costs at
  least two coordinator calls. Proposal: measure a small and a large search live.
- The worker brief overrides the INDEX-first rule for a read-only search. Proposal:
  keep it, as the User chose the cheap worker; it is named in the brief.
- Code Mode JavaScript runs outside the sandbox; the worker is started without Edit,
  Write, NotebookEdit and Agent. Proposal: review `git status` after each search.

## Decision and Result

Keep the instruction. Replays (User go-ahead, fresh Haiku 5.5 Explore subagents, effort
high, read the rule and HERDR-APP.md only, no commands), main Claude Desktop session
with Git Bash:

- Replay 1 (57.3K subagent tokens). Case 1, no `code-search` space, question on
  `HARNESS_ROLE`: created the space unfocused, cleared `CLAUDE*`, started the Haiku
  worker with the deny list, one-line brief with the INDEX override and an unjoined
  DONE marker, small read window with `git status` in the same call, no search of its
  own. Case 2, no Herdr core: asked the User once with the three choices and waited.
  Gaps it named: the terminal's shell, the Code Mode variable after clearing, how to
  wait for the banner, the permission flag, and whether to ask before creating the
  space. Step 1 and 2 revised for all five.
- Replay 2 (55.5K subagent tokens; case 1, revised text): all checks passed, with one `hc send` that clears
  `CLAUDE*`, sets the Code Mode variable and starts `claude --model haiku ...` with no
  permission flag, a banner wait, and no `/clear` on a new worker. It named Git Bash
  `$` quoting as unclear (seen live on 2026-11-24, where `\$_` was needed); a clause
  was added without a further replay.

- Replay 3 (46.9K subagent tokens; User go-ahead; switch treated as `[ ]`): Case A, find every caller of
  `harness_check.py`: asked the User once naming Haiku and one subagent, then planned an
  Explore spawn (`haiku`, `high`, one self-contained question), no Herdr or `hc`, and
  checked cited lines before answering. Case B, read line 17 of a named file: read it
  directly with no ask and no spawn. Gaps it named come from the earlier Explore rule
  (what ends a "task"; no retry rule of its own) and were left as they were.

Limits: planning replays only. Not yet run live: the rule end to end, the per-search
cost of the persistent worker against an Explore spawn, and whether
`--disallowedTools` blocks writes made from Code Mode JavaScript.
