# Purposes

## Definition

- `docs-harness` folder: tôi hay gọi là "harness repo" => Nơi định nghĩa/cung cấp context/cách làm việc giữa user và AI agent xoay quanh repo hiện tại

## Những resources AI cần phải load từ harness repo

- **Tự động load vào đầu mỗi phiên (Session Start) để nắm bắt bối cảnh hiện tại:**
  - `AGENTS.md`
  - `docs-harness/INDEX.md`
  - `docs-harness/PERSONA.md`
  - `docs-harness/tickets/active/*.md`
  - `docs-harness/plans/active/*.md`
  - `docs-harness/risks/**/*.md`

- **Load theo nhu cầu qua Top-Down Routing (chỉ đọc khi intent yêu cầu):**
  - `docs-harness/WORKFLOW.md`
  - `docs-harness/onboarding/README.md` (chỉ load `docs-harness/onboarding/<flow>/` khi làm việc với luồng đó)
  - `docs-harness/domain/**/*.md`
  - `docs-harness/plans/README.md`
  - `docs-harness/tickets/README.md`
  - `docs-harness/harness-constraints/**/*.md`
  - `docs-harness/harness-improvements/**/*.md`

## Tiết kiệm Tokens

- Phương pháp Top-Down Approach => KHÔNG tự động load toàn bộ

- INDEX.md => routing đúng folders/files cần đọc

- Dùng đúng tool (.agents/validators/*.py,...)
-> Ưu điểm: STRICT => đúng format khi validate bằng tool
-> Nhược điểm: không validate về ngữ nghĩa => việc này AI agent sẽ validate

- AI agent không được tự load `docs-harness/tickets/completed/*.md` => tránh làm loãng context

- AI agent không được tự load `docs-harness/plans/completed/*.md` => tránh làm loãng context

- AI agent không được tự load `docs-harness/proposals/*.md` => tránh làm loãng context

=> Hạn chế loãng window context => Tiết kiệm Tokens

- Kiểm tra và đồng bộ tính toàn vẹn giữa cấu trúc Filesystem thực tế và INDEX.md vào đầu mỗi phiên (Session Start) để tránh đứt gãy routing.

- Chỉ load nhiều resources theo phương pháp Bottom-Up chỉ khi có user authority - yêu cầu (được user cho phép) ví dụ khi user yêu cầu deep dive,...

## Hardening

- Skill `.agents/skills/improve-harness`: Tăng tính cá nhân hoá của AI và harness repo từ intent của user

## Quản lý Persona & Giọng văn (Response Style)

- `docs-harness/PERSONA.md`: Định nghĩa phong cách phản hồi của AI Agent dưới dạng Todo checklist `- [x]`.
- AI Agent tự động đọc file này ở đầu mỗi session để áp dụng giọng văn tương ứng trong hội thoại (không áp dụng giọng văn này vào nội dung file code).

## Quản lý tickets

- AI agent không được tự load `docs-harness/tickets/completed/*.md` => tránh làm loãng context
- AI agent tự động load `docs-harness/tickets/active/*.md` => để aware các tickets hiện tại (dễ load vào context để AI agent có nhiều info hơn)

## Quản lý plans

- AI agent không được tự load `docs-harness/plans/completed/*.md` => tránh làm loãng context
- AI agent tự động load `docs-harness/plans/active/*.md` => để aware các plans hiện tại (dễ load vào context để AI agent có nhiều info hơn)

## Quản lý Risks/Proposals

- AI agent không được tự load `docs-harness/proposals/*.md` => tránh làm loãng context
- AI agent tự động load `docs-harness/risks/*.md` => để aware các risk hiện tại (dễ load vào context để AI agent có nhiều info hơn)

## Đồng bộ filesystem trong `docs-harness` và `INDEX.md`

- Kiểm tra và đồng bộ tính toàn vẹn giữa cấu trúc Filesystem thực tế và INDEX.md vào đầu mỗi phiên (Session Start) để tránh đứt gãy routing.

## Onboarding Dự Án Brownfield (`docs-harness/onboarding/`)

- Skill `.agents/skills/onboarding`: Chuyên dùng để phân tích và mapping các dự án brownfield phức tạp thành từng luồng dữ liệu/nghiệp vụ độc lập (`docs-harness/onboarding/<flow-name>/`).
- **Quy tắc Top-Down**: Chỉ nạp thư mục con của luồng dữ liệu đang làm việc (`docs-harness/onboarding/<target-flow>/`), tuyệt đối không nạp toàn bộ thư mục cha ở Session Start.
- **Quy tắc User Authority**: AI Agent **tuyệt đối không tự ý** chuyển đổi hoặc tạo file trong `docs-harness/domain/` từ `onboarding/` nếu không có User Authority. Việc chuyển đổi chỉ diễn ra khi người dùng tự kéo/chuyển file hoặc ra lệnh trực tiếp cho AI Agent thực hiện.
- **Xây dựng Domain Knowledge**: Khi có sự đồng ý của User, các kết quả khảo sát từ `onboarding/` được dùng làm nguồn tư liệu để tổng hợp kiến thức nghiệp vụ chuẩn hóa vào `docs-harness/domain/`.

## Tối Ưu Khai Thác Tools, MCPs & Skills (`utilizing-tools-agy`)

- Skill `.agents/skills/utilizing-tools-agy`: Thay thế câu prompt dài dòng, tự động phân tích bài toán và lựa chọn bộ công cụ tối ưu nhất (Core Tools, MCP Plugins, Subagents, Skills).
- **Ràng buộc bảng công cụ (Response Contract)**: Bắt buộc khai báo bảng `Selected Tools & MCPs` ngay đầu phản hồi trước khi thực thi liền mạch.
- **Cẩm nang tra cứu Antigravity Tools**: Xem chi tiết tại [`docs/tools/antigravity/README.md`](docs/tools/antigravity/README.md).

## Tài Liệu Đúc Kết Kinh Nghiệm & Quy Trình (`docs/`)

- Thư mục `docs/` là tài liệu tham khảo cho team (Team-Facing Documentation, không tự động load vào AI Agent context):
  - [`docs/AI_PROBLEMS.md`](docs/AI_PROBLEMS.md): Phân tích 9 vấn đề phổ biến của AI Agents và giải pháp kiến trúc khắc phục.
  - [`docs/WORKFLOWS.md`](docs/WORKFLOWS.md): So sánh 5 trường phái Agentic Workflows (Prompt, Loop, Graph, RAG, Harness Engineering).
  - [`docs/tools/antigravity/README.md`](docs/tools/antigravity/README.md): Cẩm nang toàn diện về Tools, MCPs, Plugins và Skills của Google Antigravity.
