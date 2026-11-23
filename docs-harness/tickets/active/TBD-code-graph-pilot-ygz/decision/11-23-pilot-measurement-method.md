# Ticket Decision: Cách chạy và đo ba nhánh pilot

- Date: 2026-11-23
- Status: accepted (biến thể `agy`)
- Decision-maker or authority: User (đồng ý dùng `agy`, Sonnet 5.5 medium, đợt 1, 2026-11-23); đề xuất của agent
- Source and evidence: `.agents/skills/code-graph/references/pilot.md` (skill gỡ ngày 2026-11-23; nội dung ở commit `98a9842`)
  bước 2; `claude --help` của CLI `2.1.304` (cờ `-p`, `--mcp-config`, `--strict-mcp-config`,
  `--output-format`, `--allowedTools`, `--model`, `--effort`), kiểm ngày 2026-11-23.

## Context

pilot.md yêu cầu mỗi câu hỏi chạy trong một phiên agent mới, cùng model và effort, ở ba
nhánh. Subagent của phiên Claude Desktop hiện tại không nhận MCP server mới, nên không đo
được nhánh có graph theo cách đó.

## Decision

Đề xuất: mỗi lượt chạy `claude -p "<câu hỏi>"` trong thư mục repo được pilot, với
`--output-format json` (lấy token và số lượt), cùng `--model` và `--effort` cho mọi lượt,
`--allowedTools` chỉ gồm `Read`, `Grep`, `Glob` và tool MCP của nhánh, và
`--mcp-config <file> --strict-mcp-config` để nhánh baseline không có MCP, mỗi nhánh graph
chỉ có đúng server của nó. Đợt 1: 5 câu × 3 nhánh để đo chi phí thật.

## Rationale and Alternatives

- `claude -p`: phiên mới thật, đo token chính xác, gắn MCP theo nhánh, chạy được nền.
- Mở 45–60 phiên Desktop: mỗi phiên phải duyệt MCP server, khó đo token.
- Subagent gọi CLI `graphify query` qua Bash: rẻ nhưng không đo đường MCP mà skill dùng.

## Consequences and Follow-Up

Tốn quota Antigravity của User. Đợt 1 đã chạy; kết quả trong ticket.md.

## History

2026-11-23: proposed. 2026-11-23: `claude -p` bị chặn vì CLI chưa đăng nhập; User đồng ý dùng `agy` CLI ("đồng ý"). Biến thể áp dụng: `agy -p ... --model claude-sonnet-5-5-medium --mode plan --dangerously-skip-permissions --output-format stream-json`, MCP theo nhánh qua `.agents/mcp_config.json` trong bản clone, token lấy từ `usage` của sự kiện `result`.
