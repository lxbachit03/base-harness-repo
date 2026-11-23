# Graphify (Graphify-Labs/graphify): product purpose, architecture, features, installation and usage

Snapshot: default branch `v8`, HEAD commit `a3db62f` (2026-11-23T00:39Z); latest release `v0.9.115` (2026-11-21). Evidence comes mainly from a shallow clone of the repository and the GitHub and PyPI JSON APIs, read on 2026-11-23. Short link names: README = [README.md](https://github.com/Graphify-Labs/graphify/blob/v8/README.md), ARCH = [ARCHITECTURE.md](https://github.com/Graphify-Labs/graphify/blob/v8/ARCHITECTURE.md), PYPROJECT = [pyproject.toml](https://github.com/Graphify-Labs/graphify/blob/v8/pyproject.toml), HOW = [docs/how-it-works.md](https://github.com/Graphify-Labs/graphify/blob/v8/docs/how-it-works.md), BENCH = [BENCHMARKS.md](https://github.com/Graphify-Labs/graphify/blob/v8/BENCHMARKS.md), CHANGELOG = [CHANGELOG.md](https://github.com/Graphify-Labs/graphify/blob/v8/CHANGELOG.md).

## Q1. What problem does Graphify solve, who is it for, and what does it produce?

### Takeaway
Graphify is a Python CLI that also installs as a skill in AI coding assistants (`/graphify`). It turns a codebase and the material around it (docs, SQL schemas, configs, PDFs, images, audio and video) into a persisted, queryable knowledge graph, so coding agents and people can "query instead of grepping". Each run writes three files: an interactive `graph.html`, a `GRAPH_REPORT.md` summary and a `graph.json` (NetworkX node-link format). The project is open source under Apache-2.0 and is backed by a YC S26 company, which sells a hosted "Graphify Cloud" tier on top of it.

### Cited Findings
- The GitHub repo description reads: "Turn any codebase, with its docs, SQL schemas, configs, and PDFs, into a queryable knowledge graph. A /graphify skill for Claude Code, Cursor, Codex, and Gemini CLI: local deterministic AST parsing, every edge explained, no vector store." Homepage: graphify.com. — [GitHub API repo metadata](https://api.github.com/repos/Graphify-Labs/graphify)
- The tagline is "Shared codebase context for agents and humans", and the stated goal is to "trace dependencies, understand how components connect, and give your coding agent reusable context across sessions." — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- Output is `graphify-out/` with `graph.html` (open in a browser to click, filter and search), `GRAPH_REPORT.md` (key concepts, surprising connections, suggested questions) and `graph.json` (the full graph, queryable without re-reading files). The JSON carries `graph.schema_version` and `graph.graphify_version`. — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- Out-of-the-box analyses: "god nodes" (most-connected hubs), Leiden "communities" (subsystems) with LLM-free labels, cross-file `calls`/`imports`/`inherits`/`mixes_in` edges across about 40 languages, query/path/explain commands, and rationale comments (`# NOTE:`/`# WHY:`) plus ADR/RFC citations as first-class nodes. — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- Documented use cases: joining an unfamiliar project, changing a shared component (trace callers), investigating a bug (path from endpoint to storage), and revisiting earlier design decisions. — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- Additional outputs: a Markdown wiki (`--wiki`; one article per community plus `index.md`), an Obsidian vault, SVG, GraphML, JSON Canvas, Cypher, and a Mermaid call-flow HTML (`graphify export callflow-html`). — [ARCH](https://github.com/Graphify-Labs/graphify/blob/v8/ARCHITECTURE.md); [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- Commercial layer: Graphify Cloud (app.graphify.com) is described as "the always-on layer built on top of graphify". It adds monorepo and cross-repo graphs, "formal verification" of architectural invariants, SDLC-wide code review, and Sentry/Jira connectors. The README badge says Y Combinator S26. — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- Licence: Apache-2.0. Portions contributed earlier under MIT "prior to the relicensing" stay available under MIT (LICENSE-MIT is retained). Copyright line: "Safi Shamsi and the Graphify contributors" (public maintainer handle `safishamsi`). — [NOTICE](https://github.com/Graphify-Labs/graphify/blob/v8/NOTICE)
- Popularity and activity on 2026-11-23: 152,110 stars, 14,623 forks, 1,701 open issues. Repo created 2026-04-03. Code is Python (about 12.4 MB), with TypeScript (about 28 KB, the Pi guard) and a Dockerfile. — [GitHub API](https://api.github.com/repos/Graphify-Labs/graphify); [languages API](https://api.github.com/repos/Graphify-Labs/graphify/languages)
- PyPI package `graphifyy` (double y): 283 releases, from 0.1.1 (2026-04-04) to 0.9.115 (2026-11-21). — [PyPI JSON](https://pypi.org/pypi/graphifyy/json)

### Inferences
- The main audience is developers who use agentic coding assistants and want cheaper, more structured repo context than grep or whole-file reads. A secondary audience is teams that share a committed graph and use it for PR review.
- Release cadence is very high: 283 releases in about 7.5 months, and the last five came between 2026-11-15 and 2026-11-21. That points to fast iteration and a moving API surface. AST cache schema numbers (now 51) bump often and force re-extraction after upgrades.
- The open-source CLI works as a funnel for the paid Cloud product. Cloud CTAs appear about six times in the README.

### Gaps
- No independent verification of the star and fork counts or the YC S26 claim beyond the README badge and the API numbers. The very high star count for a 7-month-old repo was not checked against third-party sources.
- docs.graphify.com was not fetched. Notes are based on in-repo files.

## Q2. Architecture: components, languages, dependencies, data flow, storage, and LLM/embedding usage

### Takeaway
Graphify is "a Claude Code skill backed by a Python library". The pipeline runs `detect → extract → build → cluster → analyze → report → export`, and the stages pass plain dicts and NetworkX graphs. Code goes through local, deterministic tree-sitter AST extraction with multi-pass cross-file resolution. Docs, PDFs, images and transcripts go through an LLM "semantic pass", run either by the host assistant's own subagents or by a configured API backend. Storage is a flat `graph.json` file plus a SHA256-keyed cache. There is no database, but Neo4j and FalkorDB push are optional. Query is keyword/IDF scoring followed by BFS/DFS traversal within a token budget. The README says there are no embeddings, but BENCHMARKS mentions a "local embedder" and "hybrid retrieval" (see Gaps).

### Cited Findings
- Pipeline: `detect() → extract() → build() → cluster() → analyze helpers → report.generate() → export.to_*()`. "Each stage lives in its own module and they communicate through plain Python dicts and NetworkX graphs." — [ARCH](https://github.com/Graphify-Labs/graphify/blob/v8/ARCHITECTURE.md)
- Module roles, according to ARCH, which is kept honest by `tests/test_architecture_doc.py` importing every symbol named in it:
  - `detect.py` scans a directory and groups files by category.
  - `extract.py` turns a list of paths into `{nodes, edges}`.
  - `build.py` builds an `nx.Graph`.
  - `cluster.py` returns `{community_id: [node_ids]}`.
  - `analyze.py` covers god_nodes, surprising_connections, suggest_questions, find_import_cycles and graph_diff.
  - `report.py` writes GRAPH_REPORT.md.
  - `export.py` has to_json/html/obsidian/svg/graphml/canvas/cypher.
  - `wiki.py`, `callflow_html.py`, `ingest.py` (URL to corpus), `cache.py`, `security.py`, `validate.py`.
  - `serve.py` is the MCP stdio/HTTP server.
  - `watch.py` and `benchmark.py`.
  — [ARCH](https://github.com/Graphify-Labs/graphify/blob/v8/ARCHITECTURE.md)
- Three passes:
  - Pass 1, code structure: tree-sitter, "free, no API calls". About 40 languages, 33 through tree-sitter grammars and 7 through built-in parsers (Dart, Apex, COBOL, Razor, Blade, Pascal, Robot Framework). SQL tables, views, FKs and JOINs are extracted deterministically.
  - Pass 2, video/audio: local faster-whisper transcription, with the prompt seeded by top god nodes.
  - Pass 3, docs, papers, images: "LLM subagents, costs tokens", run in parallel. Each emits a JSON fragment of nodes, edges and hyperedges, and the fragments are merged.
  - "Code files are not sent to the LLM semantic extractor"; a code-only corpus skips Pass 3.
  — [HOW](https://github.com/Graphify-Labs/graphify/blob/v8/docs/how-it-works.md)
- Extractor contract: each extractor returns `nodes` (id, label, source_file, source_location) and `edges` (source, target, relation, confidence ∈ EXTRACTED|INFERRED|AMBIGUOUS). `validate.py` enforces the schema before `build()`. — [ARCH](https://github.com/Graphify-Labs/graphify/blob/v8/ARCHITECTURE.md)
- Confidence model: EXTRACTED edges have confidence 1.0. INFERRED edges use a discrete rubric (0.95/0.85/0.75/0.65/0.55). AMBIGUOUS edges are flagged for human review in the report. Duplicate edges keep the highest-confidence copy and list the others in `also_seen`. Hyperedges (3+ nodes) live in `G.graph["hyperedges"]`. — [HOW](https://github.com/Graphify-Labs/graphify/blob/v8/docs/how-it-works.md)
- Much of the engineering goes into language-specific static resolution: Java, C#, Kotlin, Swift, Go receiver typing, C++ aliases/templates/inheritance, Python import binding and more. The resolver "prefers no edge over a wrong one", so ambiguous targets "stay unlinked". The package has dedicated modules such as `cpp_resolution.py`, `go_dispatch.py`, `kotlin_dispatch.py`, `symbol_resolution.py` and `cross_repo_calls.py`, plus 37 extractor modules under `graphify/extractors/`. — [ARCH](https://github.com/Graphify-Labs/graphify/blob/v8/ARCHITECTURE.md); [graphify/ tree](https://github.com/Graphify-Labs/graphify/tree/v8/graphify)
- Clustering uses Leiden (graspologic on Python < 3.13, graspologic-native on 3.13+) through the `leiden` extra. Without it, "clustering silently uses networkx Louvain". HOW states "No embeddings needed": LLM-extracted `semantically_similar_to` edges shape communities directly. — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md); [HOW](https://github.com/Graphify-Labs/graphify/blob/v8/docs/how-it-works.md)
- Storage: `graph.json` in NetworkX node-link format, written `"directed": false`, with edge direction carried by arc order or `_src`/`_tgt` markers. Loaders must use `paths.load_node_link_graph()`. The cache is a per-file SHA256 cache in `graphify-out/cache/`. A "shrink guard" refuses to overwrite graph.json with a smaller graph. Optional push to Neo4j (`push_to_neo4j`) or FalkorDB. — [ARCH](https://github.com/Graphify-Labs/graphify/blob/v8/ARCHITECTURE.md); [HOW](https://github.com/Graphify-Labs/graphify/blob/v8/docs/how-it-works.md); [graphify/exporters/graphdb.py](https://github.com/Graphify-Labs/graphify/blob/v8/graphify/exporters/graphdb.py); [graphify/skill.md](https://github.com/Graphify-Labs/graphify/blob/v8/graphify/skill.md)
- Query engine (`serve.py`): `_score_query` scores nodes with IDF-weighted term matching over labels, ids and sources, prefiltered by a trigram index. Seeds are then traversed by `_bfs`/`_dfs` up to a depth (default 2 in the CLI, max 6) within a token budget (default 2000). External rankers, for example "embeddings, a learned retriever, grep", may supply explicit seeds instead. — [graphify/serve.py](https://github.com/Graphify-Labs/graphify/blob/v8/graphify/serve.py); [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- Parallelism: AST extraction uses `ProcessPoolExecutor`. Semantic batches go to parallel LLM subagents. — [HOW](https://github.com/Graphify-Labs/graphify/blob/v8/docs/how-it-works.md)
- Core runtime dependencies: networkx>=3.4, numpy, rapidfuzz, pyyaml, tree-sitter>=0.25,<0.26, and about 25 pinned tree-sitter grammar packages (Python, JS, TS, Go, Rust, Java, Groovy, C, C++, Ruby, C#, Kotlin, Scala, PHP, Swift, Lua, Zig, PowerShell, Elixir, ObjC, Julia, Verilog, Fortran, Bash, JSON). — [PYPROJECT](https://github.com/Graphify-Labs/graphify/blob/v8/pyproject.toml)
- LLM backends live in the `llm.py` `BACKENDS` table, as backend: default model, key.
  - claude: `claude-sonnet-4-6`, ANTHROPIC_API_KEY, with ANTHROPIC_BASE_URL/ANTHROPIC_MODEL overridable.
  - kimi: `kimi-k2.6`, MOONSHOT_API_KEY.
  - ollama: `qwen2.5-coder:7b`, local.
  - gemini: `gemini-3-flash-preview`, GEMINI_API_KEY/GOOGLE_API_KEY, through an OpenAI-compatible endpoint.
  - openai: `gpt-4.1-mini`.
  - deepseek: `deepseek-v4-flash`.
  - azure: deployment name, default `gpt-4o`.
  - bedrock: `anthropic.claude-3-5-sonnet-20241022-v2:0`, IAM.
  - claude-cli: uses the `claude` binary and the user's subscription.
  - Custom providers can be added through `~/.graphify/providers.json`. A project-local file is ignored unless `GRAPHIFY_ALLOW_LOCAL_PROVIDERS=1`, because it controls where the corpus and API key are sent.
  — [graphify/llm.py](https://github.com/Graphify-Labs/graphify/blob/v8/graphify/llm.py)
- Backend auto-detection order: Gemini → Kimi → Claude → OpenAI → DeepSeek → Azure → Bedrock → Ollama. `--backend` or `GRAPHIFY_BACKEND` overrides it, and `GRAPHIFY_BACKEND=none` disables all LLM use. `GRAPHIFY_CLAUDE_CLI_MODEL` (default Opus) controls the claude-cli model. — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- Security module: URL validation (http/https only, blocks file:// redirects), size- and time-capped fetch, graph paths confined to `graphify-out/`, label sanitising. v0.9.115 fixed a Windows forced-SMB-auth issue (GHSA-g6c9-j4vm-mwq4) in which corpus `source` lines and UNC paths triggered outbound NTLM. — [ARCH](https://github.com/Graphify-Labs/graphify/blob/v8/ARCHITECTURE.md); [CHANGELOG](https://github.com/Graphify-Labs/graphify/blob/v8/CHANGELOG.md)
- Size: the `graphify/` package has about 106.6K lines of Python. Single files are very large: `extract.py` about 14.2K lines, `cli.py` about 6.3K, `llm.py` about 4.1K, `serve.py` about 3.9K. — Measured with `wc -l` on the clone at [commit a3db62f](https://github.com/Graphify-Labs/graphify/tree/a3db62f680cde2cf516642bbfef1e3ab33fd30d8)

### Inferences
- Code costs nothing to map. Token cost appears only for non-code content, and is paid either by the host agent's model (skill mode) or by an API key (headless `graphify extract`). That split is the core design choice behind the "0 LLM credits" claim.
- The "graph backend" is in-memory NetworkX loaded from JSON. That suits single-repo use, but scaling to very large monorepos is probably what the Cloud tier is meant to address. The HTML view already aggregates above 5,000 nodes.
- The large single modules and frequent cache-schema bumps point to a codebase that grew quickly by accretion, driven by issue fixes.

### Gaps
- **Contradiction on embeddings:** the README ("No embeddings, no vector store") and HOW ("No embeddings needed") conflict with BENCH, which says "graphify's deterministic graph plus hybrid retrieval" and that extraction uses "tree-sitter … and a local embedder". The benchmark harness probably uses a hybrid retrieval setup that the default CLI does not ship. Which embedder is used, and whether it is part of the shipped product, was not resolved. — [BENCH](https://github.com/Graphify-Labs/graphify/blob/v8/BENCHMARKS.md) vs [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- The exact semantic-extraction prompt and chunk sizing were not reviewed in detail (they are in `skill.md` Step 3 and `llm.py`).

## Q3. Features, supported inputs and outputs, integrations, configuration

### Cited Findings
- **Inputs:** about 40 programming languages through AST. Optional extras add SQL, PostgreSQL live introspection (`--postgres DSN`), Terraform/HCL, Pascal/Delphi, OCaml, Common Lisp, Robot Framework, BYOND DM, VB.NET, R, Erlang and Solidity. Non-code inputs: Markdown, PDF (`pdf` extra), `.docx`/`.xlsx` (`office`), Google Workspace shortcuts (opt-in, needs an authenticated `gws` CLI), images, video/audio (`video`: faster-whisper + yt-dlp), and URLs through `graphify add <url>` (arXiv papers, YouTube). Cargo/Maven manifests and SCIP ingest also exist (`manifest_ingest.py`, `scip_ingest.py`). — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md); [PYPROJECT](https://github.com/Graphify-Labs/graphify/blob/v8/pyproject.toml); [HOW](https://github.com/Graphify-Labs/graphify/blob/v8/docs/how-it-works.md); [graphify/ tree](https://github.com/Graphify-Labs/graphify/tree/v8/graphify)
- **Assistant integrations (20+):** Claude Code (the default, auto-detected on Windows), CodeBuddy, Codex (invoked with `$graphify`; needs `multi_agent = true` in `~/.codex/config.toml` for parallel extraction), OpenCode, Kilo Code, GitHub Copilot CLI, VS Code Copilot Chat, Aider, OpenClaw, Factory Droid, Trae/Trae CN, Gemini CLI, Hermes, Kimi Code, Amp, cross-framework Agent Skills (`~/.agents/skills/`), Kiro, Pi (plus a native guard extension), Cursor, Devin CLI, and Google Antigravity. Each has a skill body (`graphify/skill-*.md`) and a `references/` sidecar. — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md); [PYPROJECT package-data](https://github.com/Graphify-Labs/graphify/blob/v8/pyproject.toml)
- **"Always-on" steering:**
  - On hook platforms (Claude Code, Gemini CLI, CodeBuddy), a PreToolUse hook nudges the agent toward graph queries before Grep/Glob/Read or `cat`/`sed -n`-style Bash.
  - Instruction-file platforms use AGENTS.md, `.cursor/rules/` and similar files.
  - `--strict` mode on Claude Code shares one denial per session for Read and Grep on indexed files unless a graph query ran within 30 minutes. Related settings: `GRAPHIFY_HOOK_STRICT` and `GRAPHIFY_HOOK_NUDGE_CAP` (default 5). A SessionStart(compact) hook resets the budgets.
  — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- **MCP server:**
  - The local stdio server is `graphify-mcp` (`mcp` extra). It is an entry point in `[project.scripts]` and can also serve over HTTP.
  - Tools: `query_graph`, `get_node`, `get_section`, `get_neighbors`, `get_community`, `god_nodes`, `graph_stats`, `shortest_path`, plus PR tools `list_prs`, `get_pr_impact`, `triage_prs`.
  - The hosted endpoint for Graphify Cloud is `https://api.graphify.com/mcp`, for example `claude mcp add --transport http graphify https://api.graphify.com/mcp`.
  - A Gemini CLI extension lives in a separate repo.
  — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md); [graphify/serve.py](https://github.com/Graphify-Labs/graphify/blob/v8/graphify/serve.py); [PYPROJECT](https://github.com/Graphify-Labs/graphify/blob/v8/pyproject.toml)
- **CLI subcommands** dispatched in `__main__.py`/`cli.py`: add, affected, benchmark, cache-check, check-update, clone, diagnose, explain, export, extract, global, hook, hook-check, hook-guard, merge-chunks, merge-driver, merge-graphs, merge-semantic, path, provider, prs, query, reflect, save-result, section, tree, update, watch. There are also per-platform `install`/`uninstall` commands. — [graphify/__main__.py](https://github.com/Graphify-Labs/graphify/blob/v8/graphify/__main__.py); [graphify/cli.py](https://github.com/Graphify-Labs/graphify/blob/v8/graphify/cli.py)
- **Team and PR features:**
  - `graphify hook install` rebuilds the graph on commit and branch checkout.
  - `graphify prs` gives a PR dashboard covering CI, review and worktree mapping. Options: `--triage` (LLM ranking) and `--conflicts` (PRs that touch the same subsystems).
  - `merge-graphs` combines graphs, and a git merge driver exists for graph.json.
  — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- **Configuration:**
  - `.graphifyrc` in the scan root holds key=value pairs, for example `language.inc=php`, `viz_node_limit`, `query_budget`, `query_depth`.
  - Ignore rules: `.graphifyignore`, `--exclude`, and `.gitignore`, which `--no-gitignore` bypasses.
  - Environment variables: `GRAPHIFY_BACKEND`, `GRAPHIFY_*_MODEL`, `GRAPHIFY_CLAUDE_PROMPT_CACHE`, `GRAPHIFY_VIZ_NODE_LIMIT`, `GRAPHIFY_QUERY_LOG_DISABLE`, `GRAPHIFY_OUT`.
  - Clustering flags: `--resolution`, `--exclude-hubs`, `--batch-size` (100 communities per labelling call).
  — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- **Privacy:** "No telemetry, no usage tracking, no analytics." Every query is logged locally to `~/.cache/graphify-queries.log` (JSONL, without subgraph bodies), and the log can be opted out of. Kimi routes to Moonshot servers in China. Ollama is the documented fully local option. — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- **Benchmarks (self-reported):**
  - LOCOMO recall@10 0.497 (mem0 0.048, BM25 0.362). LOCOMO QA 45.3% (supermemory 49.7%). LongMemEval-S 76%, tied with dense RAG.
  - ERPNext cross-tool key-fact coverage 82.0% vs 70.8% for a grep/read baseline (n=6, about 140K tokens per query).
  - All systems used one shared model (Kimi K2.6), with a judge validated at 90.6% agreement (κ 0.81).
  - A manual spot-check of 12 INFERRED cross-file edges on FastAPI (2026-10-05) found all correct.
  - HOW claims 71.5x fewer tokens per query on a 52-file mixed corpus, and about 1x on a 6-file corpus.
  — [BENCH](https://github.com/Graphify-Labs/graphify/blob/v8/BENCHMARKS.md); [HOW](https://github.com/Graphify-Labs/graphify/blob/v8/docs/how-it-works.md)

### Inferences
- The benchmarks are vendor-run, and the code benchmark has very small samples (n=6 questions, 12 audited edges). Treat them as indicative, not independent evidence.
- The skill-plus-hook design actively changes agent behaviour: it nudges or denies raw file reads. That matters for any harness that has its own retrieval rules.

### Gaps
- No third-party benchmark reproduction was found or attempted.
- The full environment-variable table is on docs.graphify.com/reference/configuration, which was not fetched.

## Q4. Installation, usage, prerequisites and limitations

### Cited Findings
- Prerequisites: Python 3.11.5–3.14 (`requires-python = ">=3.11.5,<3.15"`), plus uv (recommended) or pipx. Supported on macOS, Linux and Windows. — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md); [PYPROJECT](https://github.com/Graphify-Labs/graphify/blob/v8/pyproject.toml)
- Install:
  - `uv tool install graphifyy` (or `pipx install graphifyy` / `pip install graphifyy`), then `graphify install` (Claude Code by default).
  - For other assistants: `graphify install --platform <name>` or `graphify <platform> install`.
  - `--project` writes the skill under the repo, for example `.claude/skills/graphify/SKILL.md`.
  - The official PyPI name is `graphifyy`. "Other `graphify*` packages on PyPI are not affiliated."
  — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- Minimal usage: in the assistant, run `/graphify .`. From the CLI: `graphify query "<question>"`, `graphify path A B`, `graphify explain X`. Exit codes: 0 answer, 3 ambiguous name, 4 no match. Incremental runs: `/graphify . --update` and `graphify update .`. Code-only offline run: `graphify extract . --code-only`. Extras: `uv tool install "graphifyy[all]"` or individual extras such as `[mcp]`, `[pdf]`, `[video]`, `[leiden]`, `[neo4j]`. — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- API keys: none are needed for code-only graphs or for skill mode, where the host assistant's model does the semantic pass. Headless semantic extraction needs one of the following: GEMINI/GOOGLE, MOONSHOT, ANTHROPIC, OPENAI or DEEPSEEK keys; Azure key and endpoint; AWS IAM (Bedrock); a running Ollama; or the `claude` CLI. — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md)
- Documented limitations:
  - The HTML export defaults to 5,000 nodes and shows an aggregated community view above that.
  - Without the Leiden extra, clustering falls back silently to Louvain, which reshuffles communities.
  - Labelling batches are not split-retried when the context overflows.
  - Ambiguous extensions (`.inc`, `.h`, `.m`) can parse as the wrong language "silently" unless declared in `.graphifyrc`.
  - OpenClaw and Aider run extraction sequentially. Trae has no PreToolUse hooks.
  - The Pi guard needs Pi ≥0.58.4 and a persistent install (not `uvx`).
  - After upgrades, AST cache schema bumps require `graphify extract . --code-only --force` for some languages.
  — [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md); [ARCH](https://github.com/Graphify-Labs/graphify/blob/v8/ARCHITECTURE.md)
- A Dockerfile is present in the repo root, and `docs/docker-mcp-sqlite.md` covers Docker MCP Toolkit plus SQLite. — [repo root](https://github.com/Graphify-Labs/graphify/tree/v8); [docs/docker-mcp-sqlite.md](https://github.com/Graphify-Labs/graphify/blob/v8/docs/docker-mcp-sqlite.md)

### Inferences
- In practice, "fully local" holds only for code and for audio/video. Any docs or PDF content goes to an LLM: either the host assistant's provider or the configured backend.

### Gaps
- Docker usage details were not read.

## Q5. Code organisation: top-level directories, entry points, tests

### Cited Findings
- Top level:
  - `graphify/` is the package.
  - `tests/` holds 612 `test_*.py` files plus `fixtures/`.
  - `docs/` holds how-it-works, an RFC on node summaries, 32 README translations, `superpowers/plans|specs` and `community/`.
  - `worked/` holds reproducible examples (`example`, `httpx`, `karpathy-repos`, `mixed-corpus`, `rsl-siege-manager`), each with raw input plus GRAPH_REPORT.md and graph.json.
  - `tools/skillgen/` generates the per-platform skills, and `scripts/` holds `gen_demo_path.py`.
  - Root files: AGENTS.md and GEMINI.md, `gemini-extension.json`, Dockerfile, `uv.lock`, BENCHMARKS.md, RELEASING.md, SECURITY.md.
  — [repo tree](https://github.com/Graphify-Labs/graphify/tree/v8)
- Package layout: `graphify/extractors/` (37 per-language modules plus `engine.py`, `resolution.py`, `MIGRATION.md`; new languages go here), `graphify/exporters/` (base, html, graphdb), `graphify/skills/<host>/references/`, `graphify/always_on/` (injection blocks), and `graphify/pi/` (a TypeScript Pi extension: `index.ts`, `package.json`). — [graphify/ tree](https://github.com/Graphify-Labs/graphify/tree/v8/graphify); [PYPROJECT](https://github.com/Graphify-Labs/graphify/blob/v8/pyproject.toml)
- Entry points: `graphify = "graphify.__main__:main"` and `graphify-mcp = "graphify.serve:_main"`. Build backend: setuptools>=83. — [PYPROJECT](https://github.com/Graphify-Labs/graphify/blob/v8/pyproject.toml)
- Adding a language:
  1. Add an `extract_<lang>()` function under `extractors/`.
  2. Register the suffix in `extract.py` dispatch and `collect_files()`.
  3. Add the suffix to `CODE_EXTENSIONS` (detect) and `_WATCHED_EXTENSIONS` (watch).
  4. Add the grammar dependency.
  5. Add a fixture and tests in `tests/test_languages.py`.
  — [ARCH](https://github.com/Graphify-Labs/graphify/blob/v8/ARCHITECTURE.md)
- Tests: `pytest tests/ -q`, with one test file per module. The suite is "designed to avoid network access". CI (`ci.yml`) runs on `ubuntu-latest` with a Python 3.11–3.14 matrix. Other workflows: `publish.yml`, `release-graph.yml`, `pr-management.yml`, `welcome.yml`. Dev tooling: ruff (minimal rule set E9/F63/F7/F82), pyright basic, bandit, pip-audit, hypothesis, nuitka, pre-commit. — [ARCH](https://github.com/Graphify-Labs/graphify/blob/v8/ARCHITECTURE.md); [.github/workflows/ci.yml](https://github.com/Graphify-Labs/graphify/blob/v8/.github/workflows/ci.yml); [PYPROJECT](https://github.com/Graphify-Labs/graphify/blob/v8/pyproject.toml)

### Inferences
- CI covers Linux only, but Windows and macOS are documented as supported, so Windows-specific paths (PowerShell skill, UNC handling) are exercised mainly through tests and user reports. This inference rests on a grep of the workflow files that found no windows/macos runners.
- The very large test count (612 files) next to a deliberately minimal lint baseline suggests the project relies on regression tests from issue fixes rather than static strictness.

### Gaps
- No test run was executed. Pass rate and coverage are unknown.
- The contributor count and maintainer structure were not collected, by design: no personal data beyond public handles.
