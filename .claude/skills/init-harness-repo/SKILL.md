---
name: init-harness-repo
description: Scaffold a minimal Harness (AGENTS.md, routing file, improvements, layers, constraints, templates) in the current repository after a short User interview.
disable-model-invocation: true
---

# Init Harness Repo

Initialize a **harness repo**: the folder the User names in step 2, plus a root
`AGENTS.md` that routes every session into it. Every scaffolded Harness keeps
two mindsets, written into its `AGENTS.md`:

- **Top-Down** (default): read the routing file first and load a routed
  resource only when the User's intent needs it, to save tokens.
- **Bottom-Up** (agent's judgment): search files directly when Top-Down
  routing cannot answer, trading tokens for retrieval quality.

Run this skill with the same mindsets: inspect only what each step needs.
The generated file contents live in [scaffold.md](scaffold.md); read it at
step 3.

**Asking the User.** Every question in this skill is asked one at a time
(Meta-Prompting), through the host's structured question tool when it has
one. Put the recommended option first, give each option a one-line
explanation, and always include a free-text answer. Offer other options only
when the repository gives a concrete reason for them.

## 1. Inspect the target

Work at the repository root (the current working directory unless the User
named another). List the root.

If root `AGENTS.md` or `CLAUDE.md` exists, list which ones and ask now,
before the interview:

- **Keep them** (recommended): create the rest of the scaffold and, in the
  report, hand the User the generated text of each kept file to merge by
  hand.
- **Cancel**: create nothing; go to step 5.

Done when you know whether root `AGENTS.md` and `CLAUDE.md` exist and, if
either does, the User has chosen.

## 2. Interview the User

1. **Harness folder**: recommended `docs-harness`. From now on, "harness
   repo" means this folder.
2. **Orchestrator name**: recommended `BALE`. The User calls this name when
   the current main agent should coordinate another main agent.
3. **Harness goal**: there is no recommended option. Offer two or three
   concrete goals inferred from the repository (README, manifests, top-level
   folders), unranked, plus the free-text answer. The goal tells future
   agents what context the User wants results in.
4. **Routing filename**: recommended `INDEX.md`, the Top-Down entry file
   inside the harness folder.

Check for conflicts right after the answer that creates them: after
question 1, whether the harness folder exists; after question 4, whether any
scaffold path inside it exists. On a conflict, list the existing paths and
ask:

- **Pick another name** (recommended): ask that question again.
- **Skip existing paths**: create only the missing files.
- **Cancel**: create nothing; go to step 5.

If an answer is ambiguous, ask a follow-up before moving on.

Done when all four answers are recorded and every conflict has a User
decision. Existing files stay byte-identical whatever the User chooses.

## 3. Scaffold

Read [scaffold.md](scaffold.md). Create each file it lists, substituting the
four answers for its placeholders. Create only the listed paths, skipping
any the User chose to keep.

Done when every listed path the User did not skip exists with its
placeholders filled (search the new files for `{{`; zero matches).

## 4. Verify the routes

Check every Markdown link (`[text](target)`) in the files you created,
resolving each target from the directory of the file that contains it:

- every link target exists;
- the routing file links to `AGENTS.md` and to each folder README;
- `AGENTS.md` links to the routing file, and `CLAUDE.md` contains the line
  `@AGENTS.md` (skip the check for a file the User kept);
- every folder README links back to the routing file;
- `layers/README.md` and `harness-constraints/README.md` state the toggle
  rule.

Fix a broken link in a file you created, then check again. Also run
`git check-ignore` on each created path and note any path git ignores.

Done when every link resolves, every back-link above is present, and the
ignore check has run.

## 5. Report

Tell the User:

- the four answers (or the ones collected before a cancel);
- each created path and each skipped path, with the reason;
- the link-check evidence (links checked, zero missing) and any git-ignored
  paths with the ignore rule that matched;
- for each existing `AGENTS.md` or `CLAUDE.md` the User kept: its generated
  text to merge by hand, and a warning that until it is merged, sessions are
  not routed into the harness repo.

After a successful scaffold, add the next steps: layer instructions under
`layers/layer-1/` and constraints under `harness-constraints/`, each with its
toggle line, and templates under `templates/` as needed.
