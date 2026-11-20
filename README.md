# Base Harness Repository

`docs-harness/` là context của repo dành cho AI agent: nguồn bằng chứng, quy tắc
làm việc, kế hoạch, ticket và kiến thức domain. Bắt đầu từ
[AGENTS.md](AGENTS.md), rồi [INDEX.md](docs-harness/INDEX.md).

## Nguồn quy tắc

| Nội dung | Nguồn chính |
| --- | --- |
| Vai trò phiên và quyền theo task | [0822-user-authority-operation-gate.md](docs-harness/harness-constraints/0822-user-authority-operation-gate.md) và [1120-session-role-and-judgment.md](docs-harness/harness-constraints/1120-session-role-and-judgment.md) |
| Nạp context liên quan và routing | [INDEX.md](docs-harness/INDEX.md) |
| Quy tắc của project, đọc ở mỗi phiên | [project-constraints/README.md](docs-harness/project-constraints/README.md) |
| Thực thi và bằng chứng hoàn tất | [1120-work-shape-proof-completion.md](docs-harness/harness-constraints/1120-work-shape-proof-completion.md) |
| Kế hoạch qua nhiều phiên | [plans/README.md](docs-harness/plans/README.md) |
| Domain capture, confirmation, freshness | [domain/README.md](docs-harness/domain/README.md) |
| Ticket và artifact theo nhu cầu | [tickets/README.md](docs-harness/tickets/README.md) |
| Template, ID và metadata | [templates/README.md](docs-harness/templates/README.md) |
| Tự kiểm tra Harness | [1120-work-shape-proof-completion.md](docs-harness/harness-constraints/1120-work-shape-proof-completion.md) |

Ở đầu phiên, agent đọc hai constraint task authority và session role, project constraints, persona và thông tin
định danh/trạng thái của công việc đang mở, sau đó chỉ nạp nội dung liên quan.
Quyền đã cấp được giữ trong task; yêu cầu triển khai bao gồm sửa cục bộ và kiểm
tra phù hợp, trong giới hạn của project constraints. Review vẫn chỉ đọc.
Deploy, thao tác dữ liệu thật, external writes và commit/push có ranh giới riêng
theo `0822-user-authority-operation-gate.md`.

Mỗi ticket có ticket.md và thư mục decision/; inventory và manifest có khi cần. Onboarding
tạo bằng chứng theo từng flow và có thể tổng hợp domain UNCERTAIN. Việc xác nhận
thành CONFIRMED vẫn thuộc User.

`docs/` chứa tài liệu team. Agent có thể đọc nguồn liên quan đến task qua
routing hoặc dependency; không tự bootstrap tài liệu team.

## Skills và kiểm tra

Phiên chính mặc định là Bale, giữ model hiện tại và tự làm việc nhỏ. Worker
có vai trò riêng từ lúc khởi chạy, thực hiện phạm vi được giao và trả bằng
chứng cho coordinator theo `docs-harness/harness-constraints/1120-session-role-and-judgment.md`.

Các skill nằm trong `.agents/skills/`. Chỉ dùng workflow phù hợp; goal shaping,
ticket intake và tool selection không phải bước bắt
buộc của mọi task. Cải tiến Harness cần một yêu cầu có phạm vi và bằng chứng.

Agent tự kiểm tra cấu trúc, route, metadata, link và diff theo `docs-harness/harness-constraints/1120-work-shape-proof-completion.md`; bằng chứng hành vi vẫn phải được báo cáo riêng khi
có thể thực hiện.

Global Git excludes có thể chứa `docs-harness/` để giữ context cá nhân khỏi
consumer repo. Quy tắc ignore không untrack các file đã được quản lý trong base
repo này. Kiểm tra Git khi cần lưu resource mới; không tự force-add hoặc commit.
