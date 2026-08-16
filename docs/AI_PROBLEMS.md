# Những Vấn Đề Phổ Biến Của AI Agent Khi Làm Việc Với Người Dùng & Giải Pháp Khắc Phục

> [!NOTE]
> **Tài liệu tham khảo nội bộ (Team-Facing Document)**:
> Tài liệu này được biên soạn nhằm mục đích nghiên cứu, đúc kết kinh nghiệm và hướng dẫn cho người dùng / đội ngũ kỹ thuật khi tương tác và tối ưu hóa quy trình làm việc với các AI Coding Agents. Tài liệu này **không** nằm trong luồng nạp ngữ cảnh tự động mặc định của Harness repo.

---

## Mục Lục
1. [Nhóm 1: Quản Lý Ngữ Cảnh & Tiêu Thụ Token (Context & Token Bottlenecks)](#nhóm-1-quản-lý-ngữ-cảnh--tiêu-thụ-token)
2. [Nhóm 2: Giao Tiếp, Ý Định & Ranh Giới Thẩm Quyền (Communication, Intent & Authority)](#nhóm-2-giao-tiếp-ý-định--ranh-giới-thẩm-quyền)
3. [Nhóm 3: Tính Đúng Đắn, Kỷ Luật Thực Thi & Kiểm Chứng (Reliability & Execution Discipline)](#nhóm-3-tính-đúng-đắn-kỷ-luật-thực-thi--kiểm-chứng)
4. [Nhóm 4: Trí Nhớ Giữa Các Phiên & Tính Nhất Quán (Cross-Session Continuity & Consistency)](#nhóm-4-trí-nhớ-giữa-các-phiên--tính-nhất-quán)
5. [Bảng Tổng Hợp Vấn Đề & Giải Pháp Kiến Trúc Harness](#bảng-tổng-hợp-vấn-đề--giải-pháp-kiến-trúc-harness)

---

## Nhóm 1: Quản Lý Ngữ Cảnh & Tiêu Thụ Token

### 1. Tràn Ngập Ngữ Cảnh & Suy Giảm Khả Năng Suy Luận (Context Bloat & Lost in the Middle)
- **Triệu chứng**: AI Agent nạp hàng chục file mã nguồn, toàn bộ lịch sử hội thoại hoặc các tài liệu lớn vào cửa sổ ngữ cảnh (Context Window). Sau đó, câu trả lời bắt đầu trở nên lú lẫn, bỏ sót các ràng buộc quan trọng nằm ở giữa đoạn văn bản.
- **Nguyên nhân gốc rễ**: Agent quét và đọc file vô tội vạ mà không có cơ chế phân loại (router) hoặc người dùng yêu cầu phân tích một dự án lớn nhưng không giới hạn phạm vi.
- **Tác động**: Tốn kém chi phí token cực lớn, chạm giới hạn token window, tốc độ phản hồi chậm và chất lượng suy luận giảm mạnh.
- **Đề xuất / Giải pháp**:
  - *Áp dụng Top-Down Routing (`INDEX.md`)*: Chỉ đọc file mục lục định tuyến, từ đó chỉ mở đúng các file cần thiết cho intent hiện tại.
  - *Chính sách nạp chọn lọc*: Chỉ tự động nạp các tài nguyên đang hoạt động (`active/`), tuyệt đối không tự ý nạp các file lịch sử đã đóng (`completed/`) hay các bản đề xuất chưa duyệt (`proposals/`).
  - *Sử dụng công cụ xác thực độc lập ($O(1)$ tool execution)* thay vì bắt Agent đọc toàn bộ dữ liệu để suy luận thủ công.

---

### 2. Trôi Lệch Ngữ Cảnh & Quên Mục Tiêu Ban Đầu (Context Drift)
- **Triệu chứng**: Sau một chuỗi nhiều bước thực thi (multi-turn debugging/refactoring), Agent bị phân tâm bởi các lỗi nhỏ phát sinh trên đường đi và quên mất mục tiêu cốt lõi mà người dùng giao ban đầu.
- **Nguyên nhân gốc rễ**: Lượng token log và output của các lệnh terminal chèn ép, đẩy các chỉ dẫn quan trọng của prompt ban đầu ra khỏi vùng chú ý (Attention Horizon).
- **Tác động**: Agent đi vào ngõ cụt, giải quyết các vấn đề phụ không liên quan và không thể chốt hạ công việc chính.
- **Đề xuất / Giải pháp**:
  - *Thiết lập Hard Gates (`goal-griller`)*: Định nghĩa rõ `Outcome` (Kết quả duy nhất), `Scope Boundary` (Ranh giới phạm vi) và `Done When` ngay từ đầu.
  - *Sử dụng bản ghi kế hoạch bền vững (`plans/active/*.md`)* để neo giữ trạng thái và mục tiêu giữa các bước.
  - *Cơ chế Checkpoint / Truncation*: Tóm tắt lại tiến độ sau các chuỗi tool call dài thay vì giữ nguyên toàn bộ raw log.

---

## Nhóm 2: Giao Tiếp, Ý Định & Ranh Giới Thẩm Quyền

### 3. Yêu Cầu Mơ Hồ & Tự Ý Phỏng Đoán (Vague Intent & Hallucinated Assumptions)
- **Triệu chứng**: Khi người dùng đưa ra câu lệnh ngắn như *"tối ưu hiệu năng app"*, *"sửa lỗi checkout"*, Agent tự đưa ra các giả định mơ hồ và lập tức sửa mã nguồn theo ý hiểu riêng mà không hỏi lại.
- **Nguyên nhân gốc rễ**: Agent thiếu quy trình phỏng vấn làm rõ (Interview Loop / Clarification) và có xu hướng muốn "hành động ngay" để lấy lòng người dùng.
- **Tác động**: Phá vỡ kiến trúc sẵn có, viết sai nghiệp vụ và người dùng phải mất công `git reset` khôi phục lại.
- **Đề xuất / Giải pháp**:
  - *Cơ chế Phỏng vấn 1 câu hỏi tại 1 thời điểm*: Khi gặp yêu cầu mơ hồ, Agent phải dừng lại để hỏi làm rõ tiêu chí đo lường và phạm vi trước khi code.
  - *Khuyên dùng các Slash Commands có cấu trúc* (ví dụ: `/goal`, `/plan`, `/grill-me`).

---

### 4. Tự Ý Mở Rộng Phạm Vi & Sửa Code Thừa (Silent Scope Creep & Over-Engineering)
- **Triệu chứng**: Được giao sửa một hàm nhỏ, nhưng Agent tiện tay "dọn dẹp" lại 5 file khác, thay đổi convention code hoặc cài thêm các thư viện bên thứ ba không được yêu cầu.
- **Nguyên nhân gốc rễ**: Agent đánh giá code xung quanh là "chưa tối ưu" và tự cho mình quyền quyết định thay đổi cấu trúc dự án.
- **Tác động**: Gây conflict lớn khi merge code, tăng nguy cơ phát sinh regression bug và khó review diff.
- **Đề xuất / Giải pháp**:
  - *Quy định Ranh giới Phạm vi (Scope Boundary)*: Nêu rõ `In-Scope` (những gì được sửa) và `Out-of-Scope` (những gì tuyệt đối không được đụng vào).
  - *Quy tắc Bounded Change / Ephemeral Plan*: Các thay đổi nhỏ có ranh giới rõ ràng không được phép tạo thêm các tác vụ phụ ngoài lề.

---

### 5. Tự Nhận Thẩm Quyền Thiết Lập Chính Sách (Hallucination of Authority)
- **Triệu chứng**: Agent tự tạo ra các quy ước mới, các giá trị mặc định có ảnh hưởng lâu dài (policy/defaults) mà không dựa trên bất kỳ tài liệu hay sự phê duyệt nào từ người dùng.
- **Nguyên nhân gốc rễ**: Nhầm lẫn giữa các đề xuất kỹ thuật (Proposals) với các quyết định đã được chấp thuận (Decisions/Authority).
- **Tác động**: Dự án bị gài các quy chuẩn ngầm mà các lập trình viên khác trong team không hề hay biết.
- **Đề xuất / Giải pháp**:
  - *Nguyên tắc Authority Check*: Trước khi chỉnh sửa, Agent phải chỉ ra nguồn thẩm quyền (Repository Authority) trong tài liệu hoặc xác nhận rõ từ User.
  - *Tách biệt Proposal và Decision*: Mọi đề xuất rủi ro/giải pháp phải ở trạng thái chờ duyệt (Pending) cho đến khi người dùng phê duyệt bằng văn bản.

---

## Nhóm 3: Tính Đúng Đắn, Kỷ Luật Thực Thi & Kiểm Chứng

### 6. Báo Cáo Hoàn Thành Ảo Dù Chưa Kiểm Chứng (Premature Completion & False Confidence)
- **Triệu chứng**: Agent vừa viết/sửa file xong là lập tức trả lời: *"Tôi đã sửa xong lỗi hoàn hảo!"* nhưng khi người dùng chạy thực tế thì code bị lỗi cú pháp, build fail hoặc unit test đỏ.
- **Nguyên nhân gốc rễ**: Agent chỉ đánh giá hoàn thành dựa trên việc "lệnh ghi file đã chạy thành công" chứ không thực sự chạy lệnh test/kiểm thử để đối chiếu kết quả đầu ra.
- **Tác động**: Làm mất lòng tin của người dùng, biến người dùng thành người đi test lỗi cho AI.
- **Đề xuất / Giải pháp**:
  - *Nguyên tắc "Claim completion ONLY with observable proof"*: Agent chỉ được tuyên bố hoàn thành khi có bằng chứng thực thi rõ ràng (terminal output sạch sẽ, test suites pass, script validator báo PASSED).
  - *Tạo các Script Validator Tự Động (Deterministic Tooling)*: Ví dụ `.agents/validators/*.py` hoặc `*.js` có exit code `0`/`1` rõ ràng.

---

### 7. Vòng Lặp Lỗi Công Cụ & Không Biết Dừng Đúng Lúc (Tooling Cascades & Looping)
- **Triệu chứng**: Khi gặp lỗi permission, lỗi path separator trên Windows, hoặc lỗi compile, Agent cố gắng chạy lại lệnh đó nhiều lần không đổi hoặc thử sai một cách mù quáng hàng chục lượt.
- **Nguyên nhân gốc rễ**: Thiếu Stop/Pause Rules và thiếu khả năng phân tích ngữ cảnh hệ điều hành (Windows PowerShell vs Linux Bash).
- **Tác động**: Cạn kiệt token trong phiên, làm hỏng workspace hoặc tạo rác trên hệ thống file.
- **Đề xuất / Giải pháp**:
  - *Quy tắc Pause If*: Nếu gặp lỗi bất thường quá 2 lần liên tiếp hoặc không có giải pháp an toàn, Agent phải dừng lại giải thích lý do và xin ý kiến người dùng.
  - *Hỗ trợ Script Đa Nền Tảng*: Viết các script tiện ích tương thích cả Windows và POSIX.

---

## Nhóm 4: Trí Nhớ Giữa Các Phiên & Tính Nhất Quán

### 8. Mất Trí Nhớ Giữa Các Phiên Làm Việc (Session Amnesia)
- **Triệu chứng**: Mở một phiên chat mới, Agent hoàn toàn không biết phiên trước đã thống nhất điều gì, dự án đang triển khai dở ở bước nào, dẫn đến việc hỏi lại từ đầu hoặc làm trái với quyết định trước đó.
- **Nguyên nhân gốc rễ**: Mỗi phiên chat (Session) là độc lập và LLM không có bộ nhớ dùng chung ngoài các file trên ổ đĩa.
- **Tác động**: Người dùng phải giải thích lại bối cảnh nhiều lần, gây lãng phí thời gian và giảm năng suất.
- **Đề xuất / Giải pháp**:
  - *Duy trì "Harness State on Disk"*: Lưu trạng thái dự án vào hệ thống file thay vì dựa vào bộ nhớ session (ví dụ: `tickets/active/`, `plans/active/`, `decisions/`).
  - *Session Context Loading*: Quy định quy trình nạp đầu phiên bắt buộc để Agent tự động đọc trạng thái active trước khi nhận lệnh.

---

### 9. Giọng Văn Lộn Xộn & Không Phù Hợp Nhu Cầu (Persona Mismatch)
- **Triệu chứng**: Người dùng cần xử lý gấp một dòng lệnh ngắn nhưng Agent lại trả lời dài dòng với lời chào hỏi và giải thích lý thuyết; hoặc người dùng muốn học hỏi kiến trúc sâu thì Agent chỉ trả lời cộc lốc một dòng code.
- **Nguyên nhân gốc rễ**: Không có cấu hình giao tiếp (Communication Style / Persona) rõ ràng và có thể tùy biến bởi người dùng.
- **Tác động**: Trải nghiệm người dùng kém, mất thời gian đọc lọc thông tin.
- **Đề xuất / Giải pháp**:
  - *File cấu hình Persona tập trung (`docs-harness/PERSONA.md`)*: Cho phép người dùng tick chọn phong cách phản hồi mong muốn (Default, Senior Architect, Minimalist, Friendly Pair Programmer).

---

## Bảng Tổng Hợp Vấn Đề & Giải Pháp Kiến Trúc Harness

| STT | Vấn đề của AI Agent | Nguyên nhân gốc rễ | Giải pháp trong Kiến trúc Harness |
| :--- | :--- | :--- | :--- |
| **1** | **Context Bloat / Token Exhaustion** | Quét file vô tội vạ, nạp cả lịch sử cũ | `Top-Down Routing` qua `INDEX.md`, chỉ nạp `active`, chặn `completed`/`proposals`. |
| **2** | **Context Drift** | Quên mục tiêu ban đầu sau nhiều turn | Hard Gates qua `goal-griller`, neo giữ mục tiêu trong `plans/active/*.md`. |
| **3** | **Vague Intent & Guessing** | Prompt mơ hồ, Agent tự phỏng đoán | Vòng phỏng vấn làm rõ (`Interview Loop`), yêu cầu xác nhận trước khi code. |
| **4** | **Scope Creep / Over-editing** | Tiện tay sửa thêm các file ngoài lề | Xác định `Scope Boundary` (In-scope / Out-of-scope), quy tắc Bounded Change. |
| **5** | **Hallucination of Authority** | Tự ý đặt chính sách/mặc định mới | Quy tắc kiểm tra thẩm quyền (`Authority Check`), tách biệt Proposal với Decision. |
| **6** | **Premature Completion** | Tuyên bố xong việc khi chưa kiểm thử | Quy tắc kiểm chứng bằng chứng thực thi (`Observable Proof`), dùng Script Validator. |
| **7** | **Tool Looping & Cascades** | Lặp vô tận khi gặp lỗi môi trường | `Pause If` rules, dừng lại khi bế tắc, script đa nền tảng chuẩn hóa. |
| **8** | **Session Amnesia** | Quên toàn bộ ngữ cảnh khi mở session mới | Lưu trạng thái lên ổ đĩa (`plans/active/`, `tickets/active/`), tự nạp ở Session Start. |
| **9** | **Persona Mismatch** | Giọng văn không đúng kỳ vọng người dùng | Cấu hình phong cách phản hồi qua Checklist tại `docs-harness/PERSONA.md`. |
