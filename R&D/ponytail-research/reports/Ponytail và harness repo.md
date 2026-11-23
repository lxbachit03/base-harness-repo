# Ponytail và harness repo: có phù hợp không?

- Ngày: 2026-11-23
- Đối tượng: <https://github.com/DietrichGebert/ponytail> (v5.3.3, MIT), kiểm tại commit `ebd8654` (2026-11-22)
- Đầu vào: bản nghiên cứu của Gemini ([../../ponytail-deep-research.md](../../ponytail-deep-research.md))
- Ghi chú chi tiết:
  - [upstream-verification.md](../research_notes/upstream-verification.md): kiểm chứng số liệu, benchmark, đánh giá độc lập, bảo mật
  - [upstream-rules.md](../research_notes/upstream-rules.md): nguyên văn `SKILL.md` và `AGENTS.md` của ponytail
  - [harness-fit.md](../research_notes/harness-fit.md): đối chiếu từng thành phần với file của harness

## Kết luận

**Không cài ponytail dạng plugin, hook hay rule copy vào harness. Phần đáng lấy là
nội dung bộ quy tắc viết code tối thiểu, viết lại theo cách của harness và chỉ áp
dụng cho các project có code dùng harness. Việc đó vẫn cần một pilot trước.**

- **Với chính harness repo:** gần như không có giá trị. Repo này hầu hết là
  Markdown; ponytail là quy tắc viết code. Chi phí ngữ cảnh lại là thật.
- **Với project có code áp dụng harness:** khoảng 1/3 nội dung đã có trong harness,
  1/3 đáng bổ sung, 1/3 mâu thuẫn với các quy tắc hiện có (xem dưới).
- **Bằng chứng hiệu quả:** benchmark của tác giả mạnh, nhưng đánh giá độc lập cho
  kết quả lẫn lộn. Code ngắn hơn và rẻ hơn là có thật; chất lượng và độ đầy đủ thì
  có nguồn thấy giảm.

## Bản của Gemini đúng tới đâu

Phần lớn mô tả cấu trúc, manifest, hook, skill đều đúng (đã đối chiếu raw file và
API). Những chỗ cần sửa:

| Gemini viết | Thực tế |
| :--- | :--- |
| 585 phiên = 39 task × 5 lần | 39 × 5 × **3 cấu hình** (không skill, v4.13, Ponytail 5) |
| Hidden checks 97% so với 96% | 96,7% so với 95,6%, chênh **1 lượt trên 90**; chính báo cáo gốc nói skill không thêm an toàn |
| Chấm bằng `judge.py` (over-engineering) | Kết quả công bố dùng judge độ đầy đủ (Opus 5.5) và judge câu trả lời (Sonnet 5.5); `judge.py` không được báo cáo |
| Không nhắc | Khi có test, test bắt lỗi cài sẵn **69%** với Ponytail 5 so với **77%** không skill; judge mù hơi nghiêng về câu trả lời không skill (106:82, không có ý nghĩa thống kê) |
| `.agents/rules/ponytail.md` khớp byte với `AGENTS.md` | Là `AGENTS.md` bỏ dòng cuối riêng của repo |
| Band lưu ở `~/.config/ponytail/band/` | Trên Windows vẫn ghi vào `%USERPROFILE%\.config\...`, còn `config.json` ở `%APPDATA%` |

Gemini cũng bỏ sót toàn bộ phần đánh giá độc lập, chi phí token thường trực và các
vấn đề bảo mật, là những phần quyết định nhất.

## Bằng chứng độc lập

| Nguồn | Thiết lập | Kết quả |
| :--- | :--- | :--- |
| DocSpring (2026-11-13) | Opus 5.5, Ponytail 5.3.3, monorepo thật, 16 phiên | Ít hơn 56% dòng code, rẻ hơn 34%; **chất lượng 5,9 so với 6,8, độ đầy đủ 2,1 so với 2,4**; có lượt bỏ sót luồng đăng ký, để test lỗi, khẳng định sai. Họ chép 3 ý vào AGENTS.md riêng thay vì cài |
| KuldeepB19 (issue) | 480 build, Opus 4.8 | Ít hơn khoảng 44% code, không mất độ đúng hay bảo mật; kém hơn ở edge case không được nêu, mức càng cao càng kém |
| Scott Logic | Benchmark single-shot cũ | Một prompt YAGNI 7 chữ cho kết quả tương đương |
| Issue #685 | A/B đo chi phí | Đắt hơn 6,9% so với một câu prompt; maintainer đóng "won't fix": bộ rule thường trực "là sản phẩm" |

**Chi phí thường trực:** mỗi lần SessionStart (startup, resume, clear, compact)
bơm khoảng 700 token rule cộng tối đa khoảng 500 token symbol map; mỗi subagent
nhận thêm khoảng 700 token.

## Đối chiếu với harness

### Đã có trong harness

- Đọc code và liệt kê caller trước khi sửa: bước 1–2 của quy tắc work-shape (#075).
- Không làm tính năng không được yêu cầu: #075 bước 3 và mục scope creep trong
  `docs/AI_PROBLEMS.md`.
- Thang "dùng lại code có sẵn → stdlib → dependency đã cài": gần với quy tắc
  khuyến nghị của skill `xia`, nhưng `xia` chỉ chạy cho việc rủi ro hoặc mơ hồ.
- 1–2 dòng cuối nêu kiểm tra đã bỏ qua: trùng quy tắc hoàn thành của #075 và yếu
  hơn #001 (mỗi rủi ro phải kèm đề xuất xử lý).
- `ponytail-review`: trùng skill `code-review` và `simplify` có sẵn của host.

### Đáng bổ sung (cho project có code)

- Tối giản code: không trừu tượng "để dành sau", code di chuyển giữ nguyên xử lý
  lỗi và validation, comment một dòng giải thích lý do.
- Danh sách "không bao giờ cắt" (validation ở ranh giới tin cậy, xử lý lỗi gây mất
  dữ liệu, bảo mật, accessibility). Cần viết lại dạng khẳng định theo
  `writing-for-agents`.
- Thiên hướng không thêm dependency: khớp cổng cài dependency của #009.
- Comment nợ kỹ thuật `shortcut: <giới hạn>, <khi nào nâng cấp>` và sổ nợ: khớp #001.

### Mâu thuẫn

| Ponytail | Harness | Hệ quả |
| :--- | :--- | :--- |
| Logic mới không tầm thường phải kèm một test nhỏ | #058: không viết unit test khi chưa có authority của User | Phải đổi thành "đề xuất test" |
| Yêu cầu mơ hồ thì làm bản nhỏ nhất | #074 và raw requirements: hỏi trước | Phải đổi thành "hỏi" |
| Đổi mức bằng câu chat, mặc định lưu ở `~/.config` | Công tắc là checklist trong file repo do User bật (như jev-hook) | Phải dùng checklist |
| SessionStart bơm khoảng 3,5 KB mỗi phiên | Ngân sách đọc đầu phiên 33.400 byte (#064); nội dung bơm nằm ngoài INDEX nên `harness_check` không thấy | Chiếm khoảng 10% ngân sách, không kiểm soát được |
| SubagentStart bơm rule cho subagent | Worker đã tự đọc project constraint lúc bắt đầu | Trùng lặp |
| Rule copy `AGENTS.md`, `.agents/rules/ponytail.md` | `AGENTS.md` là điểm vào của harness; tiền lệ #094: không installer bên thứ ba nào ghi `AGENTS.md`, rule hay hook | Ghi đè điểm vào hoặc thành rule agy luôn bật |
| Ghi global: plugin, hook, CSV band, statusline, webhook | #009: mỗi thao tác cần authority riêng; `statusLine` hiện có sẽ bị đụng; thêm Node làm điều kiện | Nhiều cổng authority |
| Symbol map lúc SessionStart | Mục tiêu giống skill `code-graph` đã gỡ (#094: agent không dùng nếu không nhắc, nhắc thì tốn thêm 69–101%) | Chưa được chứng minh; repo Markdown thì map gần như rỗng |

### Bảo mật và riêng tư

- **Bản giả mạo:** clone `0xwilliamortiz/ponytail-improved` từng phát tán malware
  Windows qua marketplace giả (issue #735). Nếu dùng, chỉ lấy từ
  `DietrichGebert/ponytail` hoặc npm `@dietrichgebert/ponytail`.
- **Không có telemetry.** Mạng chỉ dùng cho webhook, mặc định tắt. Khi bật,
  `sendNames` mặc định gửi dòng đầu prompt của mỗi task (issue #1312 còn mở).
- **Ghi đĩa mặc định:** CSV task board sau mỗi lượt; script gỡ cài không xóa thư mục này.
- **Chưa có SECURITY.md** hay advisory công bố; báo lỗi riêng mới bật từ 2026-11-06.

## Đề xuất

1. **Không cài** plugin, hook, rule copy, band hay statusline của ponytail vào harness.
2. **Nếu muốn lấy ý tưởng** (tùy User quyết):
   - Viết một project constraint hoặc skill riêng của harness, chuyển thể từ nội
     dung MIT của ponytail, chỉ cho project có code.
   - Bật bằng checklist; yêu cầu mơ hồ thì hỏi; test chỉ đề xuất theo #058; phần
     kết câu trả lời để #075 và #001 lo.
   - Gắn mỗi quy tắc vào file harness đã sở hữu chủ đề đó, không chép trùng.
3. **Trước khi giữ:** chạy qua `improve-harness` và một pilot trên project có code
   thật, ngưỡng đặt trước giống #094 (ví dụ ít token hơn ít nhất 30% mà độ đúng và
   độ đầy đủ không giảm). Pilot cần đo cả chất lượng và độ đầy đủ, vì đó là chỗ
   DocSpring thấy giảm.
4. **Phương án rẻ nhất để thử:** chép 2–3 dòng cốt lõi (không trừu tượng để dành,
   ưu tiên dùng lại code có sẵn, không thêm dependency khi chưa hỏi) vào project
   constraint của một project, giống cách DocSpring làm, rồi so sánh.

## Giới hạn của báo cáo này

- Không chạy thử ponytail; mọi con số là của tác giả hoặc bên thứ ba.
- Không đọc được trang JetBrains, InfoQ và trang KuldeepB19 (403/405/404); số liệu
  KuldeepB19 lấy từ issue trên GitHub.
- Chưa kiểm commit của tag release và danh sách version trong CI.
