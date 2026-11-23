# Ticket Decision: Nơi clone repo được pilot

- Date: 2026-11-23
- Status: accepted
- Decision-maker or authority: User (chọn "Ngoài repo", 2026-11-23); đề xuất của agent
- Source and evidence: yêu cầu của User trong [ticket.md](../ticket.md#original-ticket);
  `SKIPPED_DIRS` và vòng `os.walk` trong `.agents/skills/harness-check/scripts/harness_check.py`;
  `.gitignore` (`!*`, quyết định #046); quy tắc "link it rather than copying" trong
  [tickets/README.md](../../../README.md#proportional-artifacts).

## Context

User yêu cầu clone repo vào trong ticket. Ticket nằm dưới `docs-harness/`, nơi
`harness_check` yêu cầu mọi thư mục có trong Folder Tree của INDEX và có README, và kiểm
mọi link Markdown. Repo clone có hàng trăm thư mục và 34 file Markdown. `.gitignore` của
repo harness không bỏ qua file nào.

## Decision

Đề xuất: clone ra ngoài repo harness, ví dụ `E:\personal\pilots\YGZ-Microservices-Multitenancy`,
ghim commit, và liên kết đường dẫn từ ticket.md. Đây là đề xuất, chưa được User chấp nhận.

## Rationale and Alternatives

- Ngoài repo: harness_check giữ sạch, không có gitlink lỡ tay, khớp quy tắc ticket.
- Trong ticket như User yêu cầu: harness_check báo lệch ở hàng trăm thư mục cho tới khi xoá
  clone; `git add -A` sẽ ghi gitlink.
- Trong ticket kèm ngoại lệ trong harness_check: sửa Harness, cần `improve-harness` và một
  quy tắc mới cho thư mục kiểu "workspace".

## Consequences and Follow-Up

Đã áp dụng: ticket.md liên kết tới bản clone ngoài repo; harness_check giữ sạch.

## History

2026-11-23: proposed. 2026-11-23: accepted by the User ("Ngoài repo"); clone at `E:\personal\pilots\YGZ-Microservices-Multitenancy`.
