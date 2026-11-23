# Graphify (Graphify-Labs/graphify): maturity, activity, license and community reception

All figures below were read on **2026-11-23** unless another date is given. GitHub API figures come from unauthenticated `api.github.com` calls made that day. "API" links point to the endpoint that was queried.

## 1. Repository activity and maturity metrics

### Takeaway
Graphify is a very young project with an extreme popularity curve. The first commit was 2026-04-03, and by 2026-11-23 it had about 152k stars, about 14.6k forks, about 3.2k commits, about 431 contributors and 261 GitHub releases. Development is intense: about 100 to 180 commits a week and a release every one to two days. Authorship is concentrated in one maintainer, and the project is still pre-1.0 (0.9.x).

### Cited Findings
- **Stars 152,110. Forks 14,623. Watchers (subscribers) 436.** `open_issues_count` (issues plus PRs) is 1,701. The default branch is `v8` and the primary language is Python. Topics include claude-code, cursor, codex, gemini, mcp, tree-sitter, knowledge-graph, graphrag and leiden. — [GitHub API repo](https://api.github.com/repos/Graphify-Labs/graphify)
- **Repo created** 2026-04-03T15:49Z. **Last push** 2026-11-23T00:39Z. Not archived. Discussions are enabled. — [GitHub API repo](https://api.github.com/repos/Graphify-Labs/graphify)
- **First commit** 2026-04-03T17:56Z, "feat: core pipeline", covering detect, extract (AST + call-graph), build, cluster and analyze. **Total commits on `v8`: about 3,177** (page count of `commits?per_page=1`). — [GitHub API commits](https://api.github.com/repos/Graphify-Labs/graphify/commits)
- **Issues: 779 open and 1,559 closed. PRs: 922 open, 143 merged, 1,860 closed unmerged** (GitHub search API counts). — [GitHub search API](https://api.github.com/search/issues?q=repo:Graphify-Labs/graphify+type:pr+is:merged)
- **Why so few PRs show as merged:** the repo's PR-management workflow mentions "authorship-preserving cherry-picks". Maintainers land community changes by cherry-picking them, which leaves the PRs closed rather than merged. Release notes credit outside contributors by name, for example "thanks @Arav-Arun" and "thanks @ayushcodes10". — [pr-management.yml](https://github.com/Graphify-Labs/graphify/blob/v8/.github/workflows/pr-management.yml); [release v0.9.115](https://github.com/Graphify-Labs/graphify/releases/tag/v0.9.115)
- **Contributors: about 431** (anonymous included; page count of `contributors?per_page=1&anon=1`). The top committers are safishamsi (1,343 commits), ayushcodes10 (223), Deepjyoti-Sarmah (114), rohit-jsfreaky (75) and rajatnagda45 (57). — [GitHub API contributors](https://api.github.com/repos/Graphify-Labs/graphify/contributors)
- **Commit frequency:** 3,106 commits in the last 52 weeks. The most recent 26 complete weeks ranged from 15 to 176 commits, mostly 60 to 170, and the trend rose into Oct–Nov 2026 (176, 152, 145, 170, 165, 125, 113). — [GitHub API stats/commit_activity](https://api.github.com/repos/Graphify-Labs/graphify/stats/commit_activity)
- **Releases: 261 GitHub releases and 263 tags. Latest is v0.9.115**, published 2026-11-21T21:27Z and not a prerelease. Releases per month: Apr 9, May 52, Jun 27, Jul 28, Aug 22, Sep 20, Oct 26, Nov (to the 21st) 16. Six releases came out between 2026-11-15 and 2026-11-21. — [GitHub API releases](https://api.github.com/repos/Graphify-Labs/graphify/releases)
- **Odd version history:** the oldest GitHub release is tagged **v1.0.0 (2026-04-05)**, and later releases restart at v0.3.x and v0.4.x. PyPI's first version is 0.1.1 (2026-04-04). — [GitHub API releases page 3](https://api.github.com/repos/Graphify-Labs/graphify/releases?per_page=100&page=3); [PyPI JSON](https://pypi.org/pypi/graphifyy/json)
- **PyPI package `graphifyy` (double "y"): 283 versions.** First upload 2026-04-04 (0.1.1), latest 2026-11-21 (0.9.115). Requires Python `>=3.11.5,<3.15`. — [PyPI JSON](https://pypi.org/pypi/graphifyy/json)
- The vendor reported ">130 people have contributed code" and ">150 releases" as of 2026-08-02. — [Graphify blog, 2026-08-02](https://graphify.com/blog/first-yc-company-100k-stars)

### Inferences
- The release cadence (about one a day) and the cherry-pick merge model point to a fast-moving, maintainer-driven project. Teams should expect frequent upgrades and pin versions.
- **Bus factor:** one account holds about 42% of commits (1,343 of about 3,177). It authors the releases and is the company's founder and only listed team member (see section 2). The project depends heavily on one person.
- The v1.0.0 tag sitting before the 0.x line looks like an early versioning mistake that was later reset. Treat version numbers as non-semantic before 0.9.
- The 922 open PRs and 779 open issues are large in absolute terms. The closed-to-open issue ratio is about 2:1, which suggests active triage that still trails inflow.

### Gaps
- I did not check whether the 152k stars are organic. No star-history or fake-star audit was attempted, and growth to 152k in under 8 months is unusual.
- The commit count covers the `v8` default branch only. Other branches (v1–v7, main) were not counted separately.
- No figure for median issue or PR response time was computed.

## 2. License, governance and who is behind Graphify Labs

### Takeaway
The code is **Apache-2.0** (SPDX `Apache-2.0`). It was relicensed from MIT, and earlier MIT-licensed portions keep MIT terms (LICENSE-MIT plus NOTICE). Graphify Labs is a **Y Combinator S26** startup with a single founder and CEO, Safi Shamsi, who created the tool. It runs an **open-core** model: a free Apache-2.0 CLI and paid hosted Pro, Teams and Enterprise tiers. No formal governance document or roadmap file exists.

### Cited Findings
- **License: Apache License 2.0, SPDX `Apache-2.0`**, per GitHub's license detection and the PyPI `license_expression`. — [GitHub API license](https://api.github.com/repos/Graphify-Labs/graphify/license); [PyPI JSON](https://pypi.org/pypi/graphifyy/json)
- `pyproject.toml` declares `license = "Apache-2.0"` and `license-files = ["LICENSE", "LICENSE-MIT", "NOTICE"]`. — [pyproject.toml](https://github.com/Graphify-Labs/graphify/blob/v8/pyproject.toml)
- **NOTICE:** "Copyright 2026 Safi Shamsi and the Graphify contributors". The product is under Apache 2.0, and code contributed under MIT before the relicensing stays available under MIT. LICENSE-MIT reads "Copyright (c) 2026 Safi Shamsi". — [NOTICE](https://github.com/Graphify-Labs/graphify/blob/v8/NOTICE); [LICENSE-MIT](https://github.com/Graphify-Labs/graphify/blob/v8/LICENSE-MIT)
- **Contribution terms:** CONTRIBUTING.md asks contributors to disclose material AI help with a `Co-Authored-By:` trailer. No CLA or DCO requirement turned up in a grep of CONTRIBUTING.md. — [CONTRIBUTING.md](https://github.com/Graphify-Labs/graphify/blob/v8/CONTRIBUTING.md)
- **Governance:** there is no GOVERNANCE.md and no ROADMAP.md (both return 404). The repo does have CODE_OF_CONDUCT.md, CONTRIBUTING.md, SECURITY.md, SUPPORT.md, RELEASING.md, ARCHITECTURE.md and a `.github/TEAM_MEMBERS` maintainer list referenced by CI. — [repo contents API](https://api.github.com/repos/Graphify-Labs/graphify/contents/?ref=v8); [pr-management.yml](https://github.com/Graphify-Labs/graphify/blob/v8/.github/workflows/pr-management.yml)
- **Organization profile:** "Graphify Labs". Blog https://graphify.com/, listed location "United States of America", Twitter @graphify, not verified, 1,140 followers, 12 public repos. Created **2026-06-28**, almost three months after the repo, so the repo was apparently transferred in from the founder's account. The other repos include graphify-mcp, docs, the Gemini extension, Cursor, OpenCode, Claude, Codex and Antigravity plugins, and REAgraph. — [GitHub API org](https://api.github.com/orgs/Graphify-Labs); [org repos API](https://api.github.com/orgs/Graphify-Labs/repos)
- The original URL github.com/safishamsi/graphify still appears in early HN posts and in PyPI-derived search results. — [HN item 47668188](https://news.ycombinator.com/item?id=47668188)
- **YC listing:** batch Summer 2026, founded 2026, **team size 1**, San Francisco, founder Safi Shamsi (Founder/CEO), status Active. YC describes it as "a knowledge graph control plane" for developers and AI agents. — [YC company page](https://www.ycombinator.com/companies/graphify-labs)
- **Commercial offering (open core):** the Apache-2.0 CLI engine is free and promises no telemetry. A free hosted plan includes PR reviews. Pro and Teams are paid with a two-week trial, and no prices are listed. Enterprise is sold through a demo and can be self-hosted. The site claims SOC 2 Type II is "in progress" and says "Backed by Y Combinator". — [graphify.com](https://graphify.com/)
- An always-on hosted version is in early access at app.graphify.com. — [Graphify blog, 2026-08-02](https://graphify.com/blog/first-yc-company-100k-stars)
- **Funding:** apart from YC backing, no amounts are disclosed by the company. Third-party directories disagree: one lists a $125k seed with an SF HQ, another a $500k "Seed (Incubation)" with a London office. Treat both as unverified. — [Dealroom listing](https://app.dealroom.co/companies/graphify_labs_yc_s26) (as summarised by a web search; not opened directly)
- Search summaries also mention a Rust enterprise engine called "Penpax" with a waitlist of more than 4,500. — [techfundingnews](https://techfundingnews.com/he-built-an-open-source-tool-ai-coding-assistants-couldnt-ignore/) (from a search summary, not verified by opening the page)

### Inferences
- Apache-2.0 is permissive and grants patents, so it is adoption-friendly for commercial use. The NOTICE file must be kept when redistributing. The MIT carve-out for older code is harmless, because both licenses are permissive.
- Open core plus a single-founder VC-backed company carries a known risk. Future features may go to the hosted tier, and the license could in principle change for new versions. Nothing so far suggests a move away from Apache-2.0.
- With no governance document, decisions rest with the company and its founder.

### Gaps
- The relicensing date (MIT to Apache-2.0) and the commit where it happened were not found.
- No verified funding amount or investor list was found.
- The `.github/TEAM_MEMBERS` file was not read, so the number of maintainers with merge rights is unknown.

## 3. Quality signals: tests, CI, docs, security, breaking changes, roadmap

### Takeaway
Engineering hygiene is strong for a project this young: 619 files in `tests/`, a CI test matrix across Python 3.11–3.14, codespell, workflow lint, an install sandbox, CI-built PyPI publishing, Dependabot, Copilot PR review, and a detailed SECURITY.md threat model. On the other side, there are two **high-severity** published GHSA advisories (Sep and Nov 2026), four GHSA IDs mentioned in release notes, several breaking schema or node-ID changes inside 0.x, and no public roadmap file.

### Cited Findings
- **Tests:** the `tests/` directory holds 619 entries. The repo also contains `BENCHMARKS.md`, `ARCHITECTURE.md`, `CHANGELOG.md`, a `Dockerfile`, `uv.lock` and `.pre-commit-config.yaml`. — [tests contents API](https://api.github.com/repos/Graphify-Labs/graphify/contents/tests?ref=v8); [repo contents API](https://api.github.com/repos/Graphify-Labs/graphify/contents/?ref=v8)
- **CI workflows:** CI (`ci.yml`, with a skillgen-check job plus a test matrix over Python 3.11, 3.12, 3.13 and 3.14 using `uv run --frozen`), Codespell, Install sandbox, PR management, Publish to PyPI, QML optional wheel, Release graph asset, Welcome/Discord invite, Workflow lint, Copilot code review and Dependabot dependency graph. — [workflows API](https://api.github.com/repos/Graphify-Labs/graphify/actions/workflows); [ci.yml](https://github.com/Graphify-Labs/graphify/blob/v8/.github/workflows/ci.yml)
- The latest CI runs on `v8` (2026-11-23 00:27Z and 00:39Z) both **succeeded**. — [Actions runs API](https://api.github.com/repos/Graphify-Labs/graphify/actions/runs?branch=v8)
- **Docs:** there is a dedicated site (docs.graphify.com, linked from PyPI) and a `docs` repo under the org. CONTRIBUTING.md sets out explicit invariants: deterministic extraction, provenance, fail-closed behaviour, and treating Windows portability as first-class. — [PyPI JSON](https://pypi.org/pypi/graphifyy/json); [CONTRIBUTING.md](https://github.com/Graphify-Labs/graphify/blob/v8/CONTRIBUTING.md)
- **Security policy:** only the latest 0.9.x is supported, and anything below 0.9 is not. Reports go through private vulnerability reporting. The documented threat model covers SSRF validation, a 50 MB fetch cap, and an opt-in HTTP MCP listener. It states that semantic extraction may send content to a configured model backend, while AST extraction stays local. — [SECURITY.md](https://github.com/Graphify-Labs/graphify/blob/v8/SECURITY.md)
- **Published security advisories (2, both high):**
  - GHSA-pcc4-rvhr-2pr8 (2026-09-27): incomplete cpp `#include` hardening in the Fortran extractor allows arbitrary host-file read or exfiltration.
  - GHSA-g6c9-j4vm-mwq4 (2026-11-23): indexing a repo stats UNC paths that the repo itself chooses, which could coerce SMB auth and leak NetNTLMv2 on Windows under default offline settings. Fixed in v0.9.115.

  — [security-advisories API](https://api.github.com/repos/Graphify-Labs/graphify/security-advisories); [release v0.9.115](https://github.com/Graphify-Labs/graphify/releases/tag/v0.9.115)
- Release notes also mention GHSA-4xgf-cpjx-pc3j and GHSA-6v7p-g79w-8964, which do not appear in the repo's published advisory list. — [GitHub API releases](https://api.github.com/repos/Graphify-Labs/graphify/releases)
- **Open issues labelled `bug`: 18.** Most of the 779 open issues are unlabelled or carry other labels. — [GitHub search API](https://api.github.com/search/issues?q=repo:Graphify-Labs/graphify+type:issue+state:open+label:bug)
- **Breaking changes in 0.x:**
  - v0.4.12 (2026-04-13): cache-breaking change; users must delete `graphify-out/cache/`.
  - v0.8.18 (2026-05-24): Java `extends` edges renamed to `inherits`.
  - **v0.9.0 (2026-06-28): node IDs changed** to include the full repo-relative path, which needed re-migration.
  - v0.9.115: an AST cache schema bump (50 to 51) forces re-extraction.

  — [GitHub API releases](https://api.github.com/repos/Graphify-Labs/graphify/releases); [release v0.9.115](https://github.com/Graphify-Labs/graphify/releases/tag/v0.9.115)
- v0.9.13 (2026-07-12) made the query log **opt-in**, ending an "undocumented plaintext record" of queries in `~/.cache` (#1797). — [GitHub API releases](https://api.github.com/repos/Graphify-Labs/graphify/releases)
- A review reported a hook incompatibility with newer Claude Code. The suggested workaround was to pin Claude Code to v2.1.116 or earlier. — [roborhythms review](https://www.roborhythms.com/graphify-review/) (from a search summary)
- **Roadmap:** there is no ROADMAP.md (404). The only forward-looking statements found are vendor ones: the hosted app.graphify.com and an enterprise tier. — [Graphify blog](https://graphify.com/blog/first-yc-company-100k-stars); [graphify.com](https://graphify.com/)

### Inferences
- The test and CI depth is well above typical for an eight-month-old project.
- The advisories show an active attack surface, because the tool parses untrusted repos. Two high-severity issues in two months mean teams should run only the latest 0.9.x and avoid indexing untrusted repositories on Windows hosts.
- The pattern of breaking changes means graph outputs and queries are not stable across minor versions. Downstream tooling should pin versions and plan for rebuilds.

### Gaps
- No coverage percentage or OpenSSF Scorecard result was found.
- The two GHSA IDs that appear only in release notes were not resolved. They may be advisories filed in other repos or in upstream dependencies.

## 4. External reception: discussions, articles, downloads, awesome-lists

### Takeaway
Adoption signals are large: about **10.2M PyPI downloads** from 2026-05-26 to 2026-11-22 (pypistats, without mirrors), about **2.15M in the last month** and about 65k a day, plus many blog posts and tutorials. Hacker News engagement with the project itself is small, but there are several derivative ports. The headline "71x fewer tokens" claim is self-reported. An independent 360-trial benchmark (Oct 2026) found **no clear accuracy or token gain** for strong agents on its tasks.

### Cited Findings
- **PyPI downloads (`graphifyy`):** last day 64,886, last week 557,748, last month 2,153,211. The sum of daily downloads without mirrors over 181 days (2026-05-26 to 2026-11-22) is 10,163,904. — [pypistats recent](https://pypistats.org/api/packages/graphifyy/recent); [pypistats overall](https://pypistats.org/api/packages/graphifyy/overall?mirrors=false)
- The vendor site claims 11.4M PyPI downloads, 15.2M repositories indexed and 152,108 stars. It names users including Shopify, Datadog, Vanguard, Microsoft and J.P. Morgan, which I could not verify. — [graphify.com](https://graphify.com/)
- The unrelated name `graphify` on PyPI returns 404. The official package is `graphifyy`, and search results also turn up unaffiliated GitHub repos named graphify (Nectrion/graphify, TOOTW/graphify). That is a name-confusion and typosquat risk. — [PyPI graphify](https://pypi.org/pypi/graphify/json); [web search results](https://github.com/Nectrion/graphify)
- **Milestone:** 100k stars in July 2026, 117 days after the first commit. YC's Jared Friedman is quoted calling it "the first YC company to hit 100K github stars during the batch". — [Graphify blog, 2026-08-02](https://graphify.com/blog/first-yc-company-100k-stars)
- **Hacker News:** the Algolia "graphify" story search returned 13,444 hits overall, many unrelated. The project's own submissions scored low, for example 2026-04-06 with 2 points and 1 comment, and 2026-07-14 Show HN with 2 points and 0 comments. Derivative projects scored higher:
  - "Graphicle, a Rust port of Graphify" (2026-10-14): 48 points, 15 comments.
  - "Graphify C#" (2026-09-12): 46 points, 20 comments.
  - "graf (1000x faster graphify in Rust)" (2026-09-22): 13 points.
  - Rootly used Graphify to turn incidents into a graph (2026-04-12): 10 points.
  - An "Ask HN: We got 100 stars. A weekend project got 12k" thread (2026-04-08) drew 18 comments.

  — [HN Algolia API](https://hn.algolia.com/api/v1/search?query=graphify&tags=story)
- **Independent benchmark** (srijansriv.com, 2026-10-16): 360 trials over 12 questions on airflow, VS Code and Spring, using Claude Code (Sonnet 5.5) and Codex (GPT-6.1-sol).
  - F1 with plain grep was 0.961 / 0.995, against 0.982 / 0.997 with the graph hook.
  - The hook used **17% more** tokens on Claude and 5% fewer on Codex.
  - Agents chose graph tools in only 1 of 36 and 4 of 36 trials.
  - A follow-up "new hook" prototype showed about a 13% token reduction over 15 trials, which the authors call unconfirmed.
  - The study was prompted by graphify issue #985.

  — [srijansriv.com benchmark](https://srijansriv.com/graphify-benchmark); HN discussion: [item 50353269](https://news.ycombinator.com/item?id=50353269)
- **The "71x token reduction" claim** traces back to Graphify's own benchmark: about 123k tokens with naive Claude Code against about 1.7k with Graphify on a 52-file corpus. The "zero tokens" claim covers only the code/AST path; docs, PDFs and images use LLM extraction. — [roborhythms review](https://www.roborhythms.com/graphify-review/); [Medium (Rahul Saini)](https://medium.com/@rahulsaini202/i-was-burning-through-claude-tokens-until-i-found-this-tool-f44d7d67ee4b) (from search summaries)
- **Articles and tutorials:** examples include dev.to reviews and how-tos, MindStudio's "70x" post, several Augment Code "learn" pages (including v0.9.9 benchmarks), Medium tutorials, claudelog.com, an Obsidian + Claude Code guide repo, Skool community posts and Analytics Insight.
  - [MindStudio](https://www.mindstudio.ai/blog/graphify-claude-code-knowledge-graph-large-codebase-70x)
  - [Augment Code](https://www.augmentcode.com/learn/graphify-v099-benchmarks-knowledge-graph)
  - [dev.to (lorenzojkrl)](https://dev.to/lorenzojkrl/cut-your-claude-token-consumption-by-70x-3kh2)
  - [claudelog](https://claudelog.com/claude-code-mcps/graphify)
  - [eric-orozco guide](https://github.com/eric-orozco/graphify-obsidian-claude_code-guide)
  - [Analytics Insight](https://www.analyticsinsight.net/artificial-intelligence/from-developer-interest-to-recurring-use-safi-shamsi-tracks-graphifys-growth-as-an-ai-coding-context-layer)
- **Reddit:** direct access failed because the reddit.com JSON search returned no parseable data. A dev.to review (titled "88k star YC S26") quoted r/ClaudeAI posts as unusually positive, but the page returned 404 when fetched. — [dev.to review (404 on 2026-11-23)](https://dev.to/andrew-ooo/graphify-review-88k-star-yc-s26-code-knowledge-graph-5aip)
- **Awesome-lists:** "graphify" does not appear in the READMEs of hesreallyhim/awesome-claude-code (58.6k stars), VoltAgent/awesome-agent-skills, travisvn/awesome-claude-skills or sickn33/agentic-awesome-skills, checked by grep on 2026-11-23. — [awesome-claude-code README](https://github.com/hesreallyhim/awesome-claude-code)
- An unofficial site, graphify.net, was submitted to HN (2026-06-27). The official domain is graphify.com. — [HN Algolia API](https://hn.algolia.com/api/v1/search?query=graphify&tags=story)

### Inferences
- Download volume (about 2M a month) and the ecosystem of ports (Rust, C#) point to real, widespread use, not just stars. Some of the volume is likely CI and automated installs.
- Evidence on value is mixed. The vendor's token-savings figures come from small self-run benchmarks, and the one independent rigorous test found no gain for strong agents on code-lookup questions. Teams should run their own evaluation before adopting it for token savings.
- Being absent from the largest awesome-lists despite 152k stars is unusual. It may reflect list curation policies rather than reception.

### Gaps
- No direct Reddit or X (Twitter) thread data could be retrieved.
- No pepy.tech all-time total was retrieved. pypistats covers only the last 180 days, so April–May 2026 downloads are missing.
- No npm package was found or checked. The project is Python-only on PyPI.
- The enterprise customer names on graphify.com are unverified.
