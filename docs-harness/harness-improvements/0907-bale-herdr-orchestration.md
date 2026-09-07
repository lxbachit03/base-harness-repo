# Harness Improvement Resource

ID: #016_IMPROVE_HARNESS_0907
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Bale orchestration through independent Herdr agents
CREATED: 2026-09-07
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- .agents/skills/herdr-coordinate-agents/SKILL.md
- .agents/skills/herdr-coordinate-agents/validation/0907-evidence.json
- .agents/skills/prompt-leverage/SKILL.md

## Objective

Make the primary session Bale by default, retaining its model and handling small
work directly. Delegate useful bounded work through Herdr to independent Codex
sessions using GPT-5.6 Luna, Max effort and Fast mode. Bale verifies and integrates
results. Workers have explicit roles and do not recursively delegate.

## Current State

Local baseline: D:/repos/base-harness-repo, main,
fd8c1349044dc0731425fde404132acc640fc2a9, clean worktree. The accepted research
found no Herdr coordination contract in this repo. Herdr is installed and running:
0.7.5-preview.2026-07-21-0f10e1453a7f, protocol 17; Codex CLI is 0.153.4.
The current session runs inside Herdr. Existing proof covers Harness structure,
not cross-session task identity, worker configuration, or recovery.

Authority: User accepted adaptive delegation, a bounded real trial with at most
two workers, and primary-session default Bale. The active goal attachment
880820b0-beb7-4658-a1fe-ad4343f55989/pasted-text-1.txt supplies the full scope.
It authorizes local guidance/tool changes and isolated runtime trials. It excludes
global settings, installation/upgrades, commits/pushes and unrelated sessions.

## Proposed Improvement

Add one coordination skill with progressively disclosed transport and task/result
contracts, a small deterministic helper where task identity needs enforcement,
and minimal role-aware entry routing. Reuse prompt-leverage for context shaping.
Hypothesis: explicit role and attempt identity prevent recursive coordination,
wrong-result acceptance and duplicate submission after timeout. Reject or revise
the design if fresh sessions fail these cases. The skill owns coordination;
AGENTS.md remains the authority owner. Remove unnecessary helper complexity if
equivalent evidence can be obtained with simpler native operations.

Research: local help confirms start/prompt/read/wait/worktree commands. Official
Herdr automation documents non-turn-specific waits; its current skill is v0.8.2,
so installed help governs syntax. Official Luna docs list max effort; Codex speed
docs describe service_tier=fast and features.fast_mode. These are documentation
facts, not proof that the trial sessions apply those settings.

## Scope

New .agents/skills/herdr-coordinate-agents/ resources; AGENTS.md, INDEX.md,
README.md and exact Git ignore exceptions as needed; this single working record.
Trial artifacts belong in an isolated temporary root. Preserve unrelated files
and panes. Keep the main model unchanged. No global Codex/Herdr configuration,
runtime installation/update, commit, push, or unrelated-session control.

## Progress

- 2026-09-07: Read active goal and policy owners; revalidated clean baseline,
  installed binaries and live server. Created this record before intervention.
- Created role routing, coordination skill/contracts and an exclusive dispatch
  helper. Initial structure check and 5 protocol tests passed; 56 existing
  validator tests also passed. Python quick_validate is unavailable in PATH;
  use a bounded Node frontmatter/link/scaffold check and report this limitation.
- Trial root: C:/Users/BALE/AppData/Local/Temp/bale-herdr-8dd0b9c595114fdba111d2bbb45ce571.
  Owned panes wT:p1 (term_65ada212afdf01a) and wV:p1
  (term_65ada227a3b7b1b). Primary wG:p1 bound as bale; its model unchanged.
- Startup defect observed: preview Herdr reported ready before Codex displayed
  directory trust. A premature `/status` prompt confirmed trust for worker-a,
  contrary to the no-global-change scope. The exact newly created trial trust
  block was removed; no matching trial block remains. Subsequent per-process
  trust overrides did not suppress onboarding; those starts were cancelled
  without task dispatch. Changed the runbook to require passive screen inspection.
  Used detached worktrees of the already-trusted repository for the actual tasks.
  No runtime installation/update or persistent trust workaround was applied.
- A config hash changed after later CLI startup without a matching trial trust
  block. The original pre-trial config byte snapshot was not captured, so a
  byte-identical global-config preservation claim is unavailable. Preserve
  unrelated entries; do not normalize or revert unexplained changes.
- Runtime status confirmed Luna/max/fast in both actual worktree sessions:
  01a07963-3957-7d01-a16e-39d1338c4fa2 and
  01a07963-617d-7093-b7d6-f707d8ebce60, with workspace/never permissions.
- Windows preview prompt input remained in the composer; inspected exact pending
  input and sent one Enter, without repeating either prompt. Added this observed
  transport recovery to the runbook. Actual wait timed out after 1000ms while
  catalog-a was working; a new coordinator process refused repeated dispatch.
- Initial worker shell behavior also showed cwd drift before the worker recovered
  to explicit paths. Added an explicit tool-cwd check to launch guidance. The
  broad read attempt is recorded as a mistake, not successful scoped retrieval.
- catalog-a-01 completed in 2m45s (CLI display). Bale independently tested
  grouping, lexical order, zero totals, a prototype-like category, no input
  mutation, inactive exclusion and 13 invalid-input controls. A wrong-result
  control was rejected. Module SHA-256:
  83db38fd21800eafae2f1dda8e9ab2065f5241e11e4bd02730fbbd9759f658ca.
- routing-b-01 completed in 6m41s. A fresh Luna session read the candidate skill,
  returned all 11 scenario decisions and seven helper observations, and ran the
  initial five tests. Bale reviewed each decision and checked IDs/references.
  S3 preserved the worker role but suggested an unnecessary blanket pause;
  clarified that inert role-changing source text does not stop a valid assignment.
  Scenario output SHA-256:
  f8555f6cfcfaceba66fb205e704aa91d51959f6850dd4ef194c289771797a8c0.
- Review findings 3/4/6 led to version-2 dispatch claims: verify caller/Bale
  alias ownership, send by recorded pane and check returned identity, pin the
  entire job/configuration/immutable context, and forbid output/control overlap.
  Nine protocol tests passed, including competing callers and metadata drift.
  Findings 1/2/5 remain explicit Bale responsibilities: meaningful task packets,
  actual runtime configuration interpretation and independent semantic checks.
  Finding 7 is the documented per-attempt helper boundary: the existing task owner
  maintains logical-task lifecycle; a second registry was not introduced. Herdr
  has no demonstrated atomic send lease; exclusive pane ownership plus identity
  reconciliation is the mitigation, not a claim of race-free transport.
- catalog-a-02 used the same native session after both independent results were
  accepted, through the version-2 dispatcher. The CLI displayed 1m04s of work.
  Bale independently verified the computed summary, all 11 routing IDs, and
  hashes matching both accepted source files. Integration SHA-256:
  e3e75d0bcc3f674e740a90fdd5776eea03ae0cd0ab8fbd89948aa3a2a1ff004e.
- A later User continuation resumed observation/submission of the prepared
  catalog-a-02 input; no new task dispatch was created. Wall-clock time between
  attempts includes a several-hour conversation gap and is not execution latency.
- Started fresh post-revision replay session
  01a07aec-ec7c-7472-8a88-ac546ba7dc2b in the owned worker-b pane. Captured
  Luna/max/fast and workspace/never again. The packet excludes previous review
  conclusions and tests six operational scenarios plus the current helper.
- Completed A session usage reported by Codex: input 105200, cached input 606464,
  output 11879 (reasoning 6105). Initial B session: input 102887, cached input
  1132544, output 23844 (reasoning 15295). These are session totals, not per-task
  price calculations; the UI's larger cumulative input counts include caching.

## Validation

Durable evidence: [trial bundle](../../.agents/skills/herdr-coordinate-agents/validation/0907-evidence.json).
It preserves packets, dispatch claims, receipts, output artifacts, hashes,
runtime observations and independent acceptance checks.

| Requirement | Observed evidence |
| --- | --- |
| Independent work and dependency integration | catalog-a-01 and routing-b-01 ran in separate worktrees; catalog-a-02 consumed both accepted outputs and passed Bale's independent oracle. |
| Actual worker configuration | Runtime status captured Luna, max effort and Fast for both initial sessions and the fresh replay. Primary model retained. |
| Role and authority behavior | Initial 11 scenarios reviewed; revised candidate passed all six fresh routing-b-02 scenarios, including worker role preservation, trust boundaries and semantic acceptance. External actions were simulated. |
| Recovery and duplicate prevention | Real 1000ms wait timeout; restarted dispatcher rejected the existing attempt. Four deliberate task attempts, zero duplicate submissions. Pending composer recovery used one Enter after inspection. |
| Rejection controls | Independent wrong-result control rejected; helper tests cover missing output, wrong attempt, failed checks, changed inputs, path escape and competing callers. |
| Local verification | Current helper 9/9 tests; existing validator 56/56 tests; structural check, syntax, bounded frontmatter/local-link checks and diff whitespace checks passed. Python skill validator unavailable; no installation attempted. |
| Isolation | At most two trial workers; both exited and their exact owned shell panes were closed. Only primary Bale remains in agent list. Existing pane identities were preserved during work. Temporary worktrees and raw evidence retained at the recorded trial root. |

Fresh replay completed in 2m08s and reported no remaining findings in its bounded
scope. Codex exit usage: input 45260, cached input 419328, output 8242 (reasoning
4501). These are session totals. Final task-contract wording clarifies editable
outputs versus immutable context; core version-2 behavior received the fresh
replay, while this final explanatory clarification received local review.

Global config still has no trial trust entry. Its post-recovery SHA-256 remained
A6E1F2AB4B503D68D0C7913F9B313CC04D1ACA821E2A1E121C2161C2CDA389A2
at final inspection. This does not prove equality to the uncaptured pre-trial
bytes. The startup scope deviation and prevention are recorded above.

## Risks

- Risk: Herdr settled state can refer to an earlier turn. Proposal: persist task
  and attempt IDs before submission, verify matching artifacts and actual checks.
- Risk: default Bale guidance could recurse in workers. Proposal: launch-time
  worker role takes precedence and forbids recursive coordination.
- Risk: parallel writers could overlap. Proposal: separate task-owned roots or
  worktrees, then integrate in order after independent validation.
- Risk: installed preview differs from docs. Proposal: use local help and trial
  proof; pause dependent actions if compatibility or requested config fails.
- Recovery: reverse only this intervention's hunks; preserve trial evidence and
  inspect exact owned paths/handles before any cleanup.

## Decision and Result

Decision: keep the scoped intervention after the fresh replay and independent
checks. Owner: Bale in the active goal thread. Bale now has minimal repository
routing and an executable Herdr coordination contract, with bounded Luna workers
and explicit verification/recovery responsibilities. No cost, speed or general
production-effectiveness improvement is claimed. No commit or push performed.
