# Ticket Decision: Kết quả pilot code-graph

- Date: 2026-11-23
- Status: accepted
- Decision-maker or authority: quy tắc quyết định trong
  `.agents/skills/code-graph/references/pilot.md` (skill gỡ ngày 2026-11-23; nội dung ở commit `98a9842`) bước 3; User xác
  nhận việc dọn dẹp và thay đổi Harness đi kèm
- Source and evidence: [ticket.md](../ticket.md#implementation-or-resolution) (bảng đợt 1 và
  đợt 2); log `E:\personal\pilots\results\run-*.jsonl`, `run2-*.jsonl`, `score.py`

## Context

Đợt 1 (15 lượt, không nhắc) và đợt 2 (10 lượt, có câu constraint) trên
YGZ-Microservices-Multitenancy, host `agy` `1.5.14`, model `claude-sonnet-5-5-medium`.

## Decision

Đề xuất: **drop** cả Graphify lẫn code-review-graph cho repo này. Không nhánh nào tiết kiệm
được 30% token; khi được dùng, graph tốn thêm 69% (code-review-graph) và 101% (Graphify)
token so với baseline, cùng độ chính xác 100% trên q1–q4.

## Rationale and Alternatives

- Keep Graphify hoặc switch sang code-review-graph: không đạt ngưỡng của pilot.md.
- Chạy thêm câu hỏi ảnh hưởng gián tiếp nhiều tầng, hoặc host khác: có thể cho kết quả khác,
  nhưng hai đợt và issue #985 cùng một chiều; chỉ đáng làm nếu có câu hỏi cụ thể mà shell
  search không trả lời được.

## Consequences and Follow-Up

(1) Dọn dẹp: đã làm sau khi User chấp nhận (venv, bản clone, graph, cache công cụ); log giữ ở
`E:/personal/pilots/results`. (2) Skill `code-graph`: User chọn gỡ khỏi Harness ("Gỡ skill", 2026-11-23), thực hiện qua
`improve-harness` trong #094.

## History

2026-11-23: proposed sau đợt 2. 2026-11-23: User chấp nhận drop và dọn dẹp ("Chấp nhận, dọn dẹp"); dọn dẹp đã thực hiện, xem ticket.md. Phần (2): User chọn gỡ skill `code-graph` ("Gỡ skill"); đã gỡ trong #094.
