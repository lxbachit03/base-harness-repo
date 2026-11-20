# prd-research in a sub-session

Applies when the User asks for the `prd-research` skill. A session that this rule
started runs the skill itself and starts no other session.

1. Run the skill in a new session, not here. Start it with the host's session tool
   (`mcp__ccd_session__start_session` in the Claude desktop app):
   - `model`: `claude-opus-5-5`, `effort`: `high`.
   - `context`: `fresh`; a fork ignores model and effort.
   - `use_worktree`: `false`, so the reports land in this checkout.
   - `wake_when_done`: `true`.
   The host may ask the User first; follow its flow.
2. The new session has not seen this conversation. Write the brief from what this
   session knows: the PRD/FRD path, the ticket path, the User's request in their own
   words and language, the decisions and limits so far, where the reports go, and that
   the skill's own completion rules apply.
3. The host ignores a `model` above this session's own, and an `effort` above it. When
   the new session cannot get Opus 5.5 at high effort, say so and ask the User whether to
   run the skill here; never run it on another model without that answer.
4. When the new session reports, check the reports it names before telling the User the
   research is done, and pass on its open questions.
