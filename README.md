# Base Harness Repository

`docs-harness/` là context của repo dành cho AI agent: nguồn bằng chứng, quy tắc
làm việc, kế hoạch, ticket và kiến thức domain. Bắt đầu từ
[AGENTS.md](AGENTS.md), rồi [INDEX.md](docs-harness/INDEX.md).

## Nguồn quy tắc

| Nội dung | Nguồn chính |
| --- | --- |
| Quyền theo task; phạm vi local/external | [AGENTS.md](AGENTS.md) |
| Nạp context liên quan và routing | [INDEX.md](docs-harness/INDEX.md) |
| Thực thi và bằng chứng hoàn tất | [WORKFLOW.md](docs-harness/WORKFLOW.md) |
| Kế hoạch qua nhiều phiên | [plans/README.md](docs-harness/plans/README.md) |
| Domain capture, confirmation, freshness | [domain/README.md](docs-harness/domain/README.md) |
| Ticket và artifact theo nhu cầu | [tickets/README.md](docs-harness/tickets/README.md) |
| Template, ID và metadata | [templates/README.md](docs-harness/templates/README.md) |
| Kiểm tra cấu trúc | [validator guide](.agents/validators/README.md) |

Ở đầu phiên, agent đọc persona và thông tin định danh/trạng thái của công việc
đang mở, sau đó chỉ nạp nội dung liên quan. Quyền đã cấp được giữ trong task;
yêu cầu triển khai bao gồm sửa cục bộ và kiểm tra phù hợp. Review vẫn chỉ đọc.
Deploy, thao tác dữ liệu thật, external writes và commit/push có ranh giới riêng
theo AGENTS.md.

Một ticket nhỏ chỉ cần ticket.md; inventory và manifest có khi cần. Onboarding
tạo bằng chứng theo từng flow và có thể tổng hợp domain UNCERTAIN. Việc xác nhận
thành CONFIRMED vẫn thuộc User.

`docs/` chứa tài liệu team. Agent có thể đọc nguồn liên quan đến task qua
routing hoặc dependency; không tự bootstrap tài liệu team.

## Skills và kiểm tra

Các skill nằm trong `.agents/skills/`. Chỉ dùng workflow phù hợp; goal shaping,
ticket intake, strict onboarding audit và tool selection không phải bước bắt
buộc của mọi task. Cải tiến Harness cần một yêu cầu có phạm vi và bằng chứng.

Chạy `node .agents/validators/sync-harness-index.js --check` để kiểm tra cấu trúc.
Kết quả pass không thay thế đánh giá ý nghĩa quy tắc hoặc replay hành vi agent.

Global Git excludes có thể chứa `docs-harness/` để giữ context cá nhân khỏi
consumer repo. Quy tắc ignore không untrack các file đã được quản lý trong base
repo này. Kiểm tra Git khi cần lưu resource mới; không tự force-add hoặc commit.
