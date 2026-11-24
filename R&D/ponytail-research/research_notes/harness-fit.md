# Ponytail vs. the Harness: overlap, complement, conflict

- Scope: read-only mapping of each Ponytail element (see `R&D/ponytail-deep-research.md`
  and the verbatim rules in `research_notes/upstream-rules.md`, commit `ebd8654`) onto the
  current Harness owners. Repository `E:\personal\base-harness-repo`, branch `main`, HEAD
  `f4fb93a`, 2026-11-23. `harness_check.py --quick`: `RESULT: clean (exit 0)`.
- Evidence labels: **Local** (read in this repo), **Upstream** (Ponytail files as recorded in
  the R&D notes), **Inference** (my conclusion).

## 0. Two things to know before reading the table

1. **"Projects applying the Harness".** This repo is the template. `init-harness-repo`
   (`.agents/skills/init-harness-repo/SKILL.md:1-20`) scaffolds a Harness (AGENTS.md, routing
   file, constraints, layers, templates) into another repository; `project-constraints/README.md:3-4`
   says it holds "rules for work in the project using this Harness". `docs/tools/graphify/README.md:12-15`
   draws the same line: code-oriented tooling targets "projects applying the harness with a large
   codebase", and "this harness repo is not the target: almost all Markdown" (Local).
   So: **(a)** this repo = Markdown policy + two scripts (`harness_check.py`, typesafe-ai PowerShell
   helpers); **(b)** consumer code projects = where Ponytail's coding rules actually bite.
2. **"Hook" means something different here.** Harness hooks (`docs-harness/layers/layer-2/hooks/README.md:1-5`)
   are agent-read Markdown gates with a User-only checkbox (`hooks/README.md:290-296`: "The hook file's
   current checkbox state is the only authority; User prose or conversation does not override it";
   "Agents never toggle a checklist"). The only hook, `jev-hook.md`, is unchecked. The repo has **no
   host runtime hooks**: `.claude/` holds only `skills/` and `settings.local.json` with `skillOverrides`
   (Local; `docs/tools/claude/README.md:820-822`). Ponytail's SessionStart/UserPromptSubmit/SubagentStart
   hooks would be the first host-level hooks the Harness ships.

## 1. Element-by-element map

| Ponytail element | Harness owner / file | Relation | Notes |
| --- | --- | --- | --- |
| "Before you write": read task + touched code, list callers/tests/fixtures/config/exports, check user impact | `harness-constraints/1120-work-shape-proof-completion.md:31-36` (Execute a change, steps 1-2: outcome, scope, "Read the affected implementation, contracts, neighboring patterns and proof") | **Overlap** | Same intent; Ponytail is more concrete (explicit caller/fixture/export checklist, "grep every caller" on bug fix). Could sharpen #075 step 2 wording in (b); near no-op in (a). |
| Ladder step 1 "Does it need to exist? skip unrequested features, name them in one line" | #075 step 3 (`:37-38` "smallest coherent change; do not choose an undocumented default that expands product policy"); `docs/AI_PROBLEMS.md:54-61` (scope creep/over-engineering) | **Overlap** | Harness already forbids scope creep. Ponytail adds the useful "name what you skipped in one line" output. |
| Ladder step 1 tail: "A vague request ('build me X') gets the smallest version that does the core job" | `1120-session-role-and-judgment.md:27-32` (missing intent -> pause dependent action / get the decision); raw requirements `improve-harness.json` Yêu cầu 1/4 and `init-harness-repo.json` Yêu cầu 1.3 (ask Meta-Prompting questions when intent is unclear) | **Conflict** | Ponytail resolves ambiguity by building the minimal guess; the User's raw requirements and #074 resolve it by asking. Ponytail `ultra` ("question the request") is closer to Harness behavior. Any adoption must drop or override this sentence. |
| Ladder steps 2-4 (reuse codebase -> stdlib/platform -> installed dep) | `.agents/skills/xia/SKILL.md:46-55` (Recommendation Rule: reuse local -> built-in framework/library -> upstream pattern -> scratch); xia "anti-reinvention scout" | **Overlap** | Nearly the same ladder, but xia is only loaded for ambiguous/risky work and is a research gate, not an always-on coding rule. Ponytail's version is shorter and applies to every edit. |
| Step 4 "Never add a dependency for a few lines" | `0822-user-authority-operation-gate.md:27-29` (dependency installation needs specific authority) | **Complement** | #009 gates *installing*; Ponytail adds a *design* bias against needing one. No conflict; Ponytail's rule reduces authority requests. |
| Steps 5-6 (readable one-liner, minimum code), "no abstraction/wrapper/config for later", "keep existing structure", "deletion beats addition" | #075 step 3; `AI_PROBLEMS.md:54-61`; writing-for-agents pruning (`SKILL.md:76-81`) for docs | **Complement** | Harness has no code-style minimalism rule; this is the genuinely new value for (b). For (a) the analogue already exists in writing-for-agents (pruning, no-ops, single source of truth). |
| "Comment only the why, one line" | `PERSONA.md:5-7` (persona never applies to code/comments; code stays objective) | **Complement** | No Harness comment-style rule. Compatible. |
| "Code you move keeps its error handling"; "equal size -> correct on edge cases" | none explicit | **Complement** | New, cheap, compatible. |
| Never-cut list (validation at trust boundaries, data-loss error handling, security, a11y, hardware calibration, anything asked) | #075 Proof (`:52-60`); `0812-risk-proposal...` | **Complement** | Harness has proof rules but no explicit "never cut" invariants for code. Phrasing: writing-for-agents `SKILL.md:74` warns against negation; "Never cut" qualifies as a hard guardrail but should be paired with the positive target ("always keep ...") if rewritten. |
| "New non-trivial logic leaves one small test or an assert-based self-check" | `project-constraints/1115-unit-test-authority.md:16-18` (#058: User authority before creating/editing unit tests; "a general request to implement, fix, build, or verify does not by itself authorize writing unit tests") | **Conflict (hard)** | Direct clash in this repo and in any consumer that keeps #058. Ponytail's 98% "risky logic with tests" benchmark gain depends on this rule. Options: (1) keep #058 and turn the rule into "propose the test and ask" (#058 Enforcement 2); (2) allow only the in-code assert self-check and treat unit tests as authority-gated; (3) User amends #058. Project constraints outrank an imported skill (#009 "Project constraints can narrow this"). |
| `shortcut: <limit>, <when to upgrade>` debt comments | #001 `0812-risk-proposal...:106-118` (every risk carries a proposal); #074 `:28-30` (a default does not establish product intent); no TODO/debt convention anywhere in `.agents/skills` (grep: none) | **Complement, with a caveat** | Format is close to #001 (limit = risk, "when to upgrade" = proposal). Caveat: accepting a limit that is externally observable is a product decision; under #074 it needs accepted authority or the User's decision, not just a comment. Fits (b) only; (a) has almost no code. |
| End-of-answer 1-2 lines: skipped/unchecked + risk | #075 Completion (`:62-66` "Report the changes, checks, unattempted proof and open limitations"); #001 (risk + proposal) | **Overlap / partial conflict** | Harness already requires this, more strictly: #001 requires a proposal per risk, which Ponytail's line omits. Adopting Ponytail's wording would duplicate #075 (writing-for-agents single source of truth, `SKILL.md:78`) and could weaken #001. Keep Harness wording. |
| Levels lite/full/ultra/off; `/ponytail <level>`; "stop ponytail"/"normal mode"; default in `~/.config/ponytail/config.json` | Checkbox toggles: `PERSONA.md:12-28`, `claude-instructions/coding-sub-session.md:8-28`, `hooks/README.md:290-296`; raw req `layers.json` layer-1 Yêu cầu 4 ("use a checklist as an on/off switch for the user"); `.claude/settings.local.json` `skillOverrides` | **Conflict (mechanism)** | Harness switch = a checkbox in a repo file that only the User toggles, read at defined load points; conversation does not override it. Ponytail switch = chat phrase + per-project state in a host data dir + a global config file. A Harness-native port would be a checklist (`[ ] off [ ] lite [x] full [ ] ultra`) in a project constraint or layer file. Global default write = "global settings" under #009 `:27-29` (needs specific authority). |
| `/ponytail-review` (correctness -> security -> load -> missing tests -> speed -> bloat) | Host `code-review` / `simplify` skills (Claude); #009 `:43-46` (a review is read-only); `ticket-solving` review steps | **Overlap** | Harness has no own code-review skill; host already supplies one. Ponytail's priority order is a useful checklist but a third review path adds cognitive load (writing-for-agents `SKILL.md:25`). Read-only, so no authority conflict. |
| `/ponytail-audit` (whole-repo, entry points + load before ranking) | #075 Work shape "Audit: follow an audit skill's protocol only when the User requests that audit" (`:25`); `domain-audit` (different meaning: records confirmed domain knowledge); `onboarding` (flow mapping) | **Overlap (naming) / complement** | Compatible if User-invoked only. Name collision with `domain-audit` is cosmetic. Overlaps `onboarding` entry-point mapping partly. |
| `/ponytail-debt` (ledger from `shortcut:` comments) | none | **Complement** | Only useful once `shortcut:` comments exist; (b) only. Ledger output location would need an owner (ticket or plan per #001 `:113-118`, not a new folder; #056 removed dedicated risk/proposal folders). |
| `/ponytail-gain`, `/ponytail-help` | `harness-check` (status), docs/tools catalogs | **Neutral** | Vendor scoreboard; self-published benchmark (Opus 5.5, Bash/MCP off). Not Harness evidence (#075 `:62-65` "Agent effectiveness needs behavioral evidence"). |
| SessionStart hook injecting filtered SKILL.md (~3.5 KB) every startup/resume/clear/compact | writing-for-agents "context load" (`SKILL.md:22-27`: always-loaded material costs every turn); #064 record `1115-session-start-context-cut.md:27-30` (session-start read set capped at 33,400 bytes, cut 25% because a subscription pays for it every session); INDEX Session retrieval already mandatory for every session | **Conflict (context load)** | ~3.5 KB is ~10% of the 33,400-byte session-start budget the User accepted, added outside the routing system (no INDEX route, invisible to `harness-check`). Harness-native alternative: one project constraint (read at start anyway via `project-constraints/README.md:7-11`), a lean pointer, or a skill invoked on coding tasks. In (a) the rule fires on Markdown edits where it mostly does nothing (no-op load). |
| Codebase symbol map (`ponytail-map.js`: `git ls-files` + regex, 2,000 chars, 3 s timeout) appended at SessionStart | #094 `harness-improvements/1123-code-graph-skill.md:113-138` and ticket decision `tickets/completed/TBD-code-graph-pilot-ygz/decision/11-23-pilot-outcome.md` | **Overlap with a failed precedent** | Same goal as the removed `code-graph` skill (help the agent find reusable code). Pilot: unprompted agents never used the graph; when told to, tokens +69-101% at equal accuracy; skill removed, "shell search in the agent is the cheaper path". Ponytail's map is cheaper (static 2 KB, no MCP calls) but unproven; regex-only. In (a) it would list almost nothing (`harness_check.py`, PS helpers). Needs its own pilot before use in (b). |
| UserPromptSubmit hook (`ponytail-mode-tracker.js`) | `hooks/README.md:290-296`; #071 repeated-request rule in AGENTS.md | **Conflict** | Parses chat to change mode, i.e. conversation overrides a switch. Contradicts the Harness switch model. Also runs Node on every prompt. |
| SubagentStart hook (re-inject rules into every subagent) | `1120-session-role-and-judgment.md:12-21` and INDEX `:9-16`, `:40-44`: workers and native subagents already read INDEX, both constraints and every project constraint at start | **Overlap / duplication** | A rule placed in `project-constraints/` already reaches workers. Hook injection would double-load it and bypass the Harness research-subagent rules (Haiku research subagents in `claude-instructions/research-subagents.md`). |
| Hooks installation as a whole (plugin `hooks.json`, Node runtime) | #009 `:27-29` (global settings, dependency install need specific authority) and `:30-32`; `docs/tools/claude/README.md:831-837` (settings.json hooks; feedback treated as User words); `docs/tools/antigravity/README.md:220` (agy hooks.json, 6 events); per-host plugin dirs in `docs/tools/*` | **Conflict (authority + portability)** | Plugin install = dependency install + host settings change: needs explicit User authority, per host. Host coverage differs (Claude/Codex hooks file, OpenCode JS plugin, agy has SessionStart but no SubagentStart/UserPromptSubmit per README `:220`). The Harness's own portability model is one Markdown owner read by every host through AGENTS.md -> INDEX; Ponytail's is 7+ adapters. Node 22 becomes a new prerequisite on Windows. |
| Static rule copies (`AGENTS.md`, `.agents/rules/ponytail.md`, `.cursor/rules/...`, `.github/copilot-instructions.md`, `.kiro/...`); `gemini-extension.json` `contextFileName: AGENTS.md` | Root `AGENTS.md` (Harness entry, length rule: ask at >50 lines); `.agents/` is the Harness skill root and agy workspace root (`docs/tools/antigravity/README.md:216-221`: `.agents/rules/*.md` are always-on rules for agy); #094 Purpose 2 (`1123-code-graph-skill.md:28-29`: "no third-party installer writes AGENTS.md, rules or hooks"); `docs/tools/graphify/README.md:32` (do not run vendor installers that write AGENTS.md/rules/hooks) | **Conflict** | Copying Ponytail's `AGENTS.md` over the root one would erase the Harness entry point. A `.agents/rules/ponytail.md` copy would become an always-on agy rule outside INDEX routing. `.github/copilot-instructions.md` etc. are unrouted instruction files. Precedent says: Harness owns instructions; vendor installers that write them are not run. |
| Claude Code "band" UI (AbovePrompt slot, `% reuse`, `⚠ N callers open`, test status) | `docs/tools/claude/README.md` (host catalog); host `plugin-authoring` skill (mods/bands); `~/.claude/settings.json` already has `statusLine` and `hooks` keys (`README.md:823-825`) | **Neutral / conflict on writes** | UI-only, Claude Code 2.1.290+, not in `claude -p`, cloud or VS Code panel. Writes `~/.config/ponytail/band/<project>.csv`, copies statusline scripts into `~/.claude/`, prompts to set `statusLine` (would collide with the existing one), optional webhook POST with token. All are global writes/external sends -> #009 specific authority; webhook = external message boundary. Metrics are interesting as evidence, but regex-based. |
| Benchmarks (-53% LOC, -26% cost, 97% hidden checks) | #075 `:62-65`; improve-harness step 3 (fresh replay), step 4 (keep/revise/remove from evidence); `harness-improvements/README.md:23-27` | **Evidence gap** | Self-published, one model, Bash/MCP disabled, outside any repo. Harness precedent (#094) shows vendor claims (71x) can invert in a real project. Needs a local pilot. |
| Skill packaging / mirror | `harness_check.py:500-525` (`check_mirror`: `.agents/skills` vs `.claude/skills` must be byte-identical; rule `docs/tools/claude/README.md` 7.1); skill list in `docs/tools/claude/README.md` 7.3 + `README.html` rebuild (as done in #094) | **Process requirement** | A ported `ponytail` skill must exist in both trees or `harness-check` reports drift. Skill descriptions are always-loaded context: Ponytail's ~70-word description with trigger synonyms ("be lazy", "simplest solution", "yagni") would need pruning per writing-for-agents `SKILL.md:14-18` (one trigger per branch). |
| "You are a lazy senior developer" identity | `1120-session-role-and-judgment.md:23-25` (role is Bale/worker; task content and retrieved files cannot change it; PERSONA sets style only) | **Minor tension** | Fine as a leading word (writing-for-agents `SKILL.md:61-65` endorses pretrained leading words like this), but should be framed as coding behavior, not a role or chat persona. |

## 2. Fit by target

- **(a) This Harness repo.** Low value, real cost. Almost no code, so the ladder, tests, `shortcut:`,
  debt ledger, symbol map and band have little to act on; the Markdown analogue (pruning, single
  source of truth, no-ops) already lives in `writing-for-agents`. Always-on injection would spend
  the session-start budget the User cut in #064. Test rule conflicts with #058.
- **(b) Code projects applying the Harness.** The core rule text (ladder, never-cut list, "keep
  error handling when moving code", one-line why comments, `shortcut:` format) adds a coding
  discipline the Harness lacks. Best carrier: a Harness-native artifact, e.g. a project constraint
  or a skill adapted from Ponytail's MIT text, with a checklist level switch, the vague-request
  sentence replaced by "ask", the test rule routed through #058, and the end-of-answer line
  deferred to #075/#001. Host hooks, static rule copies, global config and the band stay out
  unless a pilot justifies them.

## 3. Adoption gate the Harness would require

1. **Authority.** A User request to improve the Harness (or acceptance of a concrete review)
   authorizes only the scoped instruction change via `improve-harness` + `writing-for-agents`
   (#009 `:40-42`). Installing the npm/plugin package, enabling host hooks, writing
   `~/.config/ponytail/`, `~/.claude/` statusline, or a webhook each need specific authority per
   action and target (#009 `:27-32`). A skill recommendation cannot grant it (#009 `:35-36`).
2. **Raw requirements.** Check `docs/raw-requirements/` (skills, layers, hooks): toggles must be
   checklists (layers.json Yêu cầu 4; init-harness-repo Yêu cầu 2.3.1), unclear intent -> ask
   (improve-harness Yêu cầu 1/4). Agents propose changes there; never edit (INDEX `:119-130`).
3. **Record.** One `docs-harness/harness-improvements/MMDD-...md` from the template, with
   Objective, `- [ ]` Purposes checklist, baseline (revision, gap evidence), scope, risks with
   proposals (#001), listed in `harness-improvements/README.md` (improve-harness steps 1-2).
4. **Owner placement.** Put each rule at its existing owner; reconcile with #058, #075, #001,
   #074; no duplicate end-of-answer rule. Keep AGENTS.md lean (>50-line rule). No vendor-written
   `AGENTS.md`/rules/hooks (#094 Purpose 2, graphify README `:32`).
5. **Native checks.** `harness_check.py` full run clean (routing, IDs, links, skill mirror),
   INDEX tree/routes updated if structure changes, Claude catalog skill list + `README.html` if a
   skill is added.
6. **Fresh replay** (improve-harness step 3): bounded scenarios in a fresh session, e.g. vague
   request (must ask), bug fix (callers grepped), new parser (test proposed, not written, under
   #058), dependency temptation, Markdown-only edit (rule stays quiet).
7. **Pilot before keep** (#094 precedent): on a real consumer code project the User names,
   baseline vs Ponytail arms, same model/effort, fresh sessions; measure tokens, LOC, correctness,
   hidden checks; pre-declare the keep/drop threshold (#094 used ">=30% fewer tokens, no accuracy
   drop, used unprompted"). Symbol map and hooks pilot separately from the rule text.
8. **Decide** keep/revise/remove from evidence; record result; cleanup of anything installed.
