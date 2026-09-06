# Harness Improvement Resource

ID: #014_IMPROVE_HARNESS_0906
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Audit behavior parity and restore unintended validator regressions
CREATED: 2026-09-06
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/templates/README.md
- docs-harness/domain/README.md
- docs-harness/tickets/README.md
- docs-harness/plans/completed/0906-task-authority-and-policy-consistency.md
- .agents/validators/sync-harness-index.js
- .agents/validators/sync-harness-index.test.js
- .agents/validators/README.md

## Objective

Compare the pre-enhancement rules and executable checks with the current
implementation, restore demonstrated unintended losses, and present intentional
behavior changes as explicit keep/revert decisions for the User. Do not claim
full equivalence from a passing subset of tests.

## Current State

Repository: D:/repos/base-harness-repo, branch main. Repair baseline:
c4c83890c6f085f4cdf3407e9af5aaed26646337, clean worktree, ahead of the locally
recorded origin/main by one commit. Comparison baseline:
7cf83c11a714954af68d27d90aeff511636c2a5c. Node v24.18.0; no installed package
dependencies for the validator. Python commands previously resolved to Windows
Store stubs, so no executed Python equivalence claim is available.

Authority: the User accepted the proposal to compare every old/new rule/check,
restore unintentionally lost checks, and separate behavior changes for a
keep/revert decision. Earlier explicit wrapper-removal requests remain binding.
This task does not authorize commit/push, installing a runtime, restoring deleted
wrappers, or deciding new product policy on the User's behalf.

After the explicit question about running the Node suite with isolated temporary
fixture setup/cleanup, the User replied "tiếp tục đi". This continuation was
interpreted and announced as approval of that specifically proposed command
class, not acceptance of P01 or any other general authority-policy change.

## Proposed Improvement

Use the existing pure analyze/planFix seams and Node regression suite. Capture
counterexamples before each repair, preserve the known-good controls, and run
an independent parity audit/replay. Reject the hypothesis if a repaired checker
still accepts a documented invalid case or rejects a valid current-contract case.
Owner: the Harness validator and relevant canonical guidance owner.

## Research Brief

- Recommendation (Inference): reuse the Node engine and native test runner;
  keep interface/policy migrations separate from invariant repairs.
- Confidence: high for this bounded approach; parity remains unproved until the
  old checks have been mapped and their counterexamples exercised.
- Local: original Python/JavaScript validators, current exported analyze,
  planFix, readSnapshot/main, and in-memory plus isolated CLI fixtures exist.
  The known duplicate-reference loss occurs when a Set removes duplicate entries
  before validation. This repo is agent guidance plus a dependency-free Node CLI.
- Upstream: inspected the version-tagged Node test documentation source at
  https://github.com/nodejs/node/blob/v24.18.0/doc/api/test.md; the browser view
  did not expose the relevant body, so it is not used as implementation proof.
- Docs: https://nodejs.org/download/release/v24.18.0/docs/api/util.html documents
  TextDecoder fatal decoding. The latest-v24 test guide is v24.20.0, not the
  installed v24.18.0; use existing local mock/test patterns and execute them on
  the installed runtime instead of assuming newly documented APIs work.
- Alternative rejected (Inference): restoring multiple engines or adding a
  parser dependency increases parity surfaces and conflicts with requested
  wrapper cleanup; no new dependency is required for the demonstrated repairs.
- Evidence boundary: native tests prove named cases, not all domain truth,
  production workflows, or historical runtime behavior.

## Scope

Audit all files changed by the enhancement and cleanup between the two baseline
commits. Edit only demonstrated regression seams, their executable tests and
current validator guidance, this record and its INDEX/ignore routing. Include
the directly affected AGENTS, ticket skill, and plan/ticket/domain templates
for the reported-risk qualifier and premature freshness-default omissions. Preserve
intentional workflow choices pending explicit User decisions and preserve old
experiment evidence. Record newly found ambiguities instead of guessing.

## Approach and Progress

- [x] Establish authority, clean baseline, research brief, and canonical owners.
- [x] Map changed rules/skills/templates and separate policy decisions.
- [x] Map legacy validator checks to current behavior and counterexamples.
- [x] Add regression cases, observe failures, and repair unambiguous losses.
- [x] Run full native verification and independent source/consistency reviews.
- [ ] Obtain the separate fresh post-repair behavioral replay (usage limit).
- [x] Record results and hand off outstanding keep/revert choices.

## Rule Comparison

Comparison is 7cf83c1 (before enhancement) -> c4c8389 (repair baseline) -> this
working diff. Source references below name the owning path and section, not an
assertion that every historical instruction remains current. The 60 changed
files are accounted for in File Coverage. Grouping duplicate instructions does
not erase their distinct workflow effects.

| Rule group and source owner | Before -> repair baseline | Disposition in this task |
| --- | --- | --- |
| G01: AGENTS/WORKFLOW, outcome and evidence | Repository authority, proportional proof, no policy invention, no automatic control-plane writes remain | Preserved/moved; no runtime/product code changed |
| G02: AGENTS, read-only work | Answer/review/diagnosis/status do not mutate; plan discussion remains in response | Preserved; planning wording clarified; authority changes are P01 |
| G03: WORKFLOW/plans README, durable work | Ephemeral for bounded work; one durable plan for coordination/dependencies/recovery; progress, result, proof before move | Preserved/moved; exec-plan becomes pointer to plan; no mandatory parallel records |
| G04: INDEX, retrieval/routing | INDEX entry point, relevant owners, filesystem tree, route metadata, update structural changes, no content-only rewrite | Preserved; loading/expansion changes are P02/P03 |
| G05: INDEX/PERSONA | One selected tone, Default on zero/multiple; conversation only | Preserved; persona source itself unchanged |
| G06: templates README, identity | One canonical file, global sequence, immutable date/ID, Bangkok MMDD, kebab filenames, template placeholders/no real IDs, collision pause | Preserved/moved; supporting kinds and minimum-width sequence are P11 |
| G07: risk constraint #001 | Every reported risk gets a suggested solution; authorized persisted pairs need resolvable reciprocal REFERENCES; suggestions are not acceptance | Restored accidental material-only narrowing in AGENTS, ticket skill, plan/ticket templates; independent owner review passed |
| G08: domain README | Source-backed claims, default UNCERTAIN, explicit confirmation, contradictions/questions, source/dependency references, five canonical sections, stale/needs-review pairing | Preserved/moved; template premature CURRENT default restored to placeholder; scope changes P05/P06/P07/P08/P09 |
| G09: tickets README | Source wording/identity/TBD, no invented criteria, direct single vs batch-child layout, artifact ownership/provenance, evidence, resolved distinct from completed, relevant history only | Preserved/moved; optional artifacts, maintenance/closure authority are P10 |
| G10: improve-harness + improvements README | Evidence baseline, hypothesis, owner intervention, contrary evidence, replay, keep/revise/remove, no fabricated effectiveness | Preserved in outline; activation, scope and proof requirements changed in P12 |
| G11: goal-griller | Six goal fields, observable success, constraints, evidence, specialist routing remain | Preserved; questioning/assumptions changed in P13 |
| G12: tool-selection skills | Mandatory declaration table, selecting available tools, bounded execution/reporting remain | Preserved; runtime catalog clarification and unavailable-docs fallback added; authority P01 |
| G13: old active plans | Eight original experiment bodies, IDs, results and pending reruns | Preserved byte-for-byte after stripping the added current-policy notice; checked in memory |
| G14: compatibility and docs | SQLite orchestration remains optional; team docs and upstream code not edited | Preserved capability, but docs access/navigation changes P04/P16 |

## Policy Decisions: Not Applied by This Repair

These are behavior differences, not merely shorter wording. Some are recorded
as accepted by the previous #013 intervention; this audit does not use that
record as a new User decision or silently revert it. Recommendation is a
suggestion only. Pending means the current repository text is left unchanged
by this repair, not that it supersedes instructions supplied by the User/runtime.

| Choice | Old -> current behavior | Recommendation and consequence |
| --- | --- | --- |
| P01: operation authority | Every mutation/side-effecting command needs explicit current-request scope -> implementation includes routine local tests/fixtures; authority persists; announce meaningful operations | Keep task-scoped edits/proof only if explicitly chosen; retain explicit external/destructive boundaries. Until resolved, honor the supplied stricter runtime gate |
| P02: session context | Load all active plan/ticket/risk bodies and reread INDEX each turn -> discover metadata, read relevant bodies, reuse unchanged INDEX, applicable critical constraints only | Keep selective loading to reduce irrelevant context; revert if exhaustive session awareness is required |
| P03: navigation boundary | Missing route pauses; Bottom-Up only explicit deep dive -> named paths/nearest owner and relevant dependencies can proceed read-only | Keep bounded discovery; preserve separate scope for unrelated surveys |
| P04: team docs | Read docs/ only for explicit team-documentation work -> read relevant linked/needed consumer docs | Keep relevant read access; preserve no bootstrap and scoped edits |
| P05: pause scope | Ambiguity/stale dependency often pauses workflow -> pause dependent action, continue independent authorized work | Keep scoped pauses; revert if a whole-task stop is intended |
| P06: domain capture | Onboarding, active ticket discovery, explicitly marked domain-discovery Q&A only -> also explicit domain additions and accepted Harness interventions | Keep ordinary Q&A read-only; confirm whether extra capture routes should remain |
| P07: schema tracing | Separate explicit field-analysis authority before record creation/tracing -> relevant read-only field tracing included in requested investigation; exhaustive audit separate | Keep relevant tracing if desired; revert for an explicit per-field gate |
| P08: freshness impact | Revalidate affected domains and uncertain overlaps -> revalidate affected claims/dependencies; line shifts alone need not mark stale | Keep claim-level proof with uncertain overlaps included; do not equate a path match with validation |
| P09: onboarding/schema detail | Five mandatory workspace artifacts, exhaustive entity detail, every diagram node/transition file+line -> proportional artifacts, compact schema template, path+symbol/revision option and external actors exception | Keep proportional artifacts only if desired. Explicitly decide exhaustive physical-storage/identifier/persistence/sensitive-field/assignment/query/API/lifecycle tables, synthesis/index step, and citation standard. Flow data-flow.md still requires line ranges; align only after that choice |
| P10: tickets | Always ticket.md/apis.md/entities.md/docs manifest, separate completion authorization, automatic completed-status normalization -> only applicable inventories/artifacts, inherited scoped closure authority, read-only drift reporting | Keep conditional artifacts and non-mutating inspection; choose closure authority separately. Existing evidence files remain preserved |
| P11: metadata/decisions | Global three-digit classification IDs and broad decision statuses -> at least three digits, immutable creation-kind after confirmation, unclassified PLAN/DECISION IDs, accepted-only decisions | Keep immutable identity and overflow support; choose supporting-kind exceptions and accepted-only decision storage explicitly |
| P12: improvement process | Observed runtime friction, narrow intervention, durable experiment and representative replay -> accepted rules review baseline, coherent multi-file intervention, durable only as needed, bounded scenario replay | Keep scoped review-driven improvement; do not infer production effectiveness from scenarios. Revert stronger evidence gate if desired |
| P13: skill activation/interview | Broader repository onboarding/audit trigger; ask for every missing goal field -> explicit strict protocol activation; discover facts first, ask only material choices, allow nonblocking assumptions | Keep reduced questioning for discoverable facts; choose whether strict onboarding must trigger more broadly |
| P14: validator interface | Two engines/wrappers, strict nested risk INDEX and old logs, permissive sync flags/fallbacks -> one Node engine, unified routes/logs, validated flags, conservative fixes | Keep one engine and safe fix. Select grammar/labels/sorting/ID-kind compatibility and flag/log guarantees separately; see V table |
| P15: ignore behavior | Empty local .gitignore -> ignore-by-default docs-harness and validators with exact exceptions | Prefer narrow exceptions that do not hide future relevant files; no broad ignore rewrite applied without choosing the intended local/global convention |
| P16: navigation/compatibility prose | Root README repeats loader rules and links team tool manuals; WORKFLOW explicitly names Rust CLI support -> owner table and optional SQLite/control-plane summary | Keep single owners; restore specific discovery links if required. No underlying compatibility code or team document was removed |

## Validator Check Comparison

Legacy source owners: validate-risk-proposal-links.py (scope, parser, metadata,
relationships, INDEX, snapshot/main); sync-harness-index.py and the former
sync-harness-index.js (metadata/discovery/domain/check/fix/main); shell launchers
and test-risk-proposal-links.sh (entry points and ten named fixture cases).
Current owners: analyze/referenceTargets/readSnapshot/planFix/main and the Node
test suite. Python sources were inspected, not executed on this machine.

| Check group | Old -> repair baseline -> disposition |
| --- | --- |
| V01: scope roots/INDEX/symlinks | Real roots, INDEX and risk/proposal directories required; no symlinks -> real docs/INDEX and symlinks checked, pair directories not required -> restored required pair directories and real docs directory type |
| V02: flat registry | No nested risk/proposal directories or non-Markdown entries -> silently allowed -> restored explicit scope errors; README remains guidance |
| V03: read/decode | Risk reader strict UTF-8/tooling error, sync reader sometimes skipped unreadable resources -> replacement decoding -> restored strict UTF-8 errors, no silent byte rewrite |
| V04: metadata | Required singleton fields, RISK tag, priority, ID/date/name, required headings -> generalized metadata checks; proposal classification/creation-kind choices differ -> core required fields/dates/headings preserved; unresolved kind/tag scope recorded separately |
| V05: IDs | Duplicate full risk/global IDs -> full IDs plus numeric sequence reuse checked -> preserved and strengthened; >=3 digits/creation kind P11 |
| V06: relationship grammar | Exactly one canonical link per bullet; no stray text -> extra text/URLs/entries could disappear -> restored invalid-entry rejection, including fenced text/subheadings, while retaining authorized raw canonical paths and immutable IDs |
| V07: duplicates | Reject duplicate target IDs in REFERENCES and related sections -> Set erased duplicates -> restored rejection before deduplication, including path/ID aliases |
| V08: path and label integrity | Canonical opposite-kind paths; no URLs/absolute/escaping/query/fragment/backslash; exact ID/title labels -> some raw paths and non-ID labels bypassed guards -> restored checks for every parsed entry/Markdown label |
| V09: reciprocity | Both sections nonempty, same literal link sets and reciprocal related sections -> same resolved counterpart sets and reciprocal REFERENCES -> semantic pairing preserved; exact lexical equality vs canonical equivalence remains P14 |
| V10: INDEX risk grammar | Risk-only top-level entries, nested proposals, ID sorting, exact labels, one entry per risk and all proposals -> standard multi-route entries, ID/priority per row, no sorting or exact title requirement -> intentional interface difference/P14, not silently restored |
| V11: general INDEX checks | Missing canonical and stale canonical links, duplicate IDs -> full descendant tree, route metadata/Resources, local links incl templates, classification/lifecycle coverage and per-route duplicate checks -> preserved/expanded; stricter acceptance is a behavior addition |
| V12: domain structure/state | Date-prefixed canonical README, metadata, DOMAIN + confirmation state, five sections, concrete references, freshness/status -> more exact state/date/metadata checks but placeholder and inline-reference losses -> restored incomplete/indented-placeholder rejection and concrete inline REFERENCES support |
| V13: snapshot | SHA256 of raw INDEX/pair scope, drift exit 2 even on invalid content -> normalized Markdown/empty binary values compared, error return before drift check -> restored raw-byte hashes for all current scoped files and tooling-error precedence; filesystem race guarantees remain bounded, not a lock |
| V14: fix safety | Remove whole stale-link lines; insert first matching route or append at EOF; fallback title/priority -> rebuild existing tree/add all required existing routes, refuse ambiguity/stale links -> intentional conservative change/P14 |
| V15: CLI/logs | Python argparse, positional risk core, shell --root/default-root/runtime discovery, old sorted rule/path/line summaries, test-delay env -> Node cwd/--root/check/fix/risk-links, new diagnostics/flags, mockable drift -> removed launchers explicitly requested; formatting/root defaults/test-delay compatibility not preserved |
| V16: resource scope | Direct canonical folder Markdown incl direct tickets -> metadata-bearing resources, nested domain README, exclude ordinary tickets/supporting children/templates -> intentional alignment with current resource contract; stricter metadata/default removal P11/P14 |
| V17: old shell test cases | Empty, valid pair, many-to-many, metadata, duplicate ID, bad path, one-way, orphan, missing nested proposal, snapshot drift -> corresponding Node controls/negative cases, with missing route replacing nested-only expectation -> named-case coverage, not an executed old Python equivalence proof |
| V18: non-structural truth | Neither implementation proves business truth, mitigation quality, external URLs, runtime performance or agent effectiveness -> unchanged limitation; use relevant source/behavior evidence for those claims |

Additional decision/test gaps from independent review: all proposals being risk
responses vs generic proposals (required RISK tag); historical ID-kind syntax;
exact INDEX route titles and required named routes for an empty pair registry;
non-domain confirmation tags; and risk-only mode's current metadata/domain
scope with routing omitted. These remain P11/P14 choices, not repaired defects.
Creation-date/filename mismatch logic exists, but the named suite is not a
complete combinatorial proof of every metadata/CLI branch. Proposal: decide
the intended accepted/rejected forms, then add targeted cases before changing
those checks. No fabricated accepted contract is inferred from a default.

## File Coverage

The following inventory accounts for all 60 paths returned by
git diff --name-only 7cf83c1 c4c8389. Paths are literal, including template braces.
R = rules above; P = pending policy choice; V = validator checks above.

| Path | Disposition |
| --- | --- |
| `.agents/skills/audit-onboarding-proposal/SKILL.md` | G01; P13 (strict invocation; protocol body retained) |
| `.agents/skills/domain-audit/SKILL.md` | G08; P06/P07/P08/P09 (capture, tracing, detail, freshness) |
| `.agents/skills/goal-griller/SKILL.md` | G11; P01/P12/P13 (authority, routing, questions) |
| `.agents/skills/improve-harness/SKILL.md` | G10; P01/P12 (baseline, experiment and replay) |
| `.agents/skills/onboard-repository/SKILL.md` | G01; P13 (strict invocation; protocol body retained) |
| `.agents/skills/onboarding/SKILL.md` | G08; P06/P07/P09 (flow evidence and artifact detail) |
| `.agents/skills/ticket-solving/SKILL.md` | G07/G09; P01/P10 (intake/solve/lifecycle); reported-risk omission repaired |
| `.agents/skills/utilizing-tools-agy/SKILL.md` | G12; P01 (runtime availability overrides example catalog) |
| `.agents/skills/utilizing-tools-codex/SKILL.md` | G12; P01 (authority, runtime docs fallback) |
| `.agents/validators/README.md` | V01-V18; shared engine/current contract and limits |
| `.agents/validators/sync-harness-index.js` | V01-V18; shared engine/current contract and limits |
| `.agents/validators/sync-harness-index.py` | V15/V17; explicitly requested removal; old source/test behavior mapped, no restoration |
| `.agents/validators/sync-harness-index.sh` | V15/V17; explicitly requested removal; old source/test behavior mapped, no restoration |
| `.agents/validators/sync-harness-index.test.js` | V01-V18; new Node evidence and restored negative controls |
| `.agents/validators/test-risk-proposal-links.sh` | V15/V17; explicitly requested removal; old source/test behavior mapped, no restoration |
| `.agents/validators/validate-risk-proposal-links.py` | V15/V17; explicitly requested removal; old source/test behavior mapped, no restoration |
| `.agents/validators/validate-risk-proposal-links.sh` | V15/V17; explicitly requested removal; old source/test behavior mapped, no restoration |
| `.gitignore` | P15; new exact audit-plan exceptions only in this task |
| `AGENTS.md` | G01-G08/G14; P01-P08/P12; reported-risk omission repaired |
| `README.md` | G01/G04/G14; P16 (owner routing and navigation) |
| `docs-harness/INDEX.md` | G04/G05/G06; P02/P03/P11/P14 (retrieval, routes) |
| `docs-harness/README.md` | G03/G14; P04/P13/P16 (plan pointer, docs, strict onboarding) |
| `docs-harness/WORKFLOW.md` | G01/G02/G03/G14; P01/P05/P11/P16 |
| `docs-harness/domain/README.md` | G08; P05/P06/P07/P08/P09 |
| `docs-harness/harness-constraints/0812-risk-proposal-suggestion-cross-link.md` | G07 preserved; P05 dependent pause scope |
| `docs-harness/harness-constraints/0822-user-authority-operation-gate.md` | P01; owner pointer replaces per-command gate |
| `docs-harness/harness-improvements/README.md` | G10; P12 (review baseline and replay) |
| `docs-harness/onboarding/README.md` | G08; P06/P09 (isolated flow/proportional workspace/synthesis) |
| `docs-harness/plans/README.md` | G03; P01/P11/P12 (canonical plan and lifecycle) |
| `docs-harness/plans/active/0815-ticket-lifecycle-routing.md` | G13; current-policy notice added; original body/evidence unchanged |
| `docs-harness/plans/active/0815-writing-for-agents-routing.md` | G13; current-policy notice added; original body/evidence unchanged |
| `docs-harness/plans/active/0816-filesystem-index-sync-rule.md` | G13; current-policy notice added; original body/evidence unchanged |
| `docs-harness/plans/active/0816-onboarding-skill-folder-routing.md` | G13; current-policy notice added; original body/evidence unchanged |
| `docs-harness/plans/active/0816-persona-response-style-routing.md` | G13; current-policy notice added; original body/evidence unchanged |
| `docs-harness/plans/active/0822-domain-e2e-flow-template.md` | G13; current-policy notice added; original body/evidence unchanged |
| `docs-harness/plans/active/0822-ticket-evidence-workspace.md` | G13; current-policy notice added; original body/evidence unchanged |
| `docs-harness/plans/active/0822-user-authority-operation-gate.md` | G13; current-policy notice added; original body/evidence unchanged |
| `docs-harness/plans/completed/0906-task-authority-and-policy-consistency.md` | G13; new intervention evidence, not retroactive proof of old plans |
| `docs-harness/templates/README.md` | G06/G08/G09; P07/P09/P10/P11 (catalog/identity/owners) |
| `docs-harness/templates/activity-diagram.md` | G08; P09 (relative citations, symbols/revisions, external actors) |
| `docs-harness/templates/apis.md` | G09; P01/P10 (conditional manifest, execution authority) |
| `docs-harness/templates/decision.md` | G06; P11 (metadata, accepted-only decisions) |
| `docs-harness/templates/domain-entity.md` | G08; P07/P09 (compact scope/evidence tables; exhaustive fields pending) |
| `docs-harness/templates/domain.md` | G08; P08/P11; premature CURRENT default repaired |
| `docs-harness/templates/entities.md` | G09; P10 (conditional manifest; review details preserved) |
| `docs-harness/templates/exec-plan.md` | G03; compatibility pointer to plan.md, no second plan contract |
| `docs-harness/templates/plan.md` | G03/G06/G07; P11; reported-risk omission repaired |
| `docs-harness/templates/ticket-docs-README.md` | G09; P10 (conditional manifest; exact-once ownership retained) |
| `docs-harness/templates/ticket.md` | G07/G09; P10 (compact template); reported-risk omission repaired |
| `docs-harness/templates/{sample-big-ticket}/{ticket-number}-{ticket-1}/README.md` | G09; P10 (batch child scaffold, optional artifacts) |
| `docs-harness/templates/{sample-big-ticket}/{ticket-number}-{ticket-2}/README.md` | G09; P10 (batch child scaffold, optional artifacts) |
| `docs-harness/templates/{service-name}/README.md` | G08; P07/P09 (template-only flow boundary, inherited detail scope) |
| `docs-harness/templates/{service-name}/data-flows/{data-flow-name}/apis.md` | G08; P01/P07 (canonical domain path; API evidence retained) |
| `docs-harness/templates/{service-name}/data-flows/{data-flow-name}/data-flow.md` | G08; P07/P09 (canonical path; overall/per-API diagrams retained; line citation choice) |
| `docs-harness/templates/{service-name}/data-flows/{data-flow-name}/entities.md` | G08; P07 (canonical path; field/relationship/enum evidence retained) |
| `docs-harness/templates/{service-name}/data-flows/{data-flow-name}/prerequisite.md` | G08; P01/P07 (ordered preparation/recovery retained, execution authority changed) |
| `docs-harness/templates/{ticket-number}-{single-ticket}/README.md` | G09; P10 (single-ticket scaffold, optional artifacts) |
| `docs-harness/tickets/README.md` | G09; P01/P10 (layout, ownership, inventory, lifecycle and handoff) |
| `docs-harness/tickets/active/README.md` | G09; P10 (nested discovery and applicable artifacts) |
| `docs-harness/tickets/completed/README.md` | G09; P01/P10 (history and non-mutating drift reporting) |

## Validation

- Baseline: 29 existing Node tests were previous evidence only, not parity proof.
- Red capture: expanded initial 50-case suite on c4c8389 engine produced 30 pass,
  20 fail. It exposed duplicate/grammar/label/scope/domain/UTF-8/raw-drift losses.
  An attempted negative include filter matched the file ancestor and executed
  all cases, including five filesystem-mutating fixtures. This exceeded the
  intended read-only run under the supplied runtime gate. The User was informed;
  fixture helpers cleaned their task-owned temporary roots. No working INDEX or
  real data was changed. Do not treat this accidental run as permission to rerun.
- Initial repair: 45 read-only cases passed via a collector, then native Node
  --test --test-skip-pattern '^(CLI|concurrent)' with 45/45 passing.
- Additional red capture: literal fenced/subheading entries, indented domain
  placeholders, and drift on invalid content gave 4 failures out of 51 selected
  cases. These were repaired at the parser/snapshot owners, then 51/51 passed.
- Read-only mocked UTF-8 and raw line-ending drift cases passed against the real
  installed Node runtime while preserving the working INDEX bytes. Mocks change
  returned bytes in memory only; they do not replace an OS-level fixture replay.
- node .agents/validators/sync-harness-index.js --check: exit 0 after initial
  repairs; checks tree, sections, links, routes, metadata, IDs, domain and pairs.
- node .agents/validators/sync-harness-index.js --risk-links: exit 0; this checks
  its documented restricted groups, not full INDEX routing parity.
- git diff --check: exit 0 (expected Windows LF/CRLF conversion warnings only).
- Historical preservation: all eight changed old active plans exactly match
  their old content after removing only the added current-policy notice.
- Scope: exactly 60 enhancement/cleanup paths mapped; validators still has only
  the Node engine, Node test file, and README. No wrappers/runtime installations,
  commit, push, team documentation or product code changes were made.
- Independent validator audit: confirmed eight baseline loss groups and listed
  preserved/strengthened checks plus the explicit policy gaps above; read-only
  monkeypatch probes reproduced baseline UTF-8 and line-ending acceptance.
- Independent rule review: five reported-risk/freshness instruction repairs
  match constraint #001 and the domain owner, with no new policy broadening.
- Fresh post-repair behavioral replay: repair_fresh_replay failed with a service
  usage-limit error before returning evidence. It is not a passing replay and
  the earlier independent source reviews do not substitute for it.
- Full post-repair suite: after the User's continuation approving the specifically
  proposed fixture command, node --test .agents/validators/sync-harness-index.test.js
  exited 0: 56 tests, 56 pass, 0 fail. All five real CLI/drift fixture cases ran;
  task-owned temporary roots were cleaned, and working INDEX preservation passed.
- Skill validation: the newly available skill-creator guide was read. Its
  quick_validate.py was inspected but not run: Python was unavailable, and its
  allowed-key list does not include the existing disable-model-invocation key.
  A bounded Node check instead verified unchanged ticket-solving frontmatter
  and invocation policy, required owner paths, and no unfinished TODO scaffold.
  Do not claim a Python skill-validation pass or rewrite invocation policy to
  satisfy an incompatible helper.

No old Python engine was executed (no usable interpreter was available); no
production effectiveness, speed gain, business truth or exhaustive equivalence
is claimed. Proposed follow-up: run the pending fresh replay when service access
is available and decide P01-P16 before claiming legacy-policy parity.

## Risks and Recovery

- Risk: blindly restoring old parser rules may undo deliberate policy changes.
  Proposal: separate invariant repairs from keep/revert choices, preserve current
  policy until the User chooses, and add valid-case controls for existing routes.
- Risk: incomplete negative coverage can give false confidence. Proposal: compare
  each old validator branch, test counterexamples, and use independent review.
- Risk: artifact cleanup could destroy evidence. Proposal: use task-owned temporary
  fixtures with exact-path checks and preserve historical records and IDs.
- Risk: byte-level snapshot checks add I/O for large non-Markdown attachments.
  Proposal: measure a representative large workspace before making performance
  claims; consider bounded streaming hashes if measured memory/I/O warrants it.
- Risk: the repository authority policy and the User-supplied runtime policy
  differ. Proposal: resolve P01 explicitly; in this task the stricter supplied
  gate controls fixture commands, regardless of the previous #013 record.
- Recovery: selectively reverse this task's diff against c4c8389; never overwrite
  concurrent User changes. No commit or external write is included.

## Result

Implementation and the 60-file comparison are recorded. Demonstrated parser,
scope, decoding, snapshot, reported-risk and freshness-default omissions have
been repaired without restoring the explicitly deleted wrappers. Intentional
workflow/interface differences remain unchanged for the User's keep/revert
decision. This is not a behavior-neutral enhancement or complete legacy parity.

Decision: pending fresh rerun, as required by improve-harness. Native proof is
complete; the service usage limit blocks the separate behavioral replay.
Owner: main agent when a fresh agent session is available. Replay task: use the
current validator guide in a fresh session to exercise invalid duplicate/alias,
malformed link/label, scope, UTF-8, raw-drift and domain-placeholder cases, plus
valid controls; verify low-severity reported risks still get a proposal and the
domain template does not assert CURRENT without evidence. Keep external actions
simulated. Review the observed result before moving this record to completed/;
preserve the User's unresolved policy choices and unrelated old experiments.
