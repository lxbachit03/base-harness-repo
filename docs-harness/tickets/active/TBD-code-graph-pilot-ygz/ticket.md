---
ticket_id: TBD
title: Pilot code-graph trên YGZ-Microservices-Multitenancy
status: resolved
created: 2026-11-23
owner: User (lxbachit03)
source: User prompt, 2026-11-23
---

# Ticket: Pilot code-graph trên YGZ-Microservices-Multitenancy

## Original ticket

> tạo 1 ticket trong docs-harness/tickets/active. sau đó clone repo này:
> "https://github.com/lxbachit03/YGZ-Microservices-Multitenancy" vào trong ticket đó và
> chạy pilot. Hãy đánh giá có khả thi hay không trước khi chạy pilot

## Outcome and Scope

Chạy pilot của skill `code-graph`
(`.agents/skills/code-graph/references/pilot.md` (skill gỡ ngày 2026-11-23; nội dung ở commit `98a9842`)) trên repo
YGZ-Microservices-Multitenancy để quyết định giữ Graphify, đổi sang code-review-graph, hay
bỏ, theo quy tắc quyết định trong pilot. Kết quả ghi vào ticket này và vào bản ghi
[#094](../../../harness-improvements/1123-code-graph-skill.md).

Authority: User yêu cầu tạo ticket, clone repo và chạy pilot, sau khi đánh giá khả thi.
Pilot cài công cụ và tốn token; chỉ chạy sau khi User xác nhận các quyết định đang mở bên
dưới. Không sửa code của repo được pilot; không commit hay push gì vào repo đó.

## Context and Evidence

Đánh giá khả thi ngày 2026-11-23, trên bản shallow clone ở scratchpad (commit `b144931`,
2026-05-13), chỉ đọc, không chạy gì trong repo:

| Hạng mục | Quan sát | Đánh giá |
| :--- | :--- | :--- |
| Quy mô | 2.005 file; 943 `.cs` (59.385 dòng), 502 `.ts`/`.tsx` (76.884 dòng), 7 `.rs`; 23 `.csproj`; 360 MB trên đĩa (ảnh, SVG tới 20 MB, `.docx` 19 MB) | Vượt xa ngưỡng khoảng 100 file code: đủ lớn để đáng thử |
| Cấu trúc | `Services/` (Basket, BuildingBlocks, Catalog, Discount, Identity, Ordering), `apps/` (admin, client), `Gateways/`, `blockchain/`, `docs/` | Có quan hệ xuyên service và xuyên ngôn ngữ, đúng loại câu hỏi graph nhắm tới |
| Hỗ trợ ngôn ngữ | Graphify: khoảng 40 ngôn ngữ qua tree-sitter, có C# và TS; code-review-graph `2.4.0` (MIT): "C#, ... JavaScript/TypeScript/TSX" | Cả hai backend dùng được |
| Python | 3.14.7 (Graphify cần `>=3.11.5,<3.15`; code-review-graph `>=3.10`) | Đạt; rủi ro wheel tree-sitter cho 3.14 trên Windows chưa kiểm |
| Trình cài đặt | Không có `uv`, không có `pipx` | Dùng `python -m venv` riêng cho pilot, không cài toàn cục |
| Đo token | `claude` CLI `2.1.304` có `-p`, `--mcp-config`, `--strict-mcp-config`, `--output-format json` | Mỗi lượt chạy là một phiên mới, đo được token chính xác, gắn MCP theo từng nhánh |
| Bằng chứng ngược | Issue #985 của Graphify: một monorepo .NET tốn 1,6–1,9 lần token với câu trả lời kém hơn | Rủi ro thật cho repo C# này; đó cũng là điều pilot cần đo |

Kết luận: **khả thi**, với ba điều kiện ở phần Risks and Open Questions.

Không cần `apis.md` hay `entities.md`: ticket không đụng tới API hay schema của repo.

## Acceptance Criteria

- [x] Repo được clone vào vị trí User chọn, ghim commit.
- [x] Graphify (từ `0.9.115`) và code-review-graph `2.4.0` được cài trong venv riêng, graph
  code-only của cả hai được dựng; thời gian dựng và kích thước được ghi lại.
- [ ] 15–20 câu hỏi xuyên file, kèm file đáp án viết trước khi chạy (đợt 1: 5 câu, theo
  lựa chọn của User).
- [x] Ba nhánh (không graph, Graphify, code-review-graph) chạy cho mọi câu hỏi với cùng
  model và effort; ghi token, số tool call, thời gian, agent có tự gọi graph không, độ
  chính xác (đợt 1).
- [x] Quyết định keep / switch backend / drop theo quy tắc trong `pilot.md`, ghi vào ticket
  và #094 (drop, chờ User xác nhận phần dọn dẹp và Harness).
- [x] Dọn dẹp: gỡ venv và graph trừ khi quyết định là keep.

## Plan and Decisions

1. Chốt ba quyết định đang mở (vị trí clone, cách đo, ngân sách).
2. Clone ghim commit; tạo venv; cài hai backend; dựng graph code-only (kèm
   `.graphifyignore` loại `node_modules`, ảnh, `docs/`, `bin/`, `obj/`).
3. Viết câu hỏi và đáp án từ code.
4. Chạy ba nhánh bằng `agy -p` (thay `claude -p` vì CLI Claude chưa đăng nhập), mỗi lượt một
   phiên mới, `--mode plan`.
5. Tổng hợp, quyết định, dọn dẹp.

Lịch sử quyết định: [decision/README.md](decision/README.md).

## Implementation or Resolution

User chọn ngày 2026-11-23: clone ngoài repo harness, model Sonnet 5.5 effort medium, đợt 1
gồm 5 câu × 3 nhánh.

Đã làm (2026-11-23):
- Clone tại `E:\personal\pilots\YGZ-Microservices-Multitenancy`, ghim commit
  `b144931bfda55938676845ccfbb282b18b298a9c`. Git cần `-c safe.directory=...` vì ổ E: không
  ghi quyền sở hữu; không sửa cấu hình git toàn cục.
- Hai gói xung đột dependency nên cài trong hai venv: `E:\personal\pilots\venv-graphify`
  (`graphifyy[mcp]==0.9.115`) và `E:\personal\pilots\venv-crg` (`code-review-graph==2.4.0`),
  Python 3.14.7, Windows: cài được.
- `.graphifyignore` trong bản clone (node_modules, bin, obj, dist, build, .next, docs,
  public, ảnh, font, .docx, .plantuml, .min.js).
- Graphify `extract . --code-only`: 23 giây, 10.549 node, 26.760 cạnh, 445 community,
  `graph.json` 16,8 MB, không gọi LLM (chạy với các biến API key đã gỡ khỏi môi trường).
- code-review-graph `build`: 82 giây, 2.571 file, 63.840 node, 100.733 cạnh.
- Kiểm chứng: `graphify-mcp` nhận đường dẫn `graph.json` làm đối số vị trí (hoặc `--graph`);
  `graphify update <path>` là "re-extract code files ... (no LLM needed)";
  `code-review-graph serve --repo <path>` là MCP stdio.
- 5 câu hỏi kèm file đáp án, viết trước khi chạy:
  `E:\personal\pilots\results\questions.json`; cấu hình MCP từng nhánh cùng thư mục.

`claude -p` (CLI ở PATH `2.1.304` và binary của app `2.1.330`) trả
`Failed to authenticate: OAuth session expired and could not be refreshed`. User đồng ý
chuyển sang `agy` CLI (`1.5.14`, đã đăng nhập), giữ model `claude-sonnet-5-5-medium`
([decision](decision/11-23-pilot-measurement-method.md)).

Thiết lập đo bằng `agy`:
- Mỗi lượt: `agy -p "<câu hỏi> <hậu tố chung>" --model claude-sonnet-5-5-medium --mode plan
  --dangerously-skip-permissions --output-format stream-json`, một phiên mới, prompt giống
  nhau ở mọi nhánh và không nhắc tới graph.
- MCP theo nhánh qua `.agents/mcp_config.json` trong bản clone (baseline: không có file).
  `agy` nạp được MCP cấp workspace (lượt thử gọi `graph_stats` thành công ở cả hai server).
- Chế độ headless tự từ chối quyền `mcp`; `.agents/settings.json` với
  `permissions.allow: ["mcp(code-graph)"]` không có tác dụng, nên dùng
  `--dangerously-skip-permissions` cho cả ba nhánh; không sửa cấu hình toàn cục của User.
- Script và log: `E:\personal\pilots\results\run_pilot.sh`, `run-<q>-<nhánh>.jsonl`,
  `score.py`. Chấm độ chính xác bằng cách tìm đường dẫn hoặc tên file đáp án trong câu trả lời.

Kết quả đợt 1 (2026-11-23, 11:47–11:53, 15 lượt, đều `SUCCESS`):

| Nhánh | Lượt | Token vào+ra | Cache read | Tool call | Gọi graph | Giây | Độ chính xác |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Baseline | 5 | 125.772 | 293.836 | 15 | 0 | 102 | 100% |
| Graphify | 5 | 121.978 | 307.163 | 15 | 0 | 112 | 100% |
| code-review-graph | 5 | 118.678 | 325.240 | 16 | 0 | 113 | 100% |

| Câu | Baseline | Graphify | code-review-graph |
| :--- | ---: | ---: | ---: |
| q1 luồng checkout Basket → Ordering | 19.070 | 25.064 | 28.905 |
| q2 các file dùng `ITenantHttpContext` (13 file) | 24.287 | 24.472 | 29.207 |
| q3 Basket gọi gRPC Discount (5 file, 2 RPC) | 36.332 | 35.091 | 25.095 |
| q4 tenant header requirement | 17.576 | 17.923 | 17.902 |
| q5 hook product của app admin | 28.507 | 19.428 | 17.569 |

(Token vào+ra mỗi lượt; mọi lượt đều trả đủ file đáp án.)

Nhận xét:
- **Agent không lần nào gọi graph** dù server có sẵn: cả 15 lượt chỉ dùng `run_command`
  (tìm bằng shell) 2–4 lần và trả đủ file đáp án.
- Chênh lệch token giữa các nhánh (−3% với Graphify, −6% với code-review-graph so với
  baseline) nằm trong dao động giữa các câu, không phải hiệu quả của graph, vì graph không
  được gọi; phần cache read của nhánh graph cao hơn (schema MCP thêm vào context).
- 5 câu đều tìm được bằng tên định danh rõ ràng; với câu hỏi kiểu này, shell search trên
  repo khoảng 136 nghìn dòng đã rẻ và chính xác.

Theo quy tắc của `pilot.md` (giữ khi tiết kiệm ít nhất 30% token và agent tự gọi graph):
**không nhánh graph nào đạt**; với host `agy` và cách dùng không nhắc, kết quả là **drop**.
Đề xuất trước khi chốt: một đợt 2 có nhắc, dùng đúng câu của project constraint trong
`setup.md` ("use the `code-graph` skill before reading many files"), vì đó là cách tích hợp
thật; xem Risks and Open Questions.

Kết quả đợt 2 (2026-11-23, 11:58–12:03, User yêu cầu "Chạy đợt 2"): cùng 5 câu, hai nhánh
graph, prompt thêm câu constraint ("This project has a local code-only code graph served by
the code-graph MCP server. For questions that cross files, query the code graph before
reading many files, and read every file it names before claiming anything about it.").
Script: `E:\personal\pilots\results\run_pilot2.sh`, log `run2-<q>-<nhánh>.jsonl`.

- q5 ở cả hai nhánh lỗi `RESOURCE_EXHAUSTED (code 429): Third-party quota reached ...
  Resets in 4h41m` (quota model bên thứ ba của `agy`), nên so sánh dùng q1–q4.
- Khi được nhắc, agent có dùng graph: Graphify 9 lần gọi (`query_graph`, `get_neighbors`),
  code-review-graph 7 lần (`semantic_search_nodes_tool`, `query_graph_tool`, 1 lỗi), nhưng
  vẫn đọc file và tìm bằng shell sau đó.

So sánh trên q1–q4 (mọi nhánh đúng 4/4 câu, đủ file đáp án):

| Nhánh | Token vào+ra | So với baseline | Giây |
| :--- | ---: | ---: | ---: |
| Baseline (đợt 1) | 97.265 | — | 84 |
| Graphify, không nhắc (đợt 1) | 102.550 | +5% | 97 |
| code-review-graph, không nhắc (đợt 1) | 101.109 | +4% | 94 |
| Graphify, có nhắc (đợt 2) | 195.676 | **+101%** | 134 |
| code-review-graph, có nhắc (đợt 2) | 163.909 | **+69%** | 106 |

Theo quy tắc của `pilot.md`: không backend nào tiết kiệm được 30% token, cả khi không nhắc
lẫn khi có nhắc; khi được dùng, graph làm tốn thêm 69–101% token mà không tăng độ chính
xác. Kết quả khớp với issue #985 của Graphify (một monorepo .NET tốn 1,6–1,9 lần). Đề xuất
quyết định: **drop** cho repo này, host `agy` và loại câu hỏi này
([decision](decision/11-23-pilot-outcome.md)).

User chấp nhận drop và yêu cầu dọn dẹp (2026-11-23, "Chấp nhận, dọn dẹp"). Đã xoá: hai venv
(`venv-graphify`, `venv-crg`, khoảng 2,5 GB), bản clone (khoảng 1,1 GB, gồm `graphify-out/`,
`.code-review-graph/`, `.agents/`, `.graphifyignore`), thư mục trống `~/.code-review-graph/` và
cache schema MCP `~/.gemini/antigravity-cli/mcp/code-graph/` do pilot tạo, cùng bản shallow clone
đánh giá trong scratchpad. Giữ lại `E:\personal\pilots\results` (log, script, câu hỏi, 4,8 MB)
làm bằng chứng. Sau đó User chọn gỡ skill `code-graph` khỏi Harness ("Gỡ skill", 2026-11-23; #094).

## Validation

Đã chạy: đánh giá khả thi; clone, cài hai backend, dựng hai graph; thử `claude -p` (lỗi
đăng nhập); hai lượt thử MCP bằng `agy`; 15 lượt đợt 1 và chấm điểm (số liệu ở trên); bản
clone sau pilot chỉ thêm `.graphifyignore` và `graphify-out/` (không sửa file nào của repo).

Chưa chạy: đợt 2 có nhắc; 10–15 câu còn lại của `pilot.md`; câu hỏi khó tìm bằng grep (ảnh
hưởng gián tiếp nhiều tầng); host khác (Claude Code, Codex, OpenCode). Chấm độ chính xác
bằng so khớp tên file là cách chấm lỏng; chưa chấm tay phần giải thích.

## Risks and Open Questions

| Rủi ro hoặc câu hỏi | Đề xuất |
| :--- | :--- |
| **Clone vào trong ticket làm hỏng kiểm tra harness.** `harness_check` quét mọi thư mục dưới `docs-harness/` (chỉ bỏ `.git`, `node_modules`): mỗi thư mục của repo clone sẽ báo lệch `folder-tree` và `folder-readmes`, link Markdown của nó bị kiểm. `.gitignore` đặt `!*` (#046) nên không thể bỏ qua; `git add` thư mục cha sẽ ghi repo lồng thành gitlink. | Clone ra ngoài repo harness (ví dụ `E:\personal\pilots\YGZ-Microservices-Multitenancy`) và liên kết từ ticket, đúng quy tắc "link it rather than copying" của tickets/README.md. Phương án khác: clone vào ticket và thêm ngoại lệ cho thư mục đó vào `harness_check` (sửa Harness, cần `improve-harness`). Xem [decision](decision/11-23-pilot-workspace-location.md). |
| **Cách đo.** pilot.md giả định một host có MCP; subagent của phiên Desktop không nhận MCP server mới. | Dùng `claude -p --mcp-config <file> --strict-mcp-config --output-format json` cho mỗi lượt, với `--allowedTools` chỉ gồm tool đọc và tool MCP của nhánh. Xem [decision](decision/11-23-pilot-measurement-method.md). |
| **Ngân sách token.** 15–20 câu hỏi × 3 nhánh = 45–60 phiên; ước khoảng 30–150 nghìn token mỗi phiên (ước lượng, chưa đo), tức vài triệu token trên quota của User. | Chạy đợt 1 với 5 câu × 3 nhánh để đo chi phí thật, rồi User quyết định chạy đủ. |
| Wheel tree-sitter cho Python 3.14 trên Windows có thể chưa có. | Thử cài trong venv trước; nếu lỗi, báo và đề xuất Python 3.12/3.13. |
| Repo có file Markdown và ảnh lớn. | `.graphifyignore` loại chúng; chế độ code-only bỏ qua tài liệu. |
| **Đợt 1 không nhắc agent dùng graph**, nên chỉ đo việc agent tự chọn graph (không lần nào). Cách tích hợp thật có project constraint bảo agent dùng `code-graph` trước. | Đợt 2: cùng 5 câu, hai nhánh graph thêm câu constraint của `setup.md` vào prompt, để đo graph có tiết kiệm khi được dùng hay không; khoảng 10 lượt, cần User đồng ý. Nếu vẫn không đạt ngưỡng 30%, chốt drop và gỡ venv, graph. |
| Câu hỏi đợt 1 đều tìm được bằng tên định danh. | Đợt 2 có thể thêm 2–3 câu về ảnh hưởng gián tiếp nhiều tầng, nơi graph có lợi thế lý thuyết. |

## Artifacts

None yet. Bản clone đánh giá ở scratchpad của phiên (tạm, ngoài repo).
