# Harness Improvements

This is the IMPROVE_HARNESS routing category for a requested guidance, skill,
tool, runbook, or validation change after observed reusable friction.
docs-harness/SESSION.md owns task authority. The improve-harness skill owns the experiment
steps and fresh-rerun protocol.

Every new authorized improvement has one MMDD-description.md record directly
in this folder, including bounded changes. Follow the create/resume, naming,
collision and completion rules in .agents/skills/improve-harness/SKILL.md.
Use docs-harness/templates/harness-improvement.md and list the canonical record
under [Records](#records) in ID order; INDEX routes this list rather than each
record. Continue the same improvement in its existing file; completed records
remain here with their final status and evidence.

Legacy experiments under plans/ retain their existing paths and lifecycle and
are listed in [plans/completed/README.md](../plans/completed/README.md); they
are not migrated or duplicated automatically. A consistency review
accepted by the User may authorize updates to the policy owner and consumers
together. Read-only requests do not create records, and speculative cleanup is
not automatic post-task work.

Native checks establish structural correctness. A fresh bounded scenario can
establish instruction routing or permission behavior; it does not measure
production productivity. Record keep/revise/remove only with the relevant
replay evidence, or pending fresh rerun with a concrete next case and owner.
Preserve old experiment evidence when its policy is superseded.

## Records

Coordination-skill references in earlier records are historical, including
records with a pending experiment status. Their deleted paths remain available
at revision `6b1bd92`; they are not current skill entry points.

- [One record per improvement](0906-per-improvement-records.md) — `#015_IMPROVE_HARNESS_0906`, `PRIORITY: [MEDIUM]`
- [Bale orchestration through independent Herdr agents](0907-bale-herdr-orchestration.md) — `#016_IMPROVE_HARNESS_0907`, `PRIORITY: [MEDIUM]` — historical skill-creation record
- [Agent self-validation and validator retirement](0912-agent-self-validation.md) — `#017_IMPROVE_HARNESS_0912`, `PRIORITY: [MEDIUM]`
- [User-selected Herdr worker model catalog](0912-herdr-agent-catalog.md) — `#018_IMPROVE_HARNESS_0912`, `PRIORITY: [MEDIUM]`
- [Receipt-first Herdr observation with bounded transcript fallback](0912-herdr-bounded-observation.md) — `#019_IMPROVE_HARNESS_0912`, `PRIORITY: [MEDIUM]`
- [Bale review gate for delegated code quality and resource efficiency](0913-herdr-bale-code-review.md) — `#020_IMPROVE_HARNESS_0913`, `PRIORITY: [MEDIUM]`
- [OpenCode Go worker model catalog](0913-opencode-go-model-catalog.md) — `#021_IMPROVE_HARNESS_0913`, `PRIORITY: [MEDIUM]`
- [Windows OpenCode launch and lean Herdr dispatch](0913-opencode-windows-launch-and-lean-herdr.md) — `#022_IMPROVE_HARNESS_0913`, `PRIORITY: [MEDIUM]`
- [Remove strict onboarding and audit skills](0913-remove-strict-onboarding-skills.md) — `#023_IMPROVE_HARNESS_0913`, `PRIORITY: [MEDIUM]`
- [Keep Herdr coordination in the current Git checkout](0919-herdr-shared-checkout.md) — `#024_IMPROVE_HARNESS_0919`, `PRIORITY: [MEDIUM]`
- [Preserve improvement purposes as a checklist](0919-improvement-purpose-checklist.md) — `#025_IMPROVE_HARNESS_0919`, `PRIORITY: [MEDIUM]`
- [Claude Code capability routing skill and team catalog](0921-utilizing-tools-claude-capability-catalog.md) — `#026_IMPROVE_HARNESS_0921`, `PRIORITY: [MEDIUM]`
- [Converge the utilizing-tools skills on the routing pattern](0921-utilizing-tools-skill-parity.md) — `#027_IMPROVE_HARNESS_0921`, `PRIORITY: [MEDIUM]`
- [Tune tight-handoff wait/observation timeout guidance for OpenCode Go workers](0922-opencode-go-tight-handoff-wait-timeout.md) — `#028_IMPROVE_HARNESS_0922`, `PRIORITY: [MEDIUM]`
- [Document Herdr `--kind agy` (Antigravity) done-signal unreliability as expected, not exceptional](0922-agy-done-signal-reliability.md) — `#029_IMPROVE_HARNESS_0922`, `PRIORITY: [MEDIUM]`
- [Model-specific add-on prompt layers](0926-model-family-layer-prompts.md) — `#030_IMPROVE_HARNESS_0926`, `PRIORITY: [MEDIUM]`
- [Orca ADE documentation, capability routing skill, and Herdr coordination](0926-utilizing-tools-orca-ade.md) — `#031_IMPROVE_HARNESS_0926`, `PRIORITY: [MEDIUM]`
- [Pure Orca ADE multi-agent coordination skill and Claude sync](0926-orca-ade-coordinate-agents.md) — `#032_IMPROVE_HARNESS_0926`, `PRIORITY: [MEDIUM]` — historical skill-creation record
- [TypeSafe Jev semantic primitives and native PowerShell helper with graceful fallback](0927-typesafe-ai-skill-integration.md) — `#033_IMPROVE_HARNESS_0927`, `PRIORITY: [MEDIUM]`
- [TypeSafe Jev best practices implementation for task authority, selective routing, ticket triage, and domain freshness](0927-typesafe-best-practices-integration.md) — `#034_IMPROVE_HARNESS_0927`, `PRIORITY: [MEDIUM]` — historical; helpers retired in #050 and #051
- [Dynamic Jev manifest and enhance-jev skill for project-specific customization](0927-dynamic-jev-manifest-and-enhance-skill.md) — `#035_IMPROVE_HARNESS_0927`, `PRIORITY: [MEDIUM]` — skill removal recorded in #052
- [Layer-2 hooks mechanism with jev-hook pre-action Jev gate](0930-layer-2-hooks-and-jev-gate.md) — `#036_IMPROVE_HARNESS_0930`, `PRIORITY: [MEDIUM]`
- [Retire the missing #012 plan route from INDEX](1003-retire-missing-012-plan-route.md) — `#037_IMPROVE_HARNESS_1003`, `PRIORITY: [NORMAL]`
- [User-invoked init-harness-repo skill for scaffolding a minimal Harness](1003-init-harness-repo-skill.md) — `#038_IMPROVE_HARNESS_1003`, `PRIORITY: [MEDIUM]`
- [Correctness fixes from the 2026-10-03 optimization review (group A)](1003-optimization-review-correctness-fixes.md) — `#039_IMPROVE_HARNESS_1003`, `PRIORITY: [MEDIUM]`
- [Record metadata cleanup from the 2026-10-03 optimization review (group E)](1003-record-metadata-cleanup.md) — `#040_IMPROVE_HARNESS_1003`, `PRIORITY: [NORMAL]`
- [Apply the User's group D policy decisions from the 2026-10-03 optimization review](1003-group-d-policy-decisions.md) — `#041_IMPROVE_HARNESS_1003`, `PRIORITY: [MEDIUM]`
- [Apply the User's group B decisions to reduce always-loaded Harness context](1005-group-b-context-load-reduction.md) — `#042_IMPROVE_HARNESS_1005`, `PRIORITY: [MEDIUM]`
- [Apply the User's group C decisions to remove duplicated on-demand guidance](1005-group-c-deduplication.md) — `#043_IMPROVE_HARNESS_1005`, `PRIORITY: [NORMAL]`
- [Make the shell gate always consult Jev and apply the User's Jev guidance decisions](1005-gate-and-jev-decisions.md) — `#044_IMPROVE_HARNESS_1005`, `PRIORITY: [MEDIUM]` — historical gate behavior superseded in #050
- [Coordinate agents on the current branch without Git worktrees, for Herdr and Orca](1005-coordination-without-worktrees.md) — `#045_IMPROVE_HARNESS_1005`, `PRIORITY: [MEDIUM]`
- [Apply the User's repository, record and template decisions from the optimization review](1005-repo-and-record-decisions.md) — `#046_IMPROVE_HARNESS_1005`, `PRIORITY: [MEDIUM]`
- [User-owned raw requirements folder with an INDEX warning](1005-raw-requirements-source.md) — `#047_IMPROVE_HARNESS_1005`, `PRIORITY: [MEDIUM]`
- [Remove the Herdr and Orca ADE coordination skills](1031-remove-coordination-skills.md) — `#048_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]`
- [Improve TypeSafe Jev integration reliability](1031-jev-integration-reliability.md) — `#049_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]` — historical helper coverage superseded in part by #050 and #051
- [Retire three Jev helper scripts](1031-retire-jev-helpers.md) — `#050_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]` — retained router subsequently retired in #051
- [Retire the Jev skill router](1031-retire-jev-skill-router.md) — `#051_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]`
- [Remove the enhance-jev skill](1031-remove-enhance-jev.md) — `#052_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]`
- [Make Codex capability discovery work across sessions](1031-codex-capability-discovery.md) — `#053_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]`
- [Explain onboarding E2E flows one step at a time](1031-onboarding-step-flows.md) — `#054_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]`
- [Keep decision history inside each ticket](1114-ticket-decision-history.md) — `#055_IMPROVE_HARNESS_1114`, `PRIORITY: [MEDIUM]`
- [Remove the product, risks and proposals folders](1114-remove-product-risk-proposal-folders.md) — `#056_IMPROVE_HARNESS_1114`, `PRIORITY: [MEDIUM]`
- [Load project constraints at every session start](1115-project-constraints.md) — `#057_IMPROVE_HARNESS_1115`, `PRIORITY: [MEDIUM]`
- [Route session policy through the Harness index](1115-session-policy-routing.md) — `#059_IMPROVE_HARNESS_1115`, `PRIORITY: [MEDIUM]`
- [Name onboarding E2E and activity step files](1115-onboarding-e2e-activity-files.md) — `#060_IMPROVE_HARNESS_1115`, `PRIORITY: [MEDIUM]`
- [Document prerequisite data in onboarding E2E overviews](1115-onboarding-e2e-prerequisites.md) — `#061_IMPROVE_HARNESS_1115`, `PRIORITY: [MEDIUM]`
- [Research ticket PRDs into traceable Markdown and HTML](1115-prd-research-skill.md) — `#062_IMPROVE_HARNESS_1115`, `PRIORITY: [MEDIUM]`
- [Repeatable read-only Harness status check](1115-harness-check-skill.md) — `#063_IMPROVE_HARNESS_1115`, `PRIORITY: [MEDIUM]`
- [Cut the session-start context load without losing routes](1115-session-start-context-cut.md) — `#064_IMPROVE_HARNESS_1115`, `PRIORITY: [MEDIUM]`
- [Consult Jev only on request and retire unused Jev test assets](1115-jev-trigger-and-fixture-cleanup.md) — `#065_IMPROVE_HARNESS_1115`, `PRIORITY: [NORMAL]`
- [Give every docs-harness folder a README](1115-folder-readmes.md) — `#066_IMPROVE_HARNESS_1115`, `PRIORITY: [NORMAL]`
- [Refresh the Claude Code catalog and routing skill to the 2026-11-15 runtime](1115-claude-catalog-refresh.md) — `#067_IMPROVE_HARNESS_1115`, `PRIORITY: [NORMAL]`
- [Add the asset-design-style skill with twelve researched UI style systems](1116-design-styles-skill.md) — `#068_IMPROVE_HARNESS_1116`, `PRIORITY: [NORMAL]`
- [Add the asset-design-systems-hallmark skill with fourteen researched Hallmark design systems](1116-hallmark-design-systems-skill.md) — `#069_IMPROVE_HARNESS_1116`, `PRIORITY: [NORMAL]`
- [Rename the asset-design-style skill to asset-design-systems](1117-rename-asset-design-systems-skill.md) — `#070_IMPROVE_HARNESS_1117`, `PRIORITY: [NORMAL]`
- [Ask the User to record an action they request a second time as an AGENTS.md rule](1120-repeat-request-rule-prompt.md) — `#071_IMPROVE_HARNESS_1120`, `PRIORITY: [MEDIUM]`
- [Ask the User to move AGENTS.md rules into project-constraints when the file passes 50 lines](1120-agents-md-length-rule.md) — `#072_IMPROVE_HARNESS_1120`, `PRIORITY: [MEDIUM]`
- [Move SESSION.md and WORKFLOW.md into trimmed harness-constraints and delete both files](1120-session-workflow-into-constraints.md) — `#073_IMPROVE_HARNESS_1120`, `PRIORITY: [MEDIUM]`
- [Add a claude-instructions folder that Claude sessions read at session start](1120-claude-instructions-folder.md) — `#076_IMPROVE_HARNESS_1120`, `PRIORITY: [MEDIUM]`
- [Run prd-research in a new Opus 5.5 high-effort sub-session when the User is on Claude](1120-prd-research-sub-session.md) — `#077_IMPROVE_HARNESS_1120`, `PRIORITY: [MEDIUM]`
- [Run coding tasks in a Sonnet 5.5 sub-session with a User-selectable effort](1120-coding-sub-session.md) — `#078_IMPROVE_HARNESS_1120`, `PRIORITY: [MEDIUM]`
- [Run code research in Haiku 5.5 subagents with a User-selectable effort](1120-research-subagents.md) — `#079_IMPROVE_HARNESS_1120`, `PRIORITY: [MEDIUM]`
- [Ask the User about /compact before a task when context is above 50%](1121-claude-compact-before-task.md) — `#080_IMPROVE_HARNESS_1121`, `PRIORITY: [MEDIUM]`
- [Let the coding sub-session consult an Opus 5.5 advisor, with an on/off switch and an effort checklist](1121-coding-advisor-addon.md) — `#081_IMPROVE_HARNESS_1121`, `PRIORITY: [MEDIUM]`
- [Add docs-harness/HERDR-TUI.md so Claude can open a Herdr pane and orchestrate other agents](1121-herdr-orchestration-instructions.md) — `#082_IMPROVE_HARNESS_1121`, `PRIORITY: [MEDIUM]`
- [Tell Herdr TUI, the Herdr desktop app and herdr-core (hc) apart in HERDR-TUI.md, and test hc for orchestration](1121-herdr-app-hc-orchestration.md) — `#083_IMPROVE_HARNESS_1121`, `PRIORITY: [MEDIUM]`
- [Split the Herdr instructions into HERDR-TUI.md (TUI) and HERDR-APP.md (desktop app and hc)](1121-herdr-app-file-split.md) — `#084_IMPROVE_HARNESS_1121`, `PRIORITY: [MEDIUM]`
- [Add to HERDR-APP.md how to show a worker in the Herdr desktop app window](1121-herdr-app-visible-worker.md) — `#085_IMPROVE_HARNESS_1121`, `PRIORITY: [MEDIUM]`
- [Offer the Herdr attach command when an own named session runs, with a box for Claude to open it](1121-herdr-own-session-attach.md) — `#086_IMPROVE_HARNESS_1121`, `PRIORITY: [MEDIUM]`
- [Refresh the utilizing-tools-agy skill and docs/tools/antigravity from five agy workers run through the Herdr desktop app](1121-agy-tools-skill-refresh.md) — `#087_IMPROVE_HARNESS_1121`, `PRIORITY: [MEDIUM]`
- [Start Herdr desktop app workers with --dangerously-skip-permissions so they do not ask the User](1121-herdr-app-skip-permissions.md) — `#088_IMPROVE_HARNESS_1121`, `PRIORITY: [MEDIUM]`
- [Add UBIQUITOUS-LANGUAGES.md, a shared glossary for the User, agents and the Harness repo](1121-ubiquitous-languages.md) — `#089_IMPROVE_HARNESS_1121`, `PRIORITY: [MEDIUM]`
- [Add an agy-instructions folder with four Antigravity operational guides read at session start](1122-agy-instructions-folder.md) — `#090_IMPROVE_HARNESS_1122`, `PRIORITY: [MEDIUM]`
- [Add a User-selectable /swarm dispatch option to agy-instructions/coding-subagent.md](1122-coding-subagent-swarm-option.md) — `#091_IMPROVE_HARNESS_1122`, `PRIORITY: [MEDIUM]`
- [Add three findings from a live Herdr desktop app test to HERDR-APP.md](1123-herdr-app-test-findings.md) — `#092_IMPROVE_HARNESS_1123`, `PRIORITY: [MEDIUM]`
- [Refresh the Claude Code catalog against the 2026-11-23 Desktop host](1123-claude-catalog-refresh.md) — `#093_IMPROVE_HARNESS_1123`, `PRIORITY: [MEDIUM]`
- [Add a code-graph skill and a Graphify catalog for projects with large codebases](1123-code-graph-skill.md) — `#094_IMPROVE_HARNESS_1123`, `PRIORITY: [MEDIUM]`
- [Add ticket-DoD.md to every ticket: what the User must answer or do before the ticket can close](1123-ticket-awaiting-user.md) — `#095_IMPROVE_HARNESS_1123`, `PRIORITY: [MEDIUM]`
- [Default browser screenshots to scale 0.5 and zoom for detail](1123-browser-screenshot-scale.md) — `#096_IMPROVE_HARNESS_1123`, `PRIORITY: [NORMAL]`
