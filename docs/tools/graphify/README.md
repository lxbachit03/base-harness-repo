# Cẩm Nang Graphify Cho Project Có Codebase Lớn

> **Tài liệu tham khảo kỹ thuật cho nhóm phát triển (Team-Facing Documentation)**
> *Vị trí lưu trữ*: `docs/tools/graphify/README.md`
> *Phạm vi*: Graphify `0.9.115` (PyPI `graphifyy`), đọc từ repo và tài liệu ngày
> 2026-11-23, và pilot cùng ngày trên một repo C#/TS khoảng 1.445 file code. Skill
> `code-graph` dựa trên tài liệu này đã bị gỡ sau pilot (#094). Nghiên cứu nền:
> [Đánh giá dự án Graphify](../../../R&D/graphify-research/reports/Đánh%20giá%20dự%20án%20Graphify.md).

Graphify dựng knowledge graph cho một repo. Harness chỉ dùng **một phần** của nó: graph
code dựng tại máy bằng tree-sitter (`--code-only`), phục vụ agent qua MCP server cục bộ,
cho các project áp dụng harness mà có codebase lớn. Repo harness này không phải đối tượng:
gần như toàn Markdown, nên code-only không thấy gì, còn bước tài liệu thì tốn token và gửi
nội dung tới model.

> [!IMPORTANT]
> **Kết quả pilot 2026-11-23: không dùng.** Trên YGZ-Microservices-Multitenancy (C# và TS,
> khoảng 136 nghìn dòng), host `agy` với Sonnet 5.5: khi không nhắc, agent không lần nào gọi
> graph; khi được nhắc, Graphify tốn thêm 101% và code-review-graph thêm 69% token so với tìm
> bằng shell, cùng độ chính xác. Chi tiết:
> [ticket pilot](../../../docs-harness/tickets/active/TBD-code-graph-pilot-ygz/ticket.md).
> Tài liệu dưới đây giữ lại làm tham khảo nếu đánh giá lại (câu hỏi nhiều tầng, host khác).

---

## 1. Cách Harness Dùng Graphify

| Nguyên tắc | Lý do |
| :--- | :--- |
| Chỉ `--code-only` | Không LLM, không token, code không rời máy, kết quả tất định. |
| Chỉ MCP cục bộ (`graphify-mcp`, stdio) | Cả Claude Code, Codex, OpenCode và Antigravity gọi được như nhau; không dùng `api.graphify.com/mcp` (Graphify Cloud). |
| Không chạy `graphify install`, `graphify <platform> install`, `graphify hook install` | Chúng ghi `AGENTS.md`, file rules và hook; hook chỉ có trên Claude Code và Gemini CLI. Harness quản lý chỉ dẫn qua project constraint. |
| Graph là gợi ý | Agent đọc file thật trước khi kết luận hoặc sửa; graph cũ thì dùng grep. |
| Cài đặt cần authority | Cài backend là cài dependency, cần User cho phép riêng ([#009](../../../docs-harness/harness-constraints/0822-user-authority-operation-gate.md)). Hai gói xung đột dependency: cài trong hai môi trường riêng (pilot). |
| Backend trung lập | code-review-graph (MIT) là phương án so sánh; GitNexus bị loại vì giấy phép không cho dùng thương mại. |

## 2. Lệnh Liên Quan

Theo README của Graphify `0.9.115`; cú pháp chính xác lấy từ `--help` của binary đã cài.

| Lệnh | Tác dụng | Loại |
| :--- | :--- | :--- |
| `uv tool install "graphifyy[mcp]==<version>"` | Cài CLI và MCP server, ghim phiên bản (từ `0.9.115`). | Cài dependency |
| `graphify extract . --code-only` | Dựng graph code; incremental nhờ cache SHA256; thêm `--force` sau khi cache schema đổi. | Ghi `graphify-out/` |
| `graphify update .` | Cập nhật incremental; chưa rõ có giữ code-only hay không, kiểm tra trong pilot. | Ghi `graphify-out/` |
| `graphify query "<câu hỏi>"`, `graphify path A B`, `graphify explain X` | Truy vấn; exit code 0 có kết quả, 3 tên mơ hồ, 4 không khớp. | Chỉ đọc |
| `graphify affected` | Phân tích ảnh hưởng của thay đổi (cú pháp theo `--help`). | Chỉ đọc |
| `graphify-mcp` | MCP server stdio; tool `query_graph`, `get_node`, `get_neighbors`, `get_community`, `shortest_path`, `god_nodes`, `graph_stats`, `get_section`. | Chỉ đọc |

Đầu ra nằm trong `graphify-out/`: `graph.json`, `graph.html`, `GRAPH_REPORT.md` và
`cache/`. Cấu hình: `.graphifyignore` (cùng `.gitignore`), `.graphifyrc`, biến
`GRAPHIFY_QUERY_LOG_DISABLE=1` để tắt log truy vấn cục bộ ở
`~/.cache/graphify-queries.log`.

## 3. Cấu Hình MCP Theo Host

Đặt tên server là `code-graph`; tham số trỏ tới graph lấy từ `graphify-mcp --help`.

| Host | File cấp project | Ghi chú |
| :--- | :--- | :--- |
| Claude Code | `.mcp.json`, key `mcpServers` | Xem [cẩm nang Claude Code](../claude/README.md) mục 4. |
| OpenCode | `opencode.json`, key `mcp`, `"type": "local"` | Xem [cẩm nang OpenCode](../opencode/README.md). |
| Antigravity | `.agents/mcp_config.json`, stdio `command`/`args` | Xem [cẩm nang Antigravity](../antigravity/README.md) mục 3.1. |
| Codex | `.codex/config.toml` hoặc `~/.codex/config.toml`, bảng `[mcp_servers.code-graph]` | Cú pháp chưa được kiểm chứng trong harness này. |

## 4. Rủi Ro

| Rủi ro | Cách giảm |
| :--- | :--- |
| Graph cũ dẫn agent sai | So `graphify-out/BUILT_FROM` với `HEAD` trước khi dùng; dựng lại sau pull/merge hoặc trong CI. |
| Dự án trước 1.0, gần như ngày nào cũng phát hành, có thay đổi phá vỡ | Ghim phiên bản; nâng cấp có kiểm soát; `--force` sau khi đổi cache schema. |
| Hai advisory mức high (Fortran đọc file máy chủ; rò credential Windows qua SMB, sửa ở `0.9.115`) | Dùng từ `0.9.115`; theo dõi GitHub Security Advisories của repo. |
| Tên gói dễ bị giả mạo | Đúng `graphifyy` (hai chữ y); cài bằng `uv`, ghim phiên bản. |
| Phụ thuộc một công ty một người (YC S26, khoảng 42% commit từ một tài khoản) | Skill trung lập backend; code-review-graph làm dự phòng. |
| Lỡ gửi code ra ngoài | Chỉ `--code-only`, không MCP hosted, tắt query log. |

## 5. Nguồn

| Hạng mục | Nguồn | Trạng thái |
| :--- | :--- | :--- |
| Lệnh, MCP tool, cấu hình, giới hạn | README, ARCHITECTURE và `pyproject.toml` của Graphify nhánh `v8`, commit `a3db62f`, 2026-11-23 | [DOCS] chưa chạy thử |
| Hiệu quả token | Benchmark của nhà phát triển; phép thử độc lập 360 lần chạy (2026-10-16); issue #985; code-review-graph; pilot 2026-11-23 của harness | Pilot: tốn thêm 69–101% khi dùng |
| Cấu hình MCP của Claude Code, OpenCode, Antigravity | Các cẩm nang trong `docs/tools/` | [DOCS] theo từng cẩm nang |
| Cấu hình MCP của Codex | Chưa có trong cẩm nang Codex | [UNKNOWN] |
