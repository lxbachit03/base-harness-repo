# Documentation Map

Start with the smallest current map. Retrieve compatibility, historical, or
upstream-maintenance material only when the task explicitly needs it.

## Installed Core

- `docs-harness/WORKFLOW.md`: canonical request, planning, judgment, validation, and
  completion behavior.
- `product/`: consumer-owned product behavior derived from accepted intent.
- `plans/`: one evolving Git-native plan for work that needs durable memory.
- `decisions/`: lasting product and architecture choices.
- `templates/decision.md`: lasting-decision template.
- `templates/exec-plan.md`: durable execution-plan template.
- `.agents/skills/onboard-repository/`: explicit, read-only-first brownfield
  repository mapping and improvement proposals.
- `.agents/skills/audit-onboarding-proposal/`: explicit independent proposal
  and patch verification.

These files are generic Harness structure. They do not select an application
stack, replace a consumer README or architecture, fabricate validation
commands, or require the optional SQLite control-plane lifecycle. The installed
`harness` binary only maintains this core structure. The skills do not run
automatically; invoke `$onboard-repository` only when repository onboarding is
the requested outcome.

## Consumer-Owned Truth

The consumer repository's own README, architecture, code, tests, CI, runtime
signals, and application behavior remain authoritative. Harness adds navigation
and working-memory structure around that truth; it does not install upstream
`repository-harness` product documents over it.

## Documentation Ownership

- `docs-harness/` is the canonical context for AI agents and the Harness repo.
- `docs/` is reserved for team-facing documentation and is not read by Harness
  by default. This repository may omit the directory entirely.

## Local Folder Guide

Use [`INDEX.md`](INDEX.md) as the routing authority. The folders below are
separate context types; do not place a resource in a different folder merely
because its subject overlaps:

- `harness-constraints/`: rules that constrain files, folders, or a specific task.
- `decisions/`: lasting product, architecture, data, security, compatibility,
  or validation choices.
- `domain/`: confirmed or uncertain project/domain knowledge.
- `harness-improvements/`: the routing category for improvements to agent
  guidance, tools, runbooks, or validation.
- `plans/`: durable execution working memory, with active and completed
  lifecycle folders.
- `tickets/`: ticket intake, working records, attachments, and generated
  resolution artifacts managed by `$ticket-solving`; `active/` is the default
  route and `completed/` is historical context.
- `product/`: consumer-product behavior derived from accepted intent.
- `proposals/`: options and recommendations awaiting User authority.
- `risks/`: security, performance, and memory-leak risk records.
- `templates/`: stable placeholders used to create supported resources.

Start with `AGENTS.md`, then `INDEX.md`, and read only the routed README or
resource needed for the current intent.

## Source-Repository Indexes

The following material is deliberately outside the default installation:

- [Application-legibility plan](https://github.com/hoangnb24/repository-harness/blob/main/docs/plans/active/application-legibility.md): current consumer-first evidence matrix and next gate.
- [Control-plane freeze decision](https://github.com/hoangnb24/repository-harness/blob/main/docs/decisions/0022-control-plane-freeze-and-compatibility-runway.md): current compatibility boundary for SQLite and protocol v1.
- [Optional-consumer ownership decision](https://github.com/hoangnb24/repository-harness/blob/main/docs/decisions/0023-optional-consumer-ownership.md): current ownership split between Harness, Symphony, and consumer applications.
- [Test suite map](https://github.com/hoangnb24/repository-harness/blob/main/tests/README.md): behavior protected by each current, compatibility, and historical test group.
- [CLI compatibility index](https://github.com/hoangnb24/repository-harness/blob/main/docs/compatibility/README.md): SQLite lifecycle, orchestration protocol, bootstrap, schemas, and CLI maintenance.
- [Historical index](https://github.com/hoangnb24/repository-harness/blob/main/docs/provenance/README.md): superseded decisions, story-era evidence, reviews, and migration provenance.
- [Upstream repository](https://github.com/hoangnb24/repository-harness): Rust implementation, installer, release, and maintenance truth.

Selecting the optional CLI profile installs the compatibility material required
to operate that surface. Historical and upstream-only material remains in the
source repository and Git history.
