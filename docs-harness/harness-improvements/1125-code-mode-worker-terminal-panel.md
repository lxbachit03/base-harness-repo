# Harness Improvement Resource

ID: #106_IMPROVE_HARNESS_1125
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Run the Code Mode search worker in the Claude Desktop Terminal panel, as a User option
CREATED: 2026-11-25
STATUS: active
REFERENCES:
- docs-harness/claude-instructions/research-subagents.md
- docs-harness/claude-instructions/code-search-worker.ps1
- docs-harness/claude-instructions/README.md
- docs-harness/harness-improvements/1124-code-mode-search-worker.md

## Objective

`research-subagents.md` offers three worker hosts: Terminal panel TUI + `--resume`
(marked by default), Terminal panel `-p` + progress lines, and a Herdr app space. The
Terminal panel hosts run a repository script that starts the Code Mode worker in a tab
the User opens by a link, and resume the same worker for a follow-up question.

## Purposes

- [x] Let the User watch the worker live: one link in the chat opens its terminal tab
  (User request, 2026-11-25).
- [x] Keep the Herdr host available as an option, not replace it (User: "Không chuyển
  sang, nhưng mà hãy thêm một option ... tick mặc định").
- [x] Let the User see the real Claude Code TUI, or choose the `-p` log view (User:
  "mặc định là TUI + --resume").
- [x] Run the worker without the Herdr app, with exact token figures per search.

## Current State

Baseline: `main` at `047b67a`, clean. #105 routes every search to a Haiku 5.5 Code
Mode worker in a Herdr space driven by `hc send` / `hc wait` / `hc read`. Evidence from
2026-11-25 trials in this session (tab `c3`, scratch script, Haiku 5.5, effort xhigh):

- Run 1 (new worker, `json` output): 2 turns, 10.5 s, cache write 28.4K, cache read
  23.6K, output 1.8K, $0.0068; correct 7-file answer.
- Run 2 (`--resume` of run 1): 5 turns, 14.4 s, cache write 3.7K, read 88.7K, output
  2.1K, $0.0095; it filtered its own earlier list, so the session was resumed.
- Code Mode ran: transcript holds `REPL` calls and inner `toolu_cc_` Read/Bash calls.
- Run 3 (`stream-json`, live progress lines): 2 turns, 18 s, write 20.5K, read 36.7K,
  output 3.6K, $0.0063; the tab showed each inner Bash call with a timestamp.
- `git status --short` clean after each run. `read_terminal` returns on the first new
  output, so waiting on the screen took an extra call; the log's `result` line is a
  more reliable end signal.
- The Terminal panel tool cannot type into a running interactive `claude`, and refuses
  pipes and variable reads, so the environment clearing lives in a script.

## Proposed Improvement

Add `claude-instructions/code-search-worker.ps1`; in `research-subagents.md` add
a "Worker host" checklist and Terminal panel steps, keeping the Herdr steps; update
the README line.

## Scope

Changes: the rule, the new script, the README line, this record, the improvements
README. Not changed: the Herdr steps' content, `HERDR-APP.md`, #105, User settings.

## Progress

2026-11-25: record created; script added beside the rule (a `scripts/` folder would
need its own README and an INDEX tree entry); rule and README updated;
`harness_check.py` clean (106 IDs). Step 2 reworded after a dry check: a new tab's id is
known only after `run_in_terminal`, so the link follows the run.

## Validation

Native: `harness_check.py` and a diff review. Behavior: one live search through the
repository script following the new steps.

## Risks

- The worker can still write through Bash; only `Edit`, `Write`, `NotebookEdit` and
  `Agent` are denied. Proposal: `git status --short` after each search, as in #105.
- `--resume` makes each follow-up reread the worker's growing context (88.7K cache read
  on run 2). Proposal: start a new worker for an unrelated question.

Same day, User question "Tôi tưởng là TUI chứ?": the Terminal panel tool refused to
type into tab `c5` while a TUI ran ("Tab "c5" is still running a command"), so a TUI
cannot be kept open and fed questions there; each question starts a new interactive
`claude` with the prompt as its argument, and `--resume` carries the memory. Ctrl-C
(sent twice) did not end the TUI; closing the tab did. Without a permission flag the
TUI ran in the User's auto mode, so the script now passes `--permission-mode default`.
User request: three host options, TUI + `--resume` marked. Script gained `-Tui`.

## Decision and Result

Keep. Live run by the main session following the new steps (tab `c4` titled
`code-search`, link sent after the start, effort xhigh): 3 turns, 15.8 s, cache write
13.7K, read 62.0K, output 2.4K, $0.0046; three inner `Grep` calls with `toolu_cc_` ids;
five files cited, all matching a direct `grep`; the log's `result` line ended the wait
in one shell call; `git status --short` showed only this change's files.

TUI trials (scratch script, effort xhigh): new worker 32.2K cache write, 56.0K read,
3.8K output, six citations correct; `--resume` 9.0K write, 66.8K read, 1.9K output,
correctly filtered its own earlier list. Repository script, after the change: TUI new
worker in tab `c6` (`default` permission mode, REPL with an inner Bash `rg`, no prompt
shown): 26.9K write, 25.4K read, 1.4K output, two citations matching `grep`; `-p`
regression in tab `c3`: 3 turns, $0.0053, correct `path:line`. `git status` showed only
this change's files each time.

Decision: pending fresh rerun. Not yet run: a fresh-agent replay that reads only the
rule, a `-Resume` follow-up through the repository script (tried only with the scratch
script), a permission prompt in the TUI, and the fallback question.
Owner: the next session that runs a search with the Terminal panel host.
