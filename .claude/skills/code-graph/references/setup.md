# Set up a code graph in a project

Commands come from Graphify `0.9.115` documentation and were not yet run in a project
(see the pilot). The installed binary is the authority for syntax: print
`graphify --help`, `graphify extract --help` and `graphify-mcp --help` before each step
that uses them, and follow what they print. Host catalogs mentioned below live under
`docs/tools/` in the Harness repository this project's harness came from; without access
to it, the binaries' `--help` and each host's own documentation are enough.

## 1. Confirm the preconditions

- The codebase is large enough to gain: a reviewer found little benefit under about 100
  code files. Count them.
- Python 3.11.5 to 3.14 and `uv` are available (read-only checks).
- The User named the project's hosts (Claude Code, Codex, OpenCode, Antigravity).
- Ask the User in one question: authorize installing the pinned backend now and set up
  directly, or run the pilot first (which also installs it, in a throwaway worktree). Say
  that the benefit is unmeasured until a pilot runs.

Done when the checks are recorded and the User chose set up or pilot; on pilot, switch to
[pilot.md](pilot.md).

## 2. Install the pinned backend

```text
uv tool install "graphifyy[mcp]==<version>"
graphify --version
```

Pin the latest release at set-up time, never older than `0.9.115` (it fixes a Windows
credential leak), and record the exact version. `uv tool install` installs for the whole
user account; say so when asking for the install authority.
The package name is `graphifyy` with two `y`; other `graphify*` packages are unrelated.

Done when `graphify --version` prints the pinned version.

## 3. Exclude what is not source

Create `.graphifyignore` at the project root with the project's vendored code, build
output, generated code, dependency folders and any secret files. Add `graphify-out/` to
`.gitignore`. Set `GRAPHIFY_QUERY_LOG_DISABLE=1` in each MCP server entry's environment
(step 5) and in the shell that runs the CLI.

Done when `git check-ignore graphify-out/x` matches and `.graphifyignore` lists every
generated or vendored folder you found at the root.

## 4. Build the graph

```text
graphify extract . --code-only
git rev-parse HEAD > graphify-out/BUILT_FROM
```

After a backend upgrade that changes the cache schema, add `--force`. Record the build
time and the node and edge counts it prints.

Done when `graphify-out/graph.json` and `graphify-out/BUILT_FROM` exist.

## 5. Register the local MCP server

Name the server `code-graph` on every host and start `graphify-mcp` with the graph path
argument that `graphify-mcp --help` documents. Project-scoped files:

| Host | File | Shape |
| :--- | :--- | :--- |
| Claude Code | `.mcp.json` | `{"mcpServers": {"code-graph": {"command": "graphify-mcp", "args": [...]}}}` |
| OpenCode | `opencode.json` | `{"mcp": {"code-graph": {"type": "local", "command": ["graphify-mcp", ...], "enabled": true}}}` |
| Antigravity | `.agents/mcp_config.json` | stdio server with `command`, `args` |
| Codex | `.codex/config.toml` | `[mcp_servers.code-graph]` with `command`, `args` (shape unverified in this Harness) |

Check each host's catalog before editing its file, and merge into an existing file instead
of replacing it. Prefer the project-scoped file; editing a user-global file such as
`~/.codex/config.toml` is outside the project and needs the User's yes for that file.

Done when each host lists `code-graph` among its MCP servers (`claude mcp list`,
`/mcp`, or the host's equivalent).

## 6. Keep it fresh

Rebuild with the two commands of step 4, through the project's own git hook manager or CI
file. Ask the User in one question which trigger to use (after each pull or merge, or in
CI as an artifact) and whether agents may also rebuild a stale graph themselves.

Done when both answers are recorded for the project constraint of step 7.

## 7. Add the project constraint

Create one constraint in the project's harness `project-constraints/` folder from its
constraint template, with this rule text:

> This project has a local code-only code graph in `graphify-out/` (Graphify
> `<version>`). For questions that cross files, use the `code-graph` skill before reading
> many files, and read every file it names before claiming or editing. The graph is
> rebuilt by `<trigger from step 6>`; agents `<may | may not>` rebuild it with
> `graphify extract . --code-only` when it is stale. Never run `graphify install`,
> `graphify hook install` or a hosted MCP endpoint here.

Fill the trigger and `may` or `may not` from the step 6 answers.

Route it as the project's harness requires.

Done when the constraint exists and its routing check passes.

## 8. Verify

Ask one cross-file question twice: through `graphify query` and through the `code-graph`
MCP server in each host. Open the files named and confirm they answer the question.

Done when each host returned a graph answer whose files you confirmed, or the failure is
reported with its output.
