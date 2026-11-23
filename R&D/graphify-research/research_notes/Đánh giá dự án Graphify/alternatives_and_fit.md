# Graphify: alternatives and fit for an AI-agent harness repository

Research date: 2026-11-23. Scope: what Graphify does, the closest comparable tools, and fit for a Markdown-heavy harness repo (AGENTS.md, SKILL.md skills, routing INDEX, constraint and improvement records) used by Claude Code, Codex, OpenCode and Antigravity.

Local baseline used in the fit section (measured from this repo with `git ls-files`, 2026-11-23): 367 tracked files, 282 Markdown files (~317k words), 40 `SKILL.md` files, 14 Python files.

## 1. What Graphify does (baseline)

### Takeaway
Graphify is a Python CLI and agent skill (`/graphify`). It builds a local knowledge graph in two ways: deterministic tree-sitter parsing for code (no LLM), and an LLM "semantic pass" for docs, PDFs and images. Agents query the graph through a CLI or MCP instead of reading files. It is very popular but young, about 7.5 months old, and its headline token savings are disputed.

### Cited Findings
- Self-description: "Turn any codebase, with its docs, SQL schemas, configs, and PDFs, into a queryable knowledge graph". Also "local deterministic AST parsing, every edge explained, no vector store". Repo created 2026-04-03, last push 2026-11-23, Apache-2.0, Python, 152,110 stars, 14,623 forks, 1,701 open issues. — [GitHub API](https://api.github.com/repos/Graphify-Labs/graphify)
- The README shows both Apache-2.0 and MIT license files, a `v8` branch, about 3,177 commits and no GitHub Releases. — [Graphify README](https://github.com/Graphify-Labs/graphify)
- The PyPI package is `graphifyy` (double y). The latest version is 0.9.115, released 2026-11-21, so it is still pre-1.0. The README warns that other `graphify*` packages are unaffiliated. Install with `uv tool install graphifyy` and `graphify install`. Requires Python 3.11.5–3.14. — [PyPI](https://pypi.org/project/graphifyy/); [README](https://github.com/Graphify-Labs/graphify)
- **Code path:** tree-sitter AST parsing across about 40 languages. It resolves cross-file `calls`, `imports`, `inherits` and `mixes_in` edges, and the README says "Nothing leaves your machine". — [README](https://github.com/Graphify-Labs/graphify)
- **Docs path:** "maps docs, PDFs, images, and audio/video through an optional semantic pass". Docs are "sent to your AI assistant for semantic extraction". Headless `graphify extract` needs a provider: Gemini, Claude, OpenAI, DeepSeek, Kimi/Moonshot (routes to servers in China), Azure OpenAI, Ollama, Bedrock or the `claude` CLI. `GRAPHIFY_BACKEND=ollama` makes it fully local. `--code-only` skips docs entirely. — [README](https://github.com/Graphify-Labs/graphify); [PyPI](https://pypi.org/project/graphifyy/)
- **Edges and clusters:** each edge is tagged `EXTRACTED` or `INFERRED`, and a path's confidence is that of its weakest hop. Leiden community detection groups nodes, falling back to Louvain. `# NOTE:`/`# WHY:` comments and ADR/RFC citations become rationale nodes. — [README](https://github.com/Graphify-Labs/graphify)
- **Outputs** go to `graphify-out/`:
  - `graph.html` (interactive)
  - `GRAPH_REPORT.md` (key concepts, surprising connections, suggested questions)
  - `graph.json` (versioned schema)
  - optional `--wiki` Markdown wiki, Mermaid call-flow HTML, and Neo4j/FalkorDB export

  — [README](https://github.com/Graphify-Labs/graphify)
- **Interfaces:** the CLI offers `graphify query|path|explain`, with exit codes 0 for an answer, 3 for an ambiguous name and 4 for no match. The local MCP server is `graphify-mcp` (stdio). Its tools include `query_graph`, `shortest_path`, `get_node`, `get_neighbors`, `get_community`, `god_nodes`, `get_section`, `graph_stats` and PR tools. There is also a hosted MCP at `api.graphify.com/mcp` (Graphify Cloud, free plan). — [README](https://github.com/Graphify-Labs/graphify)
- **Agent integration:**
  - The README lists 20+ hosts, including Claude Code (the default), Codex (`$graphify`), Cursor, OpenCode, Gemini CLI, Copilot and Antigravity.
  - On Claude Code and Gemini CLI, hooks nudge the agent toward graph queries before reads. Bash searches and Glob "stay advisory". Soft nudges are capped at 5 per session (`GRAPHIFY_HOOK_NUDGE_CAP`).
  - On other hosts it writes persistent instruction files such as `AGENTS.md` or `.cursor/rules/`.

  — [README](https://github.com/Graphify-Labs/graphify)
- **Freshness tools:**
  - `--update` re-extracts changed files only.
  - `graphify watch` rebuilds on file changes.
  - `graphify hook install` rebuilds on commit or checkout.
  - It honors `.gitignore`, `.graphifyignore` and `--exclude`.

  — [README](https://github.com/Graphify-Labs/graphify)
- **Privacy:** the README says there is no telemetry. Queries are logged locally to `~/.cache/graphify-queries.log`, without full responses; `GRAPHIFY_QUERY_LOG_DISABLE=1` turns this off. The README gives no privacy terms for the hosted MCP. — [README](https://github.com/Graphify-Labs/graphify)
- **Self-reported benchmarks:** "LLM credits: 0" for the code graph build. LOCOMO recall@10 0.497 (vs mem0 0.048), but QA accuracy 45.3% vs supermemory 49.7%. LongMemEval-S 76%, "tied with dense RAG". ERPNext key-fact coverage 82.0% vs a grep/read baseline of 70.8% (n=6). — [README](https://github.com/Graphify-Labs/graphify)

### Inferences
- *Inference:* the self-reported benchmark that best matches agent navigation is ERPNext (82.0% vs 70.8%). Its n=6 is too small to generalize from.
- *Inference:* the "deterministic, zero LLM" claim covers only code. In a Markdown-dominant repo, most of the graph would come from the LLM semantic pass.

### Gaps
- The README does not say whether Markdown headings, links or front-matter are parsed structurally or only through the LLM pass. `get_section` is described only as reading "a labeled region of the graph".
- I found no published token or dollar cost per document for the semantic pass, and no description of how changed docs are detected for `--update` (hash vs mtime).
- BENCHMARKS.md was not independently verified.

## 2. Closest alternatives and how they differ

### Takeaway
The closest peers are local, tree-sitter code-graph MCP servers: **GitNexus** and **code-review-graph**. **Aider's repo map** is the lightweight, zero-setup ancestor. **GraphRAG and LightRAG** are adjacent: LLM-extracted document graphs, much costlier to index, aimed at prose corpora rather than agent navigation. Graphify is the only one of the close peers that tries to put code *and* docs/PDFs/media in one graph. That breadth is also its main cost and accuracy risk.

### Cited Findings
- **GitNexus:**
  - Tree-sitter indexing into an embedded graph database (LadybugDB, formerly KuzuDB, with vector support). The CLI indexes locally without an LLM; embeddings, wiki and chat are optional and use your configured provider.
  - MCP tools: `query`, `context`, `impact`, `trace`, `detect_changes`, `rename`.
  - About 18 languages, plus R (experimental). Markdown is not described as an indexed source.
  - `gitnexus analyze` installs skills and Claude Code hooks and writes `AGENTS.md`/`CLAUDE.md`. `gitnexus setup` configures MCP for Claude Code, Cursor, Codex, Antigravity, OpenCode and others.
  - License: **PolyForm Noncommercial 1.0.0**, with commercial licensing sold separately. About 48.7k stars.

  — [GitNexus README](https://github.com/abhigyanpatwari/GitNexus)
- **code-review-graph:**
  - Tree-sitter graph of functions, classes, imports, calls, inheritance and test coverage, with no LLM in the core. Stored in one SQLite file.
  - 30 MCP tools (25 read-only). Incremental re-parse by SHA-256: about 2.5 s for a 2-file edit and about 40 s for a cold build of a ~3,000-file repo.
  - Markdown is **not** a supported format; docs support is limited to HTML `DocSection` nodes.
  - Benchmark: median 6.65× token reduction vs a grep-based agent baseline (18 questions), and about 63× vs a whole-corpus baseline. Impact-analysis F1 0.69. The authors call their own recall-1.0 figure circular.
  - MIT license, about 32.9k stars, and a GitHub Action for PR risk comments.

  — [code-review-graph README](https://github.com/tirth8205/code-review-graph)
- **Aider repo map:** a "concise map of your whole git repository" with key classes, functions and signatures. A graph-ranking algorithm runs over a file-dependency graph. Budget is `--map-tokens`, default 1k tokens, adjusted dynamically. It is sent to the LLM with each request rather than queried as a tool. — [Aider docs](https://aider.chat/docs/repomap.html)
- **Microsoft GraphRAG and LightRAG:**
  - Microsoft reports that LazyGraphRAG indexing costs 0.1% of full GraphRAG, comparable to vector RAG. — [Microsoft Research](https://www.microsoft.com/en-us/research/?p=1106013)
  - Microsoft's own cost explainer covers why full GraphRAG indexing is expensive. — [Microsoft Tech Community](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/graphrag-costs-explained-what-you-need-to-know/4207978)
  - Secondary estimates for a 500-page corpus: vector RAG under $5, LightRAG about $0.50, GraphRAG $50–200. — [tianpan.co](https://tianpan.co/blog/2026-04-09-graphrag-production-when-vector-search-hits-ceiling)
  - LightRAG's claimed savings vary widely across secondary sources, from about 90% to 100× — [aicoolies](https://aicoolies.com/comparisons/lightrag-vs-graphrag); [particula](https://particula.tech/blog/lightrag-vs-graphrag)
- **Positioning by aggregators:** Graphify is the broadest (code plus Markdown, PDFs, Office, SQL, Terraform), GitNexus the most focused on navigation, code-review-graph the most focused on reviewing changes. One Chinese blog frames them as complementary layers. These are aggregator sources, not primary. — [osrepos graphify vs GitNexus](https://osrepos.com/compare/abhigyanpatwari-gitnexus-vs-safishamsi-graphify); [osrepos graphify vs code-review-graph](https://osrepos.com/compare/safishamsi-graphify-vs-tirth8205-code-review-graph); [beehiiv comparison](https://vijayasekhar-deepak.beehiiv.com/p/graphify-vs-gitnexus-vs-codegraph)
- **Independent evidence on Graphify's token savings:**
  - The widely repeated 71× figure comes from "a single specific benchmark on a large monorepo": about 123k tokens with naive Claude Code vs about 1.7k with Graphify.
  - The same reviewer estimates about 1–3× savings under 100 files and advises against installing there.
  - The graph is a snapshot unless hooks are wired. The architecture-overview tool can return about 131k characters (about 33k tokens).

  — [RoboRhythms review, 2026-05-28](https://www.roborhythms.com/graphify-review/)
- **Contradicting user reports** in [issue #985](https://github.com/Graphify-Labs/graphify/issues/985), opened 2026-05-22:
  - Each Graphify query CLI call cost about 2k tokens, and a typical workflow made 3–4 calls (8k+ tokens). Grep/ripgrep was cheaper on a 1,484-file corpus (10,202 nodes).
  - A second user on a large .NET monorepo reported that Graphify MCP cost about 1.6–1.9× *more* than a code-only agent, with weaker answers.
  - No maintainer reply appears. A contributor later pushed MCP and query fixes that reference the issue.
- **Hook compatibility:** Claude Code v2.1.117 removed the dedicated Grep/Glob tools and routed search through Bash, which made Graphify's PreToolUse hook a no-op (issue #578, as reported by the reviewer). — [RoboRhythms](https://www.roborhythms.com/graphify-review/). The current README now targets Bash readers (`cat`, `head`, `sed -n`) and says Bash searches "stay advisory". — [README](https://github.com/Graphify-Labs/graphify)

Comparison summary (facts from the sources above; the "Markdown" column reflects what each README states):

| Tool | Build method | Markdown/docs | Interface | LLM cost to build | Local | License | Maturity signal |
|---|---|---|---|---|---|---|---|
| Graphify | tree-sitter for code, LLM for docs | Yes, via LLM pass | CLI, MCP (local + hosted), skills/hooks | 0 for code; nonzero for docs (unpublished) | Yes (Ollama for docs) | Apache-2.0 (+MIT file) | 152k stars, v0.9.115, created 2026-04 |
| GitNexus | tree-sitter + graph DB | Not as source; generates wiki | MCP, CLI, web UI | 0 core; optional embeddings/wiki | Yes | PolyForm Noncommercial | ~48.7k stars |
| code-review-graph | tree-sitter + SQLite | No (HTML only) | MCP (30 tools), CLI, GH Action | 0 core | Yes | MIT | ~32.9k stars, published honest baselines |
| Aider repo map | dependency graph ranking | No | Injected into prompt | 0 | Yes | (Aider, Apache-2.0) | Long-established |
| GraphRAG / LightRAG | LLM entity extraction | Yes (prose-first) | Library/API | High (GraphRAG) / lower (LightRAG) | Yes, with local LLM | MIT | Research-backed |

### Inferences
- *Inference:* for agent *code* navigation, code-review-graph publishes the most honest baseline (6.65× vs grep). Graphify's 71× is vs a naive whole-read baseline. Comparable savings for Graphify on code would plausibly sit in the single digits too, and on small repos may be negative (issue #985).
- *Inference:* none of the code-graph peers handles Markdown well. Graphify is the only near-peer that ingests it, so it is the only plausible candidate if the goal is a graph of *docs and skills*. That ingestion is LLM-based and non-deterministic.
- *Inference:* star counts differ between aggregators (124k) and the API (152k) because the snapshots were taken at different times. The very fast growth since April 2026 means stars are a weak maturity signal compared with the 1,700 open issues and the pre-1.0 version.

### Gaps
- No head-to-head benchmark of Graphify vs GitNexus vs code-review-graph on the same repo and questions was found.
- Sourcegraph/Cody, Repomix, DeepWiki, Cognee and Graphiti/Zep were not investigated in depth within the tool budget. Cognee and Graphiti are agent-memory graphs, and Repomix and DeepWiki are pack/summarize tools, so their match is likely weaker (unverified).
- The InfoQ article on Graphify (2026-09) could not be fetched (HTTP 405).

## 3. Fit for a Markdown-heavy harness repository

### Takeaway
Graphify's strengths (deterministic code graph, savings on large codebases) do not match this repo: 282 Markdown files, 40 skills and only 14 Python files. Its docs path costs LLM tokens, is non-deterministic, and may send content to a provider. The best-supported option is a small, time-boxed pilot: build a graph once over `docs-harness/` and the skills, using a local or assistant model, as an *offline audit artifact* (routing drift, orphan or duplicate rules). Do not install Graphify as an always-on query layer or hook yet.

### Cited Findings
- **Repo size:** this repo is 367 tracked files: 282 `.md` (~317k words), 40 `SKILL.md`, 14 `.py`. Measured locally with `git ls-files` on 2026-11-23.
- **Repo-size threshold:** below about 100 files Graphify "barely helps", because grep is already cheap. Savings grow with size. — [RoboRhythms](https://www.roborhythms.com/graphify-review/)
- **Per-query cost:** about 2k tokens per query call, and in practice grep was often cheaper. — [issue #985](https://github.com/Graphify-Labs/graphify/issues/985)
- **Code-only mode:** `--code-only` skips the docs that "would otherwise need an LLM". — [README](https://github.com/Graphify-Labs/graphify)
- **Data flow for docs:** docs go to the assistant model or a configured provider. `GRAPHIFY_BACKEND=ollama` keeps them local. The Kimi backend routes to servers in China. Backend auto-detection follows a fixed priority. — [README](https://github.com/Graphify-Labs/graphify)
- **Host integration:** Graphify writes instruction files (`AGENTS.md`, `.cursor/rules/`) on non-hook hosts and installs Claude Code hooks. GitNexus also writes `AGENTS.md`/`CLAUDE.md`. — [Graphify README](https://github.com/Graphify-Labs/graphify); [GitNexus README](https://github.com/abhigyanpatwari/GitNexus)
- **Freshness:** `--update`, `watch` and git hooks exist. A stale graph "silently degrade[s] results". — [README](https://github.com/Graphify-Labs/graphify); [RoboRhythms](https://www.roborhythms.com/graphify-review/)
- **Host-version fragility:** hook behavior has already broken once on a Claude Code tool change (v2.1.117). — [RoboRhythms](https://www.roborhythms.com/graphify-review/)
- **Oversized responses:** the overview output can reach about 33k tokens if called without limits. — [RoboRhythms](https://www.roborhythms.com/graphify-review/)

### Inferences
All points in this section are inferences, grounded in the findings above.

**Where it could help:**
1. **Routing-drift audit.** A graph of INDEX → folder READMEs → constraints/skills, with `god_nodes`, orphan nodes and `shortest_path`, could show unrouted or duplicated rules and surprising cross-links. `GRAPH_REPORT.md` "surprising connections" fits this use. It would complement the repo's existing deterministic `harness_check.py`, not replace it: the LLM-extracted edges are `INFERRED` and need human review.
2. **Concept lookup across skills.** "Which skills and constraints mention X?" via `graphify query`, instead of loading many SKILL.md files. The value is questionable at this size, because ripgrep over about 317k words is fast and cheap.
3. **Onboarding visual.** `graph.html` or the `--wiki` output as a one-off map for human maintainers.

**Where it fits poorly or adds risk:**
1. **Wrong strength.** The deterministic, zero-cost path (code) covers only 14 Python files. Everything that matters here goes through the LLM path, which has an unpublished cost.
2. **It would compete with the harness's own instruction files.** Graphify and GitNexus install hooks and write `AGENTS.md`/rules. That would edit the files the harness governs, so installation must be manual and reviewed. The repo's `AGENTS.md` and `improve-harness` workflow own those files.
3. **Staleness vs a fast-changing rule set.** Constraint and improvement records change often (#090–#093 in recent commits). A stale graph can route agents to superseded rules, which is worse than no graph.
4. **Data egress.** Harness docs may hold private workflow or project details. The default backend is the assistant's model or the first detected API key. Pin `GRAPHIFY_BACKEND=ollama`, or use the current Claude session only, and never the hosted Graphify Cloud MCP for this repo.
5. **Supply chain.** The package name is typosquat-prone (`graphifyy`), the project is pre-1.0 with frequent releases, and the dual license files need a quick legal check.
6. **Multi-host parity.** Hooks exist only for Claude Code and Gemini CLI. Codex, OpenCode and Antigravity get instruction-file nudges only, so behavior would differ across the four hosts this harness targets.

**Suggested small pilot** (1–2 hours, read-only, reversible):
1. In a throwaway git worktree, run `uv tool install graphifyy` pinned to a version. Do **not** run `graphify install` or `hook install`, so no `AGENTS.md`, rules or hook changes.
2. Run `graphify extract docs-harness/ .agents/skills/ --backend ollama`, or run it in-session with the current model, with `.graphifyignore` excluding `templates/` and `tickets/`. Record wall time and tokens (the `/cost` delta or provider usage).
3. Read `GRAPH_REPORT.md` and the god and orphan nodes. Cross-check against `harness_check.py --quick` output. Count true vs false drift findings.
4. Ask 10 typical navigation questions ("which rule governs X", "which skill handles Y") two ways, once via `graphify query` and once via ripgrep plus reading. Compare tokens, accuracy and steps.
5. Decision criterion: adopt only as an occasional audit tool, if it finds at least one real drift issue that `harness_check` misses and the build cost is acceptable. Adopt as an agent query layer only if step 4 shows a clear token *and* accuracy win, which the evidence above makes unlikely at this repo size.

**Alternatives for the same goals:**
- For drift, extending `harness_check.py` (deterministic links and IDs) is cheaper.
- For code navigation in *consumer* projects that use this harness, code-review-graph (MIT, honest baselines) or Graphify `--code-only` is the better trial. GitNexus is out for commercial use because of its license.

### Gaps
- There are no measurements of Graphify on a Markdown-only or instruction-repo corpus. All cost and benefit estimates for this use case are extrapolated.
- Unknown whether Graphify extracts Markdown links and headings deterministically. If it did, the drift use case would become much stronger and cheaper. This should be the first thing the pilot checks.
- No source covers multi-agent (Codex/OpenCode/Antigravity) behavior parity in practice.
