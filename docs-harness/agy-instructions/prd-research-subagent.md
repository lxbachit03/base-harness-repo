# prd-research in a subagent

Applies when the User asks for the `prd-research` skill. A subagent started by this rule
runs the skill itself and starts no other subagent.

## Model (select exactly one by marking `[x]`)

If none or several are marked, use `pro`. `invoke_subagent` selects by model tier only
(no exact model ID or `effort` argument).

- [ ] `flash_lite` (lightest, fastest Gemini tier)
- [ ] `flash` (fast Gemini tier)
- [x] `pro` (larger Gemini tier for deep PRD analysis)
- [ ] `inherit` (parent session's exact model and effort, fresh context)

## Steps

1. Ask the User before launching, in one question (or `ask_question`) that names the
   `self` subagent, offers the model tiers with the marked one first, and summarizes the
   brief. Launch only after confirmation. If the User declines, ask whether to run
   `prd-research` in this session.
2. Launch the skill in a fresh subagent with `invoke_subagent`:
   - `TypeName`: `"self"`.
   - `Model`: the chosen tier (`flash_lite`, `flash`, `pro`, or `inherit`).
   - `Workspace`: `"inherit"`, so reports land in the current checkout.
   Fresh context and completion notification to the parent are built in.
3. Write a self-contained `Prompt` (the subagent sees none of this conversation): the
   PRD/FRD path, ticket path, User request in their own words and language, decisions and
   limits so far, target report paths, and that `prd-research` completion rules and
   `docs-harness/INDEX.md` session retrieval apply.
4. When the host rejects the chosen tier, report it and ask whether to run here or pick
   another tier; launch on a different tier only after the User agrees.
5. When the subagent reports back, inspect the generated report files before telling the
   User the research is complete, and pass on its open questions.
