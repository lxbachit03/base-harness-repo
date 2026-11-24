# Karpathy: định dạng output để hiểu kết quả của LLM

Ngày đọc: 2026-11-24. Nguồn:
- Bài đăng X của Andrej Karpathy, 2026-10-02:
  https://x.com/karpathy/status/2105819303471976479 (khoảng 8.2M lượt xem
  lúc đọc)
- Simplified Technical English, Wikipedia:
  https://en.wikipedia.org/wiki/Simplified_Technical_English. Trang chính thức
  asd-ste100.org trả HTTP 403, nên các con số về STE bên dưới chưa được kiểm
  với spec gốc.

## 1. Bài viết nói gì

Luận điểm: LLM làm ngày càng nhiều phần việc nặng một cách tự động. Vì vậy
việc của con người chuyển lên tầng trên, thành **giám sát và hiểu** output của
LLM. Karpathy đưa ra một thang định dạng output, mỗi bậc sau tốt hơn bậc
trước:

| Bậc | Cách làm | Lý do |
| :--- | :--- | :--- |
| 1. Viết | Yêu cầu LLM giải thích bằng ASD-STE100, hoặc mềm hơn là "80% STE" | Ngôn ngữ có kiểm soát; văn phong sạch, dễ đọc hơn |
| 2. Sơ đồ, hình | Yêu cầu một sơ đồ thay vì văn bản | Dễ xử lý, phân tích và hiểu hơn |
| 3. Trang web | Yêu cầu output "in HTML" | LLM làm frontend giỏi; trang có tương tác và animation |
| 4. Video giải thích | Ví dụ: video kiểu 3Blue1Brown về chủ đề X, lồng tiếng bằng ElevenLabs hoặc công cụ miễn phí chạy local | Định dạng ông kỳ vọng nhất; theo ông "đang bắt đầu chạy được" |

Kết luận của bài: trí tuệ và code ngày càng rẻ, nên có thể yêu cầu những
artifact lớn, làm riêng, dùng xong bỏ (web app, video). Trước đây những thứ
này không đáng công làm.

Giới hạn của nguồn: đây là kinh nghiệm cá nhân trong một bài đăng, không phải
nghiên cứu có đo đạc.

## 2. ASD-STE100 là gì

Theo Wikipedia:
- Simplified Technical English, do ASD phát triển cho tài liệu bảo trì hàng
  không.
- Bản hiện tại: Issue 9, tháng 1/2025. Thường ra bản mới khoảng ba năm một
  lần. Miễn phí từ Issue 6 (2013).
- Quy tắc chính:
  - Câu hướng dẫn tối đa 20 từ; câu mô tả tối đa 25 từ.
  - Đoạn tối đa 6 câu, một chủ đề.
  - Một chỉ dẫn mỗi câu.
  - Thể chủ động; câu mô tả chỉ dùng bị động khi không rõ chủ thể.
  - Từ điển khoảng 900 từ được duyệt; mỗi từ một từ loại và một nghĩa.
  - Chỉ dùng một số dạng động từ đơn giản (nguyên mẫu, mệnh lệnh, hiện tại
    đơn, quá khứ đơn, tương lai đơn).
  - Danh từ ghép không quá ba từ; không lược chủ ngữ, động từ hay mạo từ cho
    ngắn; dùng danh sách dọc cho nội dung phức tạp.
  - Tổng cộng 53 quy tắc viết.
- STE được thiết kế để dùng cùng các style guide khác, không dùng riêng.

STE chỉ áp dụng cho tiếng Anh. Phần cốt lõi vẫn dùng được cho báo cáo tiếng
Việt: câu ngắn, một ý mỗi câu, thể chủ động, mỗi thuật ngữ một nghĩa.

## 3. Đối chiếu với repo

| Ý của Karpathy | Repo hiện có | Nhận xét |
| :--- | :--- | :--- |
| Viết theo STE | `writing-for-agents` lo tài liệu agent đọc, không lo output cho User đọc | Báo cáo R&D không có quy chuẩn văn phong |
| Sơ đồ | `artifact-diagramming`, `show_widget` | Có công cụ; chưa có quy tắc dùng sơ đồ cho báo cáo |
| HTML | `prd-research` xuất cả `.md` và `.html`; `asset-design-systems`; Artifact | Gần nhất với đề xuất của bài. Báo cáo deep-dive khác chỉ có Markdown. Publish Artifact là hành động ra ngoài, theo luật task authority của repo |
| Video | Chưa có | Cần API key (ElevenLabs) hoặc cài công cụ (Manim, TTS local). Cài cần User cho phép đúng công cụ đó (#009); agent không tự nhập key |
| Artifact dùng xong bỏ | Scratchpad, preview, Artifact riêng tư | File tạm để ngoài repo và không commit, để tránh tích tụ nội dung cũ làm agent lạc hướng (xem phân tích Agent Distraction của Google) |

## 4. Đề xuất (chưa làm)

1. **Văn phong "STE-lite" cho báo cáo gửi User.** Một đoạn ngắn ở nơi quản lý
   báo cáo: câu không quá 20–25 từ, một ý mỗi câu, thể chủ động, thuật ngữ
   nhất quán. Làm qua `improve-harness`, có replay A/B như #099.
2. **Tuỳ chọn HTML hoặc sơ đồ cho báo cáo deep-dive phức tạp**, theo mẫu của
   `prd-research`. Là tuỳ chọn, không phải mặc định.
3. **Video giải thích:** chỉ thử khi User muốn. Trước khi cài bất cứ gì, User
   chọn công cụ: Manim + TTS local, hoặc một dịch vụ trả phí.

Muốn biết các đề xuất có hiệu quả với repo này không thì phải thử và đo.
