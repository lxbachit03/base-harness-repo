# Harness Improvement Resource

ID: #002_IMPROVE_HARNESS_0812
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Route goal-griller requests to the lightest specialist skill
CREATED: 2026-08-12
STATUS: completed
REFERENCES:
- .agents/skills/goal-griller/SKILL.md
- docs-harness/WORKFLOW.md
- docs-harness/INDEX.md

## Objective

When a User invokes `$goal-griller`, the agent should keep it as the goal
front door but route the resulting work to the lightest applicable specialist:
direct handling, `$prompt-leverage`, `$xia`, `$sequence-execution-plan`, or
explicit `$improve-harness`.

## Current State

Observed trajectory: the User reported using `$goal-griller` for nearly every
prompt to create a goal and asked what the other skills add. The accepted
operating recommendation was to keep goal-griller as the front door and route
to specialists instead of treating it as the implementation, research,
sequencing, or Harness-experiment engine.

Baseline:

- Repository root: `/Users/bale/Documents/Repositories/test-repo/test_custom_harness`
- Revision: `efd28d068861a6a959a206380baed19f7fd06fdb`
- Branch: `main`
- Worktree: clean before this experiment
- Goal-griller SHA-256 before intervention: `96468dc2110de5d2911484b10160c8c3c4b7e00a16691b591b3c35c662d4c687`
- Existing proof: the six-field goal gate and `/goal` contract
- Known limitation: no explicit specialist-routing or simple/read-only triage

## Proposed Improvement

If a routing-and-triage section is added to `.agents/skills/goal-griller/SKILL.md`,
then a fresh agent will identify the lightest next skill after shaping the goal
and avoid creating autonomous goals for simple/read-only prompts, because the
skill will make the route decision explicit and preserve the repository's
read-only and authority boundaries.

Evidence that would weaken this:

- A fresh equivalent prompt still produces no route or selects every specialist.
- A simple/read-only prompt still creates a goal or mutates goal state without
  explicit User authorization.
- The route causes the agent to bypass `AGENTS.md`, `docs-harness/INDEX.md`,
  validation, or the explicit `$improve-harness` authority gate.

Maintenance owner and removal condition:

- Owner: repository Harness maintainers.
- Remove or revise the routing section if fresh reruns show added ceremony,
  incorrect specialist selection, or no reduction in human steering.

## Scope

In scope:

- One bounded change to `.agents/skills/goal-griller/SKILL.md`.
- A route/triage rule for direct handling, `$prompt-leverage`, `$xia`,
  `$sequence-execution-plan`, and explicit `$improve-harness`.
- Explicit protection for simple/read-only prompts.
- This experiment record and its `INDEX.md` routing entry.

Out of scope:

- Changes to the specialist skill implementations.
- Automatic invocation of every specialist.
- Product code, external systems, credentials, or the optional control plane.
- Claiming improvement before a fresh rerun.

## Validation

During work:

- Check the edited Markdown and all referenced local paths.
- Verify the route covers direct, prompt-upgrade, research, sequencing, and
  Harness-improvement cases without weakening existing goal-griller gates.
- Run repository-native skill checks where available.

Final proof:

- Inspect the diff and `git diff --check`.
- Run fresh equivalent prompts for simple/read-only, unfamiliar implementation,
  dependency-heavy work, and explicit Harness friction.
- Record separately whether routing was available, retrieved, invoked, and
  whether human steering changed.

## Risks

The route could add ceremony to simple tasks or encourage unauthorized goal
creation. Mitigation: make direct handling the default for simple/read-only
requests and require explicit authorization before goal-state mutation.

The specialist plan-template authority is currently inconsistent between
`AGENTS.md` and `docs-harness/WORKFLOW.md`. Mitigation: do not silently resolve
that conflict in this intervention; pause before creating a durable plan when
the conflict affects the task.

## Intervention Result

Implemented one intervention in `.agents/skills/goal-griller/SKILL.md`:

- Added explicit triage for `direct`, `$prompt-leverage`, `$xia`,
  `$sequence-execution-plan`, and `$improve-harness`.
- Made direct handling the default for simple/read-only work unless the User
  explicitly requests autonomous goal state.
- Added the `Route` handoff block to the goal contract.
- Preserved `AGENTS.md` → `docs-harness/INDEX.md` routing, risk-to-proposal
  handling, and the explicit `$improve-harness` authority gate.

Bookkeeping updated `docs-harness/INDEX.md` for this record.

Native validation:

- `git diff --check`: pass.
- Route-contract assertions and required-path checks: pass.
- `.agents/skills/prompt-leverage/scripts/test_augment_prompt.py`: pass.
- Scope is limited to the goal-griller intervention, its active record, and
  the required INDEX entry.

## Fresh Rerun Evidence

Fresh-route evidence supplied by the User on 2026-08-12:

- `direct`: handled the read-only request correctly and created no goal or
  resource state.
- `$xia`: produced a research brief and stopped at the schema question.
- `$sequence-execution-plan`: produced a dependency plan and stopped at P0
  because scope was missing.
- `$improve-harness`: confirmed that the baseline was sufficient, did not
  self-authorize a new intervention, and preserved the pending fresh-rerun
  boundary during the route check.

The four route outcomes establish that the routing intervention was available,
relevant, and invoked for the corresponding task classes. Separate retrieval
telemetry was not captured. No additional human steering or retries were
reported in the supplied evidence; this record does not claim stronger
telemetry. Existing worktree changes were preserved and no reset or cleanup was
performed.

Comparison with baseline:

- Baseline: the User reported using `goal-griller` for nearly every prompt to
  create a goal, without specialist triage.
- Fresh rerun: the lightest applicable route was selected, read-only work did
  not create autonomous state, and specialist routes stopped at their stated
  evidence or authority boundary.

## Fresh Rerun Decision

Decision: keep.

The fresh route results exercise the routing intervention across direct,
research, sequencing, and explicit Harness-friction cases. They show the
intended reduction in all-purpose goal creation while preserving specialist
pause and authority behavior. The intervention remains owned by repository
Harness maintainers; revise or remove it if later equivalent reruns show added
ceremony, incorrect selection, or increased human steering.
