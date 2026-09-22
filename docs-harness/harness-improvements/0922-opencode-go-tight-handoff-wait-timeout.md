# Harness Improvement Resource

ID: #028_IMPROVE_HARNESS_0922
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Tune tight-handoff wait/observation timeout guidance for OpenCode Go workers
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
- docs-harness/harness-improvements/0913-opencode-windows-launch-and-lean-herdr.md
- docs/evaluations/pelican-bicycle.html
- docs/evaluations/bouncing-ball.html

## Objective

Make the documented tight-handoff wait guidance in `herdr-runtime.md` (both
the `.agents/` and `.claude/` copies) and the "Latency and token guidance"
section of `docs-harness/HERDR-AGENTS.md` stop forcing Bale to guess a numeric
`--timeout` floor for the initial `agent prompt --wait` call on a
generation-heavy OpenCode Go worker (for example
`opencode-go-deepseek-v4.1-flash` at effort `max`). Final applied approach:
omit `--timeout` entirely on that initial call (Herdr's own wait is then
indefinite until a settled state), relying on the calling coordinator's own
tool-call timeout as the practical safety valve, with an explicit,
verifiable portability caveat for a coordinator runtime whose shell/exec tool
does not share Claude Code's verified non-killing, auto-backgrounding
behavior.

## Purposes

- [x] Reduce redundant bounded-wait round trips for OpenCode Go
  generation-heavy tight handoffs, without weakening the existing "at most 60
  seconds per observation, reobserve rather than resend" safety bound.
- [x] Keep Bale's timeout-recovery behavior (reobserve on timeout, never
  resend) unchanged as the correctness backstop; this is a latency/UX
  tuning proposal, not a correctness fix.
- [x] Avoid a blanket timeout increase that would delay Bale noticing a truly
  stuck or blocked worker for other, lighter-weight tasks or providers.
- [x] Make the reliance on the coordinator's own tool-call timeout behavior
  (auto-background vs. hard-kill on expiry) explicit and independently
  verifiable in the guidance text itself, rather than an unstated assumption,
  since the same skill files are shared with coordinator runtimes other than
  Claude Code.

## Current State

Live bounded trial on 2026-09-22: Bale (Claude Sonnet 5, primary session)
delegated a one-shot `tight` handoff to worker `pelican-svg-01`
(`opencode-go-deepseek-v4.1-flash`, effort `max`, launched via Herdr
`--kind opencode --auto -m opencode-go/deepseek-v4.1-flash`) to create a
single self-contained HTML file with an inline-SVG 2D animation of a pelican
riding a bicycle at `docs/evaluations/pelican-bicycle.html`. Post-launch
check confirmed effective configuration (`Build auto · DeepSeek V4.1 Flash
OpenCode Go · max`, cwd `D:\repos\base-harness-repo`).

Following the tight-handoff default, Bale ran
`herdr agent prompt pelican-svg-01 "<prompt>" --wait --until done --timeout 60000`,
which returned `{"error":{"code":"timeout","message":"timed out waiting for
agent status"}}`. `herdr agent get pelican-svg-01` immediately after showed
`agent_status":"working"` with the terminal title already updated to reflect
the task ("OC | Pelican bicycle SVG animation HTML"), confirming the prompt
was delivered and work was progressing, not stalled. Per the Recovery
decisions table in `task-contract.md`, Bale did not resend; it reconciled via
`agent get`, then issued one further bounded
`herdr agent wait pelican-svg-01 --timeout 120000`, which returned
`agent_status":"done"`. Total elapsed wall-clock from prompt submission to a
settled `done` state was roughly 2-3 minutes for one moderately complex
generation task (a ~14.5 KB HTML/SVG file with multiple animated groups).

The task itself succeeded: the worker's receipt reported `status:
"completed"` with structural self-checks, and Bale independently verified the
output (SVG tag-balance check, `animateTransform`/`repeatCount="indefinite"`/
`@keyframes` presence, `git status` confirming no other file was touched, and
two independent headless-Edge screenshots at different virtual times showing
the rig visibly translated and the wheels rotated). The Bale code-review gate
recorded `status: "passed"` with no findings. This record is therefore a
coordination-latency observation, not a report of a defect in the delivered
artifact.

Baseline revision: `a76c9646176223cdf45024e3168622eb85094b94` on `main`.
Baseline worktree status: clean except the accepted, unrelated untracked
`docs/evaluations/` output from the same session.

## Proposed Improvement

Superseded within the same day by direct User-directed experimentation (see
Progress). The final applied change: in
`.agents/skills/herdr-coordinate-agents/references/herdr-runtime.md` (and its
`.claude/` mirror) and the "Latency and token guidance" section of
`docs-harness/HERDR-AGENTS.md`, the tight-handoff initial wait is now
documented as `agent prompt ... --wait --until done` with **no** `--timeout`
value, instead of a numeric floor. Herdr's own wait is then indefinite until a
settled state. This relies on the calling coordinator's own tool-call timeout
as the practical safety valve rather than a Herdr-side guess, and the text
says so explicitly:

1. it names the exact verified property (Claude Code's Bash tool
   auto-backgrounds a command that exceeds its own timeout instead of
   killing it, so the coordinator regains control and is notified on
   completion rather than blocking forever), and
2. it instructs the reader to verify the same non-killing behavior before
   relying on an unbounded `agent prompt --wait` on a different coordinator
   runtime, and to pass an explicit `--timeout` (for example `120000`)
   instead if that runtime hard-kills on expiry.

An earlier, narrower version of this change (documented 2026-09-22 before the
User's follow-up questions) raised the initial bound to `120000` instead of
removing it; that intermediate wording was replaced by the no-timeout
approach in the same session and is retained only in Progress for history.

This must not change the "at most 60 seconds per observation" bound that
governs any individual `agent wait` reobservation call, and must not remove
or weaken the reobserve-not-resend recovery rule; both are confirmed
unchanged in the current diff.

## Scope

May change:

- `.agents/skills/herdr-coordinate-agents/references/herdr-runtime.md` and its
  `.claude/skills/herdr-coordinate-agents/references/herdr-runtime.md` mirror;
- the "Latency and token guidance" section of `docs-harness/HERDR-AGENTS.md`;
- this improvement record and its INDEX entry.

Must not change:

- the Bale code-review gate or the receipt/acceptance contract in
  `task-contract.md`;
- the "at most 60 seconds per observation" bound on any single reobservation
  call, or the reobserve-not-resend recovery rule;
- the default two-live-worker limit or other providers'/models' documented
  timeout expectations;
- any repository validation or dispatch automation.

## Progress

- 2026-09-22: Baseline captured from the live trial described above. This
  record is created before any intervention edit, per the `improve-harness`
  skill's step 1. The User accepted recording this proposal as a pending
  harness-improvement in the current conversation ("ghi nhận điều này thành
  một harness-improvement record ... để chờ xét duyệt" -> User replied "có")
  but had not yet authorized applying the proposed wording change itself.
- 2026-09-22: User explicitly approved the proposal ("duyệt"). Applied the
  smallest coherent edit described in "Proposed Improvement" to
  `.agents/skills/herdr-coordinate-agents/references/herdr-runtime.md`, its
  `.claude/` mirror, and the "Latency and token guidance" section of
  `docs-harness/HERDR-AGENTS.md`. The "at most 60 seconds per observation"
  bound in `SKILL.md` and the reobserve-not-resend recovery rule were left
  unchanged, matching the approved Scope.
- 2026-09-22: Ran a fresh-agent retrieval check (a context-free
  `general-purpose` subagent, no memory of this session) that read both
  edited sections independently and confirmed the new guidance is clear on
  first read, consistent with the surrounding "at most 60 seconds per
  observation" and reobserve-not-resend text, with only a minor near-verbatim
  duplication noted between the two mirrored files (expected, since they are
  intentionally kept in sync) and a mild note that choosing "raise timeout"
  vs. "plan a reobservation" is left to coordinator judgment (intended, not a
  defect).
- 2026-09-22: Ran a second live bounded Herdr replay (`bouncingball-01`,
  same catalog profile `opencode-go-deepseek-v4.1-flash` effort `max`,
  fresh workspace `w23`) applying the revised guidance's option 1: the
  initial `agent prompt ... --wait --until done --timeout 120000` call was
  used directly instead of the old `60000` floor. The task ("create a
  self-contained inline-SVG bouncing-ball animation at
  `docs/evaluations/bouncing-ball.html`") completed and returned
  `agent_status: "done"` within a single bounded call (~49s wall clock,
  under the raised bound, no second `agent wait` needed), with a matching
  `completed` receipt. This is a lighter task than the original pelican
  trial, so it does not by itself prove the raised bound is *necessary* for
  every generation task, but it proves the guidance is retrievable, directly
  actionable, and does not break normal single-call completion.
- 2026-09-22 (continued, same day): The User questioned the 120000ms
  approach directly ("nếu nhận được tín hiệu khi nào agent được điều phối
  hoàn thành thì Orchestrator nhận được tín hiệu ... thì có tăng timeout lên
  gấp nhiều lần mà?" — since `--wait` is event-driven and returns as soon as
  the state settles, why not raise the bound much further?). Bale agreed the
  success case is free either way, but flagged a real cost in the failure
  case: while `agent prompt --wait` blocks, Bale cannot do anything else, so
  a larger bound delays Bale noticing and reconciling a truly stuck worker.
  The User then asked to remove the timeout entirely ("tôi muốn bỏ luôn
  timeout nhé"), and Bale raised that Herdr's own `--timeout` can be omitted
  for an indefinite wait, but that the Bash tool wrapping the call has its
  own documented ceiling (up to 600000ms) — so a true "no timeout" was not
  achievable from Bale's side regardless of the Herdr flag. The User asked
  why that Bash-tool ceiling exists and asked Bale to try omitting
  `--timeout` anyway ("cứ thử bỏ --timeout nhé").
- 2026-09-22: Ran a controlled Bash-tool timeout probe (`sleep 8` under a 3s
  Bash timeout) to observe the actual behavior at that boundary. Result: the
  command was **not killed**; it was moved to a background job and Bale was
  notified on its normal completion (exit code 0) a few seconds later. This
  is a Claude Code Bash-tool-specific behavior (auto-background instead of
  hard-kill on expiry), distinct from what the tool's own docs implied and
  materially different from a hard timeout failure.
- 2026-09-22: Ran a third live bounded Herdr replay (`notimeout-01`, same
  catalog profile `opencode-go-deepseek-v4.1-flash` effort `max`, fresh
  workspace `w24`), dispatching
  `herdr agent prompt notimeout-01 "<prompt>" --wait --until done` with
  **no `--timeout`** flag at all, for the task "create a self-contained
  inline-SVG rocket-launch-loop animation at
  `docs/evaluations/rocket-launch.html`". Completed and returned
  `agent_status: "done"` in ~73 seconds with a matching `completed` receipt;
  Bale independently verified the output (SVG tag-balance, `@keyframes`
  presence, no `<script>`/external resources, `git status` confirming no
  other file touched) and closed workspace `w24` after acceptance.
- 2026-09-22: Bale reported both results and an explicit caveat to the User:
  the demonstrated safety (no indefinite block) is a property of Claude
  Code's Bash tool specifically, not of Herdr or the shared skill in
  general; the same `herdr-runtime.md` file is mirrored to `.agents/` (usable
  by other coordinator runtimes, for example Codex) whose shell/exec tool
  might hard-kill on its own timeout instead of backgrounding, which would be
  worse than a documented Herdr-side `--timeout` because Herdr would not get
  a clean signal to reconcile against. Bale asked the User to choose between
  applying the no-timeout change only to the verified `.claude/` copy, or to
  both copies with the portability risk accepted. The User chose "option 2"
  (apply to both copies).
- 2026-09-22: Applied the no-timeout wording (superseding the earlier
  120000ms version) to both `herdr-runtime.md` copies and the
  `HERDR-AGENTS.md` latency section, including the explicit verified-property
  statement and the portability caveat instructing a reader to check the same
  non-killing behavior before relying on this on another coordinator runtime.
- 2026-09-22: Ran a second fresh-agent retrieval check (independent
  `general-purpose` subagent, no session memory) against the no-timeout
  wording in both files. Result: guidance judged clear on first read, no
  contradiction with the still-bounded `agent wait --timeout 30000`
  reobservation text, and the portability caveat judged "actionable but not
  self-executing" (it names the property to check and the fallback action,
  but does not prescribe the exact verification steps) — accepted as a minor,
  non-blocking gap rather than a defect requiring another revision.

## Validation

- Native/local proof: inspected the diff of all three edited files plus
  `docs-harness/INDEX.md` and `.gitignore`; confirmed only the scoped files
  changed, the "at most 60 seconds per observation" bound and
  reobserve-not-resend rule text in `SKILL.md`/`task-contract.md` were left
  untouched, and the new ID `#028_IMPROVE_HARNESS_0922` is unique and
  correctly indexed.
- Fresh-agent scenario: an independent `general-purpose` subagent retrieved
  and read the edited guidance and reported it clear, actionable and
  non-contradictory (see Progress above).
- Live bounded Herdr replay: `bouncingball-01` on worker profile
  `opencode-go-deepseek-v4.1-flash` (effort `max`, `Build auto`), one
  `agent prompt --wait --until done --timeout 120000` call, settled `done`
  with a `completed` receipt; Bale independently verified the output
  structurally (SVG tag-balance, `<animate>`/`repeatCount="indefinite"`
  counts, no `<script>`/external resources, `git status` confirming no other
  file touched) and visually (two independent headless-Edge screenshots at
  different virtual times showing the ball's vertical position and
  squash/stretch change between frames). Bale code review recorded `status:
  "passed"`, no findings, for both `docs/evaluations/pelican-bicycle.html`
  (original trial) and `docs/evaluations/bouncing-ball.html` (replay).
  Task-owned workspaces `w21` and `w23` were closed after their respective
  acceptances.
- Bash-tool boundary probe: `sleep 8` under a 3s Bash `timeout` was moved to
  background rather than killed, and completed normally (exit code 0),
  confirming Claude Code's Bash tool does not hard-kill on expiry.
- Third live bounded Herdr replay: `notimeout-01` on the same worker profile,
  `agent prompt ... --wait --until done` with no `--timeout`, settled `done`
  in ~73s with a `completed` receipt; Bale independently verified
  `docs/evaluations/rocket-launch.html` structurally (SVG tag-balance,
  `@keyframes` presence, no `<script>`/external resources) and confirmed via
  `git status` that no other file was touched. Workspace `w24` was closed
  after acceptance.
- Second fresh-agent retrieval check: an independent subagent confirmed the
  final no-timeout wording is clear, non-contradictory with the still-bounded
  reobservation text, and that the portability caveat is actionable (though
  it does not prescribe exact verification steps — accepted as a minor gap).
- Diff re-inspection after the second edit round: confirmed only
  `herdr-runtime.md` (both copies) and the `HERDR-AGENTS.md` latency section
  changed again; `SKILL.md`'s "at most 60 seconds per observation" text and
  `task-contract.md`'s reobserve-not-resend rule remain untouched; `git
  status` shows no unrelated file modified.

## Risks

- **Accepted, User-directed**: on a coordinator runtime other than Claude
  Code, the shell/exec tool wrapping `herdr agent prompt --wait` may hard-kill
  the process on its own timeout instead of backgrounding it, which is worse
  than a documented Herdr-side `--timeout` because Herdr never gets a clean
  signal to reconcile against and delivery becomes ambiguous. Mitigation: the
  applied wording explicitly names the verified property (Claude Code's
  Bash tool auto-backgrounds, verified 2026-09-22) and instructs the reader
  to verify the same behavior before relying on an unbounded wait elsewhere,
  falling back to an explicit `--timeout` (for example `120000`) otherwise.
  This risk was explained to the User before the change (see Progress); the
  User chose to accept it and apply the change to both `herdr-runtime.md`
  copies ("option 2") rather than scope it to the verified `.claude/` copy
  only.
- If a genuinely stuck OpenCode Go worker occurs even under Claude Code, the
  initial `agent prompt --wait` call itself blocks Bale until the Bash tool's
  own timeout is reached (default 120000ms, up to 600000ms if explicitly
  raised), after which the underlying command is backgrounded rather than
  lost — Bale regains control and gets a later completion notification, but
  during that window Bale cannot inspect, reconcile, or respond to the User.
  Mitigation: this is a Claude-Code-tool-level backstop already in place
  regardless of Herdr's own `--timeout` value; the reobserve-not-resend rule
  and the "at most 60 seconds per observation" bound on `agent wait` remain
  unchanged for the subsequent reconciliation step once control returns.
- Guidance drawn from three trials (one original + two replays) may not
  generalize across task sizes, efforts, other OpenCode Go models, or a
  worker that is genuinely stuck (none of the three trials exercised a real
  stuck-worker case). Mitigation: the portability caveat and the explicit
  verified-property statement are written into the guidance text itself so a
  future session can re-evaluate rather than inherit an unstated assumption;
  revisit if a future replay or a real stuck-worker incident contradicts it.

## Decision and Result

Keep, in its final (no-timeout) form. The intervention went through two
applied revisions in the same session, both User-directed: first a bounded
`120000` initial-wait floor (approved via "duyệt"), then — after the User's
own follow-up questions about event-driven waits and Bash-tool timeout
semantics — a full removal of `--timeout` on the initial `agent prompt --wait`
call (approved via "option 2" after Bale disclosed the portability risk for
non-Claude-Code coordinators). The final wording in both `herdr-runtime.md`
copies and `HERDR-AGENTS.md` leaves the "at most 60 seconds per observation"
bound and the reobserve-not-resend rule unchanged, and explicitly documents
both the verified safety property (Claude Code's Bash tool backgrounds rather
than kills on its own timeout) and the portability caveat for other
coordinator runtimes.

Two independent fresh-agent retrieval checks and three live bounded Herdr
replays (`pelican-svg-01`, `bouncingball-01`, `notimeout-01`) all completed
successfully with independently verified, accepted artifacts; a controlled
Bash-tool boundary probe (`sleep` past a short timeout) confirmed the
auto-backgrounding property the final wording relies on. The result is proven
for the captured Herdr `0.7.5-preview.2026-07-29-44b3adb12552` / OpenCode
`1.18.32`+ / `opencode-go-deepseek-v4.1-flash` (effort `max`) environment
running under Claude Code specifically. It is explicitly **not** proven for
any other coordinator runtime (for example Codex, reachable through the same
`.agents/` mirror) or for a genuinely stuck worker — both are named as open
limitations in the guidance text and in Risks above, by the User's own
informed choice rather than by omission.
