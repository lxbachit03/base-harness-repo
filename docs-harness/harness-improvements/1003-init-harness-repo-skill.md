# Harness Improvement Resource

ID: #038_IMPROVE_HARNESS_1003
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: User-invoked init-harness-repo skill for scaffolding a minimal Harness
CREATED: 2026-10-03
STATUS: completed
REFERENCES:
- .agents/skills/init-harness-repo/SKILL.md
- .agents/skills/init-harness-repo/scaffold.md
- .claude/skills/init-harness-repo/
- .agents/skills/writing-for-agents/SKILL-MECHANICS.md
- GOAL.md (User-set goal, untracked)

## Objective

A user-invoked skill `init-harness-repo` exists in `.agents/skills/` and is
mirrored byte-for-byte in `.claude/skills/`. Run in another repository, it
interviews the User and scaffolds a minimal Harness (root `AGENTS.md`, a
routing file, `harness-improvements/`, `layers/layer-1/`,
`harness-constraints/`, `templates/`) exactly as the specification below
describes, without overwriting existing files.

## Purposes

- [x] Initialize a Harness repo in another repository from one reusable skill
  (specification Purpose: "Khởi tạo harness repo").
- [x] Make every scaffolded Harness follow Mindset 1 (Top-Down routing to save
  tokens) and Mindset 2 (Bottom-Up retrieval when the agent judges it needed).
- [x] Ground the scaffold in the User's own answers (harness folder,
  orchestrator name, Harness goal, routing filename) through Meta-Prompting.
- [x] Keep invocation manual (`disable-model-invocation: true`) so the skill
  costs no always-loaded context (User decision 2026-10-03).

## Current State

Baseline (2026-10-03): repository `D:\repos\base-harness-repo`, branch
`harness/retire-012-route` at `e33dda6`, worktree clean except the User's
untracked `GOAL.md`. No `init-harness-repo` skill exists in `.agents/skills/`
or `.claude/skills/`. Skills are mirrored from `.agents/skills/` to
`.claude/skills/` (precedent #026, #027).

Goal interview decisions (2026-10-03): create only the skill now, for later use
in other repositories; user-invoked only. Accepted assumptions: the generated
`AGENTS.md` carries only the specification's rules (not this repository's
task-authority policy); "Jev," in the request addresses the agent and does not
require TypeSafe integration; wording is condensed per writing-for-agents while
each requirement's meaning and Purpose are preserved.

Specification (verbatim, acceptance source):

```text
Purpose:
    Khởi tạo harness repo
Nhóm mindsets:
    Purpose: Đây là những mindset bắt buộc harness repo phải tuân theo
    Mindset 1: ứng dụng phương pháp Top-Down Approach.

Purpose: để tiết kiệm tokens, Khi AI agent chỉ đọc 1 file .md nơi chứa những nội dung có routing, AI agent sẽ chỉ đọc sâu/load nội dung routing đó vào context nếu cần thiết cho user intent.
    Mindset 2: ứng dụng phương pháp Bottom-Up Approach.

Purpose: Cho phép AI agent truy xuất dữ liệu thêm phương pháp Bottom-Up bỏ qua yêu cầu tiết kiệm tokens để tối ưu truy xuất

Lưu ý: chỉ dòng cách này khi cần thiết (AI agent tự quyết định)
Nhóm requirements:
    Nhóm yêu cầu 1: Yêu cầu chung
        Yêu cầu 1.1: AI agent sẽ đặt câu hỏi cho user (Meta-Prompting / Inverted Prompting).

Purpose: AI agent hiểu được intent của user để đưa ra kết quả tối ưu/hiệu quả.

Danh sách câu hỏi:
1. Folder cho harness repo là gì? (default option: `docs-harness`); Hãy gợi ý cho user default option. Lưu ý: mỗi khi user đề cập đến "harness repo" thì có nghĩa là tôi đang nói đến folder này.
2. Tên Orchestrator/Người điều phối agent là gì? (default option: "BALE"); (Mục đích câu hỏi: là để để gọi tên khi muốn main agent trong session hiện tại điều phối/cordinate 1 main agent khác).
3. Mục tiêu của harness repo là gì? (Mục đích câu hỏi: giúp AI agent hiểu được mục đích thật sự của harness repo là gì để từ đó có những ngữ cảnh/context phù hợp để đưa kết quả cho user theo ngữ cảnh/context mà họ muốn.
        Yêu cầu 1.2: Tạo ra 1 file AGENTS.md tại thư mục root.

Purpose: Nội dung trong file này sẽ được AI agent đính kèm đầu mỗi prompt
        Yêu cầu 1.3: Nếu intent của user chưa rõ ràng hãy dùng kỹ thuật hỏi user những câu hỏi cần thiết để có 1 context phù hợp đưa ra kết quả cuối cùng dùng kỹ thuật Meta-Prompting / Inverted Prompting.
Lưu ý 1: hãy đưa ra đề xuất nếu có nhiều options và giải thích mỗi options cho user dùng chọn, thêm 1 input cho user nhập nếu không có options nào phù hợp với user.
        Yêu cầu 1.4: Tạo file .md tại folder harness repo.

Purpose: Nơi routing cho AI agent áp dụng mindset 1: Top-Down Approach.
Lưu ý 1: Hãy hỏi user là tên file mong muốn là gì? (default option: `INDEX.md` và thêm 1 input cho user nhập nếu user muốn custom).
Lưu ý 2: trong file .md này phải có back-link để reference đến resources cụ thể (nhớ verify lại back-link).
        Yêu cầu 1.5: Mỗi khi user yêu cầu kiểm tra tình trạng hiện của harness repo thì AI agent sẽ tự động đọc states trong harness repo (ví dụ: `docs-harness` ở yêu cầu số 1)
    Nhóm yêu cầu 2: Khởi tạo structure
        Yêu cầu 2.1:
Requirement: Tạo folder "harness-improvements" trong docs-harness

Purpose: Những lần improve harness repo sẽ được audit trong folder này
Trigger: Khi intent của user là yêu cầu cải thiện harness repo hoặc user gọi skill `improve-harness`
        Yêu cầu 2.2:
Requirement: tạo folder "layers", và tạo sẵn folder "layer-1" trong folder layers trên

Purpose: nơi chứa những instructions theo kiến trúc layers sẽ được AI agent tự load vào context giống như có nhiều layers instruction cho AI agent trước khi có AI agent nhận task từ user hoặc user yêu cầu kiểm tra harness repo. Những instructions trong folder "layers" sẽ do người dùng định nghĩa sau vì vậy hãy tạo file `README.md` overview, rules về folder "layers" này

Yêu cầu 2.2.1: Các instructions trong folder "layers" có 1 dòng checklist như là 1 công tắt bật/tắt cho user xài để xem user có quyết định dùng instruction này hay không?
        Yêu cầu 2.3:
Requirement: tạo folder "harness-constraints" trong docs-harness

Purpose: nơi chứa những ràng buộc cho harness repo, bắt buộc AI agent phải tuân theo xiêng suốt trong 1 session.

Yêu cầu 2.3.1:  Các instructions trong folder "harness-constraints" có 1 dòng checklist như là 1 công tắt bật/tắt cho user xài để xem user có quyết định dùng instruction này hay không?
        Yêu cầu 2.4:
Requirement: tạo folder "templates" trong docs-harness

Purpose: nơi chứa những templates cho harness repo trước khi tạo 1 file .md.

Yêu cầu 2.4.1: trước khi tạo file AI agent phải kiểm tra xem đã có template sẵn hay chưa? nếu chưa thì phải hỏi user xem có muốn AI agent tạo giúp không? Thêm 1 custom input khi hỏi để cho user nhập custom template mong muốn
```

## Proposed Improvement

Add `.agents/skills/init-harness-repo/` with `SKILL.md` (steps: inspect target,
interview, scaffold, verify links, report) and a disclosed sibling
`scaffold.md` holding the generated file contents, so the step list stays
legible. Mirror both files into `.claude/skills/init-harness-repo/`.

## Scope

May change: the two skill folders above, this record, its INDEX
`[IMPROVE_HARNESS]` entry, and its `.gitignore` allow line.

Unchanged: this repository's own `AGENTS.md`, `layers/` model-matching
contract, `harness-constraints/`, templates, other skills, the TypeSafe skill
catalog (`suggest-skill.ps1` routes model-invoked skills; this one is
user-invoked), and the User's `GOAL.md`. No commit or push.

## Progress

- 2026-10-03: Goal interviewed via goal-griller; record created before skill
  edits.
- 2026-10-03: Skill v1 created (`SKILL.md`, `scaffold.md`) and mirrored;
  native checks passed. Replays A1 and B1 passed (see Decision and Result) but
  reported unclear instructions: when to ask about an existing root
  `AGENTS.md`; whether Q1/Q2/Q4 need invented alternatives; Q3 "no default"
  versus "recommended first"; "pick another name" cannot resolve an existing
  root `AGENTS.md`; "skip" leaves the scaffold unrouted; no report path after
  cancel; no git-ignore check (A1 found the User's global ignore hides
  `AGENTS.md` and `docs-harness`).
- 2026-10-03: Skill v2 revised `SKILL.md` steps 1, 2, 4 and 5: one shared
  question rule (recommended first, free text always, alternatives only with
  a repository reason); root `AGENTS.md` conflict asked in step 1 (keep and
  hand back merge text, or cancel); folder and path conflicts checked right
  after questions 1 and 4; `git check-ignore` added to step 4; cancel and
  merge-text paths added to the report. `scaffold.md` unchanged. Re-mirrored.
- 2026-10-03: Replays A2 and B2 against v2 passed; coordinator re-verified
  both fixtures independently. Record completed.

## Validation

- Native: frontmatter parses (name, description, `disable-model-invocation:
  true`); `.agents` and `.claude` copies are byte-identical (`diff` exit 0);
  INDEX links resolve; IDs unique.
- Fresh replay (native subagent, disposable empty git repository under the
  session scratchpad, User answers simulated):
  - Case A: defaults plus custom routing filename; every required file and
    folder exists, every routing link resolves, back-links reach the routing
    file and `AGENTS.md`, checklist rule present in `layers/` and
    `harness-constraints/` READMEs, four questions posed with defaults and a
    free-text option.
  - Case B: pre-existing `AGENTS.md`; the skill pauses and leaves the file
    byte-identical.

## Risks

- Scaffold drift from this repository's evolving Harness. Mitigation: the
  skill generates only the specification's minimal structure and states that
  further structure is added through templates and `improve-harness`.
- The generated `AGENTS.md` lacks this repository's task-authority policy.
  Mitigation: accepted assumption recorded above; a later improvement can add
  an optional authority section if the User asks.

## Decision and Result

Decision: **keep** (skill v2).

Native checks (2026-10-03): frontmatter has `name`, a one-line description
and `disable-model-invocation: true`; `.agents` and `.claude` copies are
byte-identical (`diff -r` exit 0, after v1 and after v2); every INDEX link
resolves; no duplicate `ID:` sequences; the new files are not git-ignored in
this repository.

Fresh replays (fresh native general-purpose subagents, worker role, jev-hook
consults allowed; disposable git repositories under the session scratchpad,
each seeded with a one-line TODO-app `README.md`; User answers scripted):

| Case | Skill | Fixture | Scripted answers | Observed result |
| --- | --- | --- | --- | --- |
| A1 | v1 | empty repo | defaults, goal free text, `ROUTES.md` | 7 files created; 18 links, 0 missing; 0 `{{`; toggle rule in both READMEs; README unchanged |
| B1 | v1 | existing `AGENTS.md` | defaults, conflict "Cancel" | paused at conflict; nothing written; `AGENTS.md` sha256 `f066f774…` unchanged |
| A2 | v2 | empty repo | as A1 | four questions posed recommended-first with free text, Q3 unranked; 7 files; 18 links, 0 missing; 0 `{{`; ignore check run |
| B2 | v2 | existing `AGENTS.md` | "Keep it", defaults, goal free text | asked in step 1 before the interview; 6 files under `docs-harness/`; 12 links, 0 missing; `AGENTS.md` sha256 unchanged; report included the generated `AGENTS.md` merge text |

The coordinator re-ran file listings, link resolution, placeholder search and
the `AGENTS.md` hash for A1, B1, A2 and B2 and matched each receipt.

Specification coverage: 1.1 and 1.4 note 1 (four questions with defaults and
free text) observed in A2 and B2; 1.2, 1.4 note 2, 2.1–2.4 and 2.2.1/2.3.1
(files, back-links, toggle rule) observed in A1, A2 and B2; 1.3, 1.5 and 2.4.1
are written into the generated `AGENTS.md` and `templates/README.md` but are
behaviours of later sessions in the target repository, not exercised here.

Limits and follow-up proposals (suggestions until authorized):

- Answers were scripted; no live User interaction was exercised. Proposal:
  run the skill once in a real new repository and record the result here.
- On this machine `C:\Users\DEV\.gitignore_global` ignores `AGENTS.md`
  (line 45) and `docs-harness` (line 43), so a scaffold in a new repository is
  untracked. v2 detects and reports it; it does not ask. Proposal: if the User
  wants it, step 4 could turn an ignored scaffold into a User question.
- With "Keep it", the route from `AGENTS.md` to the routing file stays one-way
  until the User merges the handed-back text. Proposal: state that explicitly
  in the step 5 report.
- `{{TO_ROOT}}` was exercised only with a one-segment harness folder.
- Replay workers ran some read-only commands before their first jev-hook
  consult, and A1 noted that `precheck-authority.ps1`'s regex fast path
  clears a chained command by its first word. Proposal: a separate
  improvement to split chained commands before the fast path.
