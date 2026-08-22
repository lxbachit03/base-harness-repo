# Agent Instructions

<!-- HARNESS:BEGIN -->
## Harness

Start with the requested outcome, then use the repository as the system of
record. After the runtime loads `AGENTS.md`, read `docs-harness/INDEX.md`
before any other repository documentation. Use that routing map to read only
the relevant workflow, product, design, plan, code, and validation material.

- Answers, explanations, reviews, diagnoses, plans, and status reports are
  read-only. Inspect only what is needed and do not mutate repository or Harness
  state.
- For a bounded change, use an ephemeral plan: inspect the affected behavior and
  proof, implement, and validate. No control-plane operation is required.
- Create or update one file under `docs-harness/plans/active/` when work spans sessions,
  needs coordination, has meaningful dependencies, or requires recovery steps.
  Move it to `docs-harness/plans/completed/` only after validation.
- Before editing, identify repository authority for each new externally
  observable policy. If materially different choices remain open, stop before
  edits; configurable defaults are not authority.
- Report reusable agent friction. Change guidance, tools, runbooks, or validation
  for that purpose only when explicitly asked to use `$improve-harness`.
- Also pause when product intent remains ambiguous, recovery is difficult,
  validation is weakened, or authority is insufficient.
- Claim completion only with relevant executable or observable evidence. Report
  the outcome, important changes, validation, and unresolved risks.

### User Authority Gate

Read-only inspection is the default operating mode.

- Create, edit, delete, move, rename, copy, or generate files and folders only
  when the current User request explicitly authorizes that operation and its
  scope. This includes generated documentation, build artifacts, and
  formatter or fixer output.
- Build, test, lint, format, generate, install, migrate, and package commands
  that can change repository or environment state require explicit User
  authority for the command or command class. A request to implement,
  validate, use a skill, create a plan, or satisfy acceptance criteria does not
  by itself authorize such commands.
- A `$goal-griller` route, drafted goal, or `$improve-harness` invocation does
  not grant blanket operation authority. `$improve-harness` authorizes only the
  bounded Harness intervention named by the current User request.
- Before an authorized mutation or side-effecting command, state the target
  paths or command and the intended scope. If authority or scope is absent or
  ambiguous, pause and request it.
- Read-only inspection and proof may run without additional authority when the
  command does not create artifacts, caches, or other state. If the required
  proof needs an unauthorized build or test, report it as unattempted.

### Risk-to-Proposal Constraint

When the AI agent identifies a risk in an answer, review, diagnosis, plan,
implementation, or validation:

- Include at least one explicit proposal/solution for that risk in the same
  response.
- Treat the proposal as a suggestion only; do not apply it or represent it as
  accepted without User authority.
- If an authorized task persists the risk as a resource under
  `docs-harness/risks/`, persist a corresponding proposal resource under
  `docs-harness/proposals/` and add reciprocal `REFERENCES:` entries using each
  resource's canonical relative path or immutable resource ID.
- Do not claim the persisted risk/proposal work is complete while either
  resource is missing, either reference is one-sided, or either referenced path
  cannot be resolved.
- For read-only requests, do not create or modify resources; include the
  proposal/solution inline and report any missing cross-link as an unresolved
  gap.

### Documentation Ownership

- `docs-harness/` is the canonical context for AI agents and the Harness repo.
  Read it through `docs-harness/INDEX.md` and its routed resources.
- `docs/` is team-facing documentation, not a default Harness input. Do not
  read, bootstrap, or recreate it unless the User explicitly requests team
  documentation work.

## Harness Context

`docs-harness/` is the Harness repo/workspace context for personalizing the
relationship between the AI agent, User, Repository, and Domain Knowledge. It
is context for every User prompt. `docs-harness/INDEX.md` is the navigation hub
for that context; it points to resources and does not copy their contents.

If `docs-harness/` or `docs-harness/INDEX.md` does not exist, create or upsert
the missing path only when the current request authorizes repository changes.
For a read-only answer, review, diagnosis, plan, or status report, do not
bootstrap it; report the missing context instead. Preserve all existing
resources when creating or updating the routing file.

### Session Context Loading

Treat the current conversation as the session. The first prompt is the first
User message in that conversation.

For the first prompt of a session:

1. Inspect the `docs-harness/` folder tree and verify alignment with `docs-harness/INDEX.md` (perform a lightweight synchronization check if unindexed or moved resources exist).
2. Read `docs-harness/INDEX.md` before any other repository documentation.
3. Combine the instructions and context from `AGENTS.md` and `INDEX.md`.
4. Read `docs-harness/PERSONA.md` to identify the selected response tone (`- [x]`) and adopt that communication style for conversational responses (use Default if none or multiple are selected; never apply this persona tone to modified code files).
5. Automatically load active resources to establish current situational awareness:
   - `docs-harness/tickets/active/*.md`
   - `docs-harness/plans/active/*.md`
   - `docs-harness/risks/**/*.md`
   Do not automatically load `tickets/completed/`, `plans/completed/`, or `proposals/`.
6. Follow the Top-Down routing steps below and read additional resources marked
   `PRIORITY: [CRITIAL]`.

For every later prompt in the same session:

1. Read `docs-harness/INDEX.md`.
2. Use the Top-Down routing steps below to select relevant resources from the
   index.
3. Read only the resources needed for that intent.

### Top-Down Routing

Use `INDEX.md` as a token-saving router rather than scanning all of
`docs-harness/`:

1. Start at the folder tree.
2. Select a folder from the User intent, classification, and priority.
3. Read that folder's `Purpose`, `Read when`, and `Skip when` guidance.
4. Select candidate canonical resources from its `Resources` links.
5. Read only the selected resources and any required `PRIORITY: [CRITIAL]`
   resources.
6. Only then read `docs-harness/WORKFLOW.md`, product docs, code, tests, or validation
   files relevant to the routed intent.

Do not scan unrelated folders when `INDEX.md` provides a sufficient route. If
no route matches the User intent, pause or make the smallest authorized routing
update before reading broadly.

### Routing Modes

Top-Down is the default mode because it minimizes context and token use. Switch
to Bottom-Up only when the User explicitly requests a deep dive or an
unmistakable equivalent, such as `deep dive`, `tìm hiểu sâu`, `phân tích chuyên
sâu`, `đọc sâu`, `investigate thoroughly`, or `audit comprehensively`. Do not
infer deep-dive permission merely because an intent is complex.

For an explicit Bottom-Up deep dive:

1. Complete the Top-Down route to a starting folder or resource.
2. State the intended deep-dive scope before expanding context.
3. Read the routed starting resource.
4. Traverse only canonical INDEX links, `REFERENCES`, relevant dependencies,
   and related child resources.
5. Stop when the evidence answers the User intent or no related dependency
   remains.
6. Report the paths read and the reason each expansion was necessary.

Bottom-Up does not authorize reading the entire repository. If the starting
route or relationship to a candidate resource is unclear, pause instead of
scanning unrelated folders.

### INDEX Synchronization

The filesystem is the authority for the actual folder tree. `INDEX.md` is the
routing mirror and must remain aligned with that tree.

- Verify alignment at session start during Session Context Loading to catch any out-of-band additions or removals.
- Update `INDEX.md` in the same task after creating, moving, renaming, or
  deleting a file or folder.
- Update it when a resource's `TAG`, `PRIORITY`, `Purpose`, routing criteria, or
  canonical link changes.
- Do not rewrite it for content-only edits that do not affect routing metadata.
- Run a tree, folder-section, link, and duplicate-resource consistency check
  before claiming the task complete.
- Do not invent routes, resources, domain knowledge, or priorities to fill the
  index.

### Classification Tags

Use classification tags for resource and intent entries in the index. Keep the
literal spelling and format shown here:

- `TAG: [IMPROVE_HARNESS]`: an intent that improves the Harness repo. If the
  `improve-harness` skill is used, this tag is mandatory.
- `TAG: [CONSTRAINTS]`: a constraint on files or folders for a specific task. If
  the `constraints` skill is used, this tag is mandatory.
- `TAG: [DOMAIN] [CONFIRMED]`: project domain knowledge confirmed by an
  authoritative source or User.
- `TAG: [DOMAIN] [UNCERTAIN]`: project domain knowledge that requires User
  confirmation.
- `TAG: [RISK]`: an item involving security, performance, or memory-leak risk.

A resource may have multiple classifications. Represent each classification on
its own `TAG:` line; keep one canonical resource file and cross-link it from
each applicable index section.

### Priority Tags

Use exactly one priority for each real resource entry and let the AI agent
self-assess it:

- `PRIORITY: [CRITIAL]`
- `PRIORITY: [MEDIUM]`
- `PRIORITY: [NORMAL]`

Do not invent domain knowledge, risk items, or priority values merely to fill
the index.

## Resource Templates and Identifiers

Use the matching template in `docs-harness/templates/` before creating a new
resource:

- `activity-diagram.md` for onboarding Mermaid flow and activity diagrams.
- `harness-improvement.md` for Harness improvements.
- `constraint.md` for constraints on files or folders.
- `domain.md` for confirmed or uncertain project domain knowledge.
- `risk.md` for security, performance, or memory-leak risks.
- `proposal.md` for proposals.
- `plan.md` for plans in `plans/active/` or `plans/completed/`.

Templates are system artifacts. They use placeholders, do not receive a real
resource ID, and keep their stable filenames. A resource created from a
template must have this common metadata:

```text
ID: #<next-sequence>_<PRIMARY_CLASSIFICATION>_<MMDD>
TAG: [<classification>]
PRIORITY: [<CRITIAL|MEDIUM|NORMAL>]
TITLE: <title>
CREATED: <YYYY-MM-DD>
STATUS: <status>
REFERENCES:
```

### Resource ID and Filename Rules

When creating a resource:

1. Scan all of `docs-harness/` for existing resource IDs.
2. Use one global three-digit sequence and assign `max(existing ID) + 1`.
3. Choose the primary classification from the resource's canonical folder and
   content. Use `DOMAIN_CONFIRMED` or `DOMAIN_UNCERTAIN` for domain resources;
   do not invent new classification tags for supporting `plans/` or
   `proposals/` resources.
4. Use the creation date in `Asia/Bangkok` as zero-padded `MMDD`. Keep that date
   and the ID immutable after creation.
5. Name the resource
   `<MMDD>-<lowercase-kebab-case-meaning>.md` without the ID in the filename.
6. Add all applicable `TAG:` lines and exactly one `PRIORITY:` line.
7. Add the canonical relative link and ID to every applicable classification
   section in `docs-harness/INDEX.md` without duplicating the resource file.

Never overwrite an existing resource. If an ID or filename collides, scan
again, use the next unused global sequence where possible, and pause when the
collision is ambiguous or a duplicate ID is found. Do not reuse an old ID.

SQLite intake, story, trace, scoring, audit, and proposal commands are optional
compatibility features. Use them only when explicitly requested or required by
an external orchestrator.
<!-- HARNESS:END -->
