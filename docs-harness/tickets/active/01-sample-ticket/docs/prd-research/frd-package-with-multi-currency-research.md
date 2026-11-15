# Nghiên cứu FRD: Package với nhiều loại tiền tệ

**Trạng thái:** Ví dụ nghiên cứu dựa trên FRD; các đề xuất phân công chưa được xác nhận.

**Nguồn:** [FRD_Package with multi currency.pdf](../../FRD_Package%20with%20multi%20currency.pdf) · 97 trang · SHA-256: 6830F91D184088303B66858E72C7531FBFA65B851519BE8BDC453C93CA08C392.
**Phiên bản:** Bìa ghi 1.0; bảng revision có 1.1, không có ngày phát hành; chưa xác định bản được duyệt (Q-11).
**Giả định theo User:** Không có mã nguồn WeMasterTrade trong ví dụ. Repo hiện tại là [Base Harness](../../../../../../README.md), nên không có bằng chứng để khẳng định team, API, bảng dữ liệu hay hành vi runtime. Phân công trong báo cáo là đề xuất cần User xác nhận.
**Ticket:** Thư mục mẫu chưa có ticket.md và chưa xác định owner; không tự tạo thông tin.

## 1. BA muốn làm gì và ai bị ảnh hưởng

BA muốn trader chọn currency khác USD cho gói MT5 Instant, 2-Phase và 1-Phase; số tiền gói, balance, điều kiện và thông tin lợi nhuận được thể hiện theo lựa chọn đó. Admin quản lý currency, tỷ giá thủ công và cấu hình theo từng gói. Ví/chi trả cuối cùng vẫn dùng USD. Xem [trang 3–4](../../FRD_Package%20with%20multi%20currency.pdf#page=3).

- **Trader:** dễ xem và chọn gói theo currency quen thuộc; cần hiểu số tiền hiển thị có thể khác currency thanh toán/chi trả.
- **Admin:** cấu hình currency, tỷ giá, group, package, theo dõi transaction và profit request.
- **Finance/vận hành:** cần đối chiếu số tiền gốc, tỷ giá, số USD và số tiền thực tế qua phương thức thanh toán. Đây là tác động suy luận từ yêu cầu, chưa được xác nhận bằng vận hành thực tế.

### Phạm vi và ranh giới

- **Trong phạm vi:** MT5 Instant, 2-Phase, 1-Phase; FO, BO và các màn Trading Service được liệt kê trong FRD.
- **Ngoài phạm vi theo trang 4:** luồng mua/checkout/trading account/profit request multicurrency cho cTrader, nguồn tỷ giá thị trường realtime và thay đổi settlement cuối cùng khỏi USD. Riêng màn hiển thị cTrader tại trang 19 cần làm rõ ở Q-02.
- **Chưa kiểm tra:** tài liệu FRD cũ, spreadsheet, Figma, SharePoint và hệ thống/runtime được PDF tham chiếu. Không coi những tham chiếu đó là bằng chứng đã được xác minh.

### Luồng nghiệp vụ ở mức khái quát

1. Admin cấu hình Currency Rate, Currency List và currency/group được hỗ trợ bởi package.
2. Trader chọn currency và gói; giao diện trình bày balance, phí, discount và điều kiện theo currency.
3. Checkout tính số tiền theo currency của phương thức thanh toán; transaction lưu currency, số tiền và tỷ giá liên quan theo FRD.
4. Tài khoản trading/phase tiếp theo kế thừa currency; profit request hoặc refund được quy đổi sang USD để xử lý ví/chi trả.

## 2. Công thức và ví dụ BA

- Tỷ giá r(C) là số đơn vị currency C cho 1 USD. Quy đổi USD → C: số USD × r(C); quy đổi C → USD: số C ÷ r(C). USD dùng r = 1. Nguồn: trang 29, 60, 63, 90. Nguồn PDF: [trang 29](../../FRD_Package%20with%20multi%20currency.pdf#page=29), [trang 60](../../FRD_Package%20with%20multi%20currency.pdf#page=60), [trang 63](../../FRD_Package%20with%20multi%20currency.pdf#page=63), [trang 90](../../FRD_Package%20with%20multi%20currency.pdf#page=90).
- Equivalent amount: cùng currency với phương thức thì giữ số tiền; nếu phương thức dùng USD thì chia r(C); nếu cần đổi sang currency phương thức khác, FRD mô tả qua USD rồi nhân tỷ giá Country. Bảng trang 92 còn có ví dụ USD → VND. Nguồn PDF: [trang 29](../../FRD_Package%20with%20multi%20currency.pdf#page=29), [trang 38](../../FRD_Package%20with%20multi%20currency.pdf#page=38), [trang 92](../../FRD_Package%20with%20multi%20currency.pdf#page=92).
- Discount cố định có gốc USD được nhân r(C); discount phần trăm giữ tỷ lệ phần trăm. Phí 1-Phase customize = Initial Balance × X; Original Fee = Fee + Fee × Original Fee %. Nguồn: trang 26. Nguồn PDF: [trang 26](../../FRD_Package%20with%20multi%20currency.pdf#page=26).
- Refund 2-Phase funded = Checkout amount USD × Refund ratio + Profit Share; Profit Share USD = (Share₁ × Closed Net Profit₁ + Share₂ × Closed Net Profit₂) ÷ r(C). 1-Phase dùng một phase. Nguồn: trang 45–49. Nguồn PDF: [trang 45](../../FRD_Package%20with%20multi%20currency.pdf#page=45), [trang 46](../../FRD_Package%20with%20multi%20currency.pdf#page=46), [trang 47](../../FRD_Package%20with%20multi%20currency.pdf#page=47), [trang 49](../../FRD_Package%20with%20multi%20currency.pdf#page=49).
- Profit request: khi đạt ngưỡng, Available Profit quy đổi USD bằng Available Profit ÷ r(C); Net Profit to Receive = Available Profit × Profit Share Rate. Ví cuối cùng nhận USD. Nguồn: trang 53–54, 83–85. Nguồn PDF: [trang 53](../../FRD_Package%20with%20multi%20currency.pdf#page=53), [trang 54](../../FRD_Package%20with%20multi%20currency.pdf#page=54), [trang 83](../../FRD_Package%20with%20multi%20currency.pdf#page=83), [trang 85](../../FRD_Package%20with%20multi%20currency.pdf#page=85).

### Năm trường hợp transaction trong FRD

Bảng dưới đây được đối chiếu trực quan từ [trang 92](../../FRD_Package%20with%20multi%20currency.pdf#page=92). Dấu phẩy/dấu chấm được trình bày theo cách dễ đọc; số liệu vẫn là ví dụ của BA.

| Package / method | Amount | Rate package | Convert USD | Method | Rate country | Equivalent | Balance currency |
| --- | --- | --- | --- | --- | --- | --- | --- |
| USD / USD | 30 USD | 1 | 30 USD | USD | — | 30 USD | USD |
| EUR / USD | 30 EUR | 0,8 | 37,5 USD | USD | — | 37,5 USD | EUR |
| JPY / JPY | 4.500 JPY | 150 | 30 USD | JPY | — | 4.500 JPY | JPY |
| EUR / VND | 30 EUR | 0,8 | 37,5 USD | VND | 26.000 | 975.000 VND | EUR |
| USD / VND | 30 USD | 1 | 30 USD | VND | 26.000 | 780.000 VND | USD |

**Ví dụ sơ đồ refund:** (80% × 1.000 EUR + 90% × 500 EUR) ÷ 0,92 = 1.358,70 USD cho phần Profit Share. Đây không phải toàn bộ Refund Amount. Xem [trang 47](../../FRD_Package%20with%20multi%20currency.pdf#page=47).

**Cần xác nhận:** thời điểm chốt tỷ giá, quy tắc làm tròn và processing fee được gắn với các AC tương ứng ở Q-05 và Q-06.

## 3. Đề xuất phân loại theo lớp

Các mục sau là **suy luận từ mô tả FRD**, không phải kết quả dò code. Một AC có thể cần nhiều lớp; Internal Service là vai trò tích hợp có thể tồn tại, không mặc định là .NET hoặc một repo cụ thể.

| Lớp | Phạm vi đề xuất | Cần xác minh |
| --- | --- | --- |
| FE | Màn FO/BO/Trading Service: chọn currency, hiển thị, filter, biểu mẫu, cảnh báo và xác nhận. | Team UI, data contract, validation phía client. |
| Backend | Cung cấp dữ liệu/cấu hình, validation, tính tiền, lưu transaction/snapshot và điều phối xử lý. | API, DB/schema, nơi tính tiền và ownership thực tế. |
| Internal Service | Ứng viên: trading/MT5, wallet, payment, affiliate, email, certificate, DocuSeal hoặc HubSpot khi AC liên quan. | Dịch vụ nào thực sự tồn tại, ranh giới, hợp đồng và retry. |

## 4. Những điểm cần lưu ý khi đọc AC

- **158 nhóm AC** là mã tham chiếu do báo cáo tạo theo 31 chủ đề, không phải 158 mã hay 158 ticket do BA cấp. Những điều kiện con, ví dụ và dòng tiếp trang được giữ trong phần BA gốc của từng nhóm. Một số nhóm chỉ là tiêu đề, phạm vi áp dụng hoặc tham chiếu và không tự tạo thêm AC độc lập.
- Mỗi nhóm nêu mã mục FRD, trang nguồn, phân loại đề xuất và câu hỏi gắn trực tiếp. **Cần User xác nhận** không có nghĩa là code hiện tại sai hoặc chức năng đã được triển khai.
- Nội dung BA được trích từ PDF theo dòng; dấu bullet có font đặc biệt được đổi sang ký tự đọc được và xuống dòng theo văn bản trích xuất. Bảng trang 92 đã đối chiếu trực quan; nếu bố cục khác, PDF là nguồn chuẩn.

## 5. Danh mục Acceptance Criteria

### 01. [Instant_Trading capital] View multi-currency package

Trader lọc gói Instant theo currency đang hoạt động và được phép hiển thị trên Trading Capital; danh sách, cờ, điều kiện và popup dùng đơn vị đã chọn.

<a id="ac-01-01"></a>

#### **AC-01-01 — AC chung**

**Nguồn:** mục FRD 7.1.4; [trang 6](../../FRD_Package%20with%20multi%20currency.pdf#page=6).
**Diễn giải:** Trader lọc gói Instant theo currency đang hoạt động và được phép hiển thị trên Trading Capital; danh sách, cờ, điều kiện và popup dùng đơn vị đã chọn.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 6 ---
When user select currency, the system will get list package support for that currency (Only get
currency ACTIVE for that package):
==> Get currency has toggle ON for field Display on Trading capital on Currency List.
~~~

<a id="ac-01-02"></a>

#### **AC-01-02 — Danh sách Trading Capital**

**Nguồn:** mục FRD 7.1.4; [trang 6](../../FRD_Package%20with%20multi%20currency.pdf#page=6).
**Diễn giải:** Trader lọc gói Instant theo currency đang hoạt động và được phép hiển thị trên Trading Capital; danh sách, cờ, điều kiện và popup dùng đơn vị đã chọn. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 6 ---
- Trading capital List:
o Change currency unit of each package corresponding the selected currency:
Format [Initial balance] [Currency]
~~~

<a id="ac-01-03"></a>

#### **AC-01-03 — Cờ tiền tệ**

**Nguồn:** mục FRD 7.1.4; [trang 6](../../FRD_Package%20with%20multi%20currency.pdf#page=6).
**Diễn giải:** Hiển thị cờ đã cấu hình tại Currency Rate cho currency tương ứng.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 6 ---
- Currency Flag: Display the flag configured for each currency in the Currency Rate list.
Refer to US Currency Rate list in FRD_Package with multi currency.docx
~~~

<a id="ac-01-04"></a>

#### **AC-01-04 — Popup xác nhận**

**Nguồn:** mục FRD 7.1.4; [trang 6](../../FRD_Package%20with%20multi%20currency.pdf#page=6), [trang 7](../../FRD_Package%20with%20multi%20currency.pdf#page=7), [trang 8](../../FRD_Package%20with%20multi%20currency.pdf#page=8).
**Diễn giải:** Popup xác nhận trình bày các điều kiện và số tiền với currency đã chọn theo từng gói.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 6 ---
- Trading capital confirmation popup: Update currency for these fields based on the
selected currency:
o Max Daily Loss.
▪ Current: $10,000
▪ Expect new: 10,000 USD; 10,000 EUR,...
o Max Total Loss.
▪ Current: $10,000
▪ Expect new: 10,000 USD; 10,000 EUR,...
o Avg Reward
▪ Keep displaying the current data for USD – Package only.
o Profit Target
▪ Current: $10,000
▪ Expect new: 10,000 USD; 10,000 EUR,...
o Fee:
▪ Format: [Fee] [Currency]
▪ Value sourced from the existing fee calculation logic (Refer US: Calculate
fee for the customize package)
--- Trang 7 ---
o Discount Amount
▪ For fixed-amount discount type:
• Discount Amount = Discount Amount (USD) * Currency Rate
(Currency Rate from BO → Package → Multi-Currency →
Currency Rate)
▪ For percentage discount type displays the corresponding percentage value
directly (no conversion needed)
o Checkout Amount:
--- Trang 8 ---
▪ Format: [Checkout Amount] [Currency]
o In case for package 0 fee: Checkout Amount displays 0 [Currency]. Keep the
button Claim and the flow after claiming the free package as current.
~~~

### 02. [2-Phase Challenge_Trading capital] View multi-currency package

Cùng quy tắc hiển thị cho gói 2-Phase; popup thể hiện đơn vị đã chọn cho các giá trị của hai phase và khoản phí.

<a id="ac-02-01"></a>

#### **AC-02-01 — AC chung**

**Nguồn:** mục FRD 7.2.4; [trang 9](../../FRD_Package%20with%20multi%20currency.pdf#page=9).
**Diễn giải:** Cùng quy tắc hiển thị cho gói 2-Phase; popup thể hiện đơn vị đã chọn cho các giá trị của hai phase và khoản phí.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 9 ---
When user select currency, the system will get list package support for that currency (Only get
currency ACTIVE for that package):
==> Get currency has toggle ON for field Display on Trading capital on Currency List.
~~~

<a id="ac-02-02"></a>

#### **AC-02-02 — Danh sách Trading Capital**

**Nguồn:** mục FRD 7.2.4; [trang 10](../../FRD_Package%20with%20multi%20currency.pdf#page=10).
**Diễn giải:** Cùng quy tắc hiển thị cho gói 2-Phase; popup thể hiện đơn vị đã chọn cho các giá trị của hai phase và khoản phí. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 10 ---
- Trading capital List:
o Change currency unit of each package corresponding the selected currency:
Format [Initial balance] [Currency]
~~~

<a id="ac-02-03"></a>

#### **AC-02-03 — Cờ tiền tệ**

**Nguồn:** mục FRD 7.2.4; [trang 10](../../FRD_Package%20with%20multi%20currency.pdf#page=10).
**Diễn giải:** Hiển thị cờ đã cấu hình tại Currency Rate cho currency tương ứng.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 10 ---
- Currency Flag: Display the flag configured for each currency in the Currency Rate list.
Refer to US Currency Rate list in FRD_Package with multi currency.docx
~~~

<a id="ac-02-04"></a>

#### **AC-02-04 — Popup xác nhận**

**Nguồn:** mục FRD 7.2.4; [trang 10](../../FRD_Package%20with%20multi%20currency.pdf#page=10), [trang 11](../../FRD_Package%20with%20multi%20currency.pdf#page=11).
**Diễn giải:** Popup xác nhận trình bày các điều kiện và số tiền với currency đã chọn theo từng gói.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 10 ---
- Trading capital confirmation popup: Update currency for these fields based on the
selected currency – apply for 2 phase:
o Max Daily Loss.
▪ Current: $10,000
▪ Expect new: 10,000 USD; 10,000 EUR,...
o Max Total Loss.
▪ Current: $10,000
▪ Expect new: 10,000 USD; 10,000 EUR,...
o Avg Reward
▪ Keep displaying the current data for USD – Package only.
o Profit Target
▪ Current: $10,000
▪ Expect new: 10,000 USD; 10,000 EUR,...
o Fee:
▪ Format: [Fee] [Currency]
▪ Value sourced from the existing fee calculation logic (Refer US: Calculate
fee for the customize package)
o Discount Amount
▪ For fixed-amount discount type:
• Discount Amount = Discount Amount (USD) * Currency Rate
(Currency Rate from BO → Package → Multi-Currency →
Currency Rate)
▪ For percentage discount type displays the corresponding percentage value
directly (no conversion needed)
o Checkout Amount:
--- Trang 11 ---
▪ Format: [Checkout Amount] [Currency]
o In case for package 0 fee: Checkout Amount displays 0 [Currency]. Keep the
button Claim and the flow after claiming the free package as current.
~~~

### 03. [1-Phase Challenge_Trading capital] View multi-currency package

Cùng quy tắc cho 1-Phase; phí lấy từ One-time Fee và popup bao gồm phase 1 cùng funded account.

<a id="ac-03-01"></a>

#### **AC-03-01 — AC chung**

**Nguồn:** mục FRD 7.3.4; [trang 13](../../FRD_Package%20with%20multi%20currency.pdf#page=13).
**Diễn giải:** Cùng quy tắc cho 1-Phase; phí lấy từ One-time Fee và popup bao gồm phase 1 cùng funded account.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 13 ---
Refer to US Trading capital – Challenge tab and Challenge – Checkout Confirmation of
Challenge package in Trading capital in FRD_FO_One-Phase Package.docx
When user select currency, the system will get list package support for that currency (Only get
currency ACTIVE for that package):
==> Get currency has toggle ON for field Display on Trading capital on Currency List.
~~~

<a id="ac-03-02"></a>

#### **AC-03-02 — Danh sách Trading Capital**

**Nguồn:** mục FRD 7.3.4; [trang 13](../../FRD_Package%20with%20multi%20currency.pdf#page=13).
**Diễn giải:** Cùng quy tắc cho 1-Phase; phí lấy từ One-time Fee và popup bao gồm phase 1 cùng funded account. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 13 ---
• Trading capital List (1-Phase tab):
◦ Change currency unit of each package corresponding the selected currency: Format
[Initial balance] [Currency]
~~~

<a id="ac-03-03"></a>

#### **AC-03-03 — Cờ tiền tệ**

**Nguồn:** mục FRD 7.3.4; [trang 13](../../FRD_Package%20with%20multi%20currency.pdf#page=13).
**Diễn giải:** Hiển thị cờ đã cấu hình tại Currency Rate cho currency tương ứng.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 13 ---
• Currency Flag: Display the flag configured for each currency in the Currency Rate list.
Refer to US Currency Rate list in FRD_Package with multi currency.docx
~~~

<a id="ac-03-04"></a>

#### **AC-03-04 — Popup xác nhận**

**Nguồn:** mục FRD 7.3.4; [trang 13](../../FRD_Package%20with%20multi%20currency.pdf#page=13), [trang 14](../../FRD_Package%20with%20multi%20currency.pdf#page=14).
**Diễn giải:** Popup xác nhận trình bày các điều kiện và số tiền với currency đã chọn theo từng gói.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 13 ---
• Trading capital confirmation popup: Update currency for these fields based on the selected
currency – apply for Phase 1 and Funded Account:
◦ Max Daily Loss.
▪ Current: $10,000
▪ Expect new: 10,000 USD; 10,000 EUR,...
◦ Max Total Loss.
▪ Current: $10,000
▪ Expect new: 10,000 USD; 10,000 EUR,...
◦ Profit Target
▪ Current: $10,000
▪ Expect new: 10,000 USD; 10,000 EUR,...
◦ Fee:
▪ Format: [Fee] [Currency]
▪ Value sourced from the One-time Fee of the package
◦ Discount Amount
▪ For fixed-amount discount type:
• Discount Amount = Discount Amount (USD) * Currency Rate (Currency Rate
from BO → Package → Multi-Currency → Currency Rate)
▪ For percentage discount type displays the corresponding percentage value directly
(no conversion needed)
--- Trang 14 ---
◦ Checkout Amount:
▪ Format: [Checkout Amount] [Currency]
◦ In case for package 0 fee: Checkout Amount displays 0 [Currency]. Keep the button
Claim and the flow after claiming the free package as current.
~~~

### 04. [Instant_Customize package] Select multi-currency for customize package

Trader chọn currency khi tùy chỉnh Instant; danh sách, giới hạn balance theo currency, phí, giảm giá và popup được cập nhật theo cấu hình.

<a id="ac-04-01"></a>

#### **AC-04-01 — Chọn currency**

**Nguồn:** mục FRD 7.4.4; [trang 16](../../FRD_Package%20with%20multi%20currency.pdf#page=16), [trang 17](../../FRD_Package%20with%20multi%20currency.pdf#page=17).
**Diễn giải:** Người dùng chọn currency được phép hiển thị; thứ tự, mặc định, cờ và cách hiển thị theo thiết bị tuân theo mô tả gốc bên dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 16 ---
Field
Name
Type Required - Description
Currency Radio button Yes
- Lists all ACTIVE currencies in BO →
Customize Package Configuration →
Currency List
==> Get currency has toggle ON for field Display on
Customized package? on Currency List.
- Display the all currency list in a maximum of
2 lines by default.
o If the currency list contains more than
2 lines, display the “+More” button at
the end of the second line.
o When the user clicks “+More”:
Display the full currency list.
▪ Replace “+More” with a
“Less” button.
o When the user clicks “Less”:
▪ Collapse the currency list back
to 2 lines.
▪ Display the “+More” button
again if the currency list still
exceeds 2 lines.
o For mobile view, show all currency.
- By default, the first currency in the list is
selected.
- Sort currencies according to the No. order
configured in BO.
--- Trang 17 ---
- Tooltips: "The currency you choose here
applies to your package of payment, initial
balance and payouts."
- Currency Flag: Display the flag configured
for each currency in the Currency Rate list.
Refer to US Currency Rate list in
FRD_Package with multi currency.docx
~~~

<a id="ac-04-02"></a>

#### **AC-04-02 — Số dư ban đầu**

**Nguồn:** mục FRD 7.4.4; [trang 17](../../FRD_Package%20with%20multi%20currency.pdf#page=17).
**Diễn giải:** Khi đổi currency, hiển thị đơn vị tương ứng; giữ giá trị số đã nhập và áp dụng giới hạn của currency đó như FRD mô tả.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-03](#q-03) — **Chờ trả lời:** Balance ở customize là trường user nhập hay read-only? Nếu nhập trước rồi đổi currency thì giữ nguyên số và revalidate theo giới hạn mới đúng không?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 17 ---
Balance
Number (read-only
display, currency-
dependent)
Yes
- Updates its displayed currency unit
immediately when Currency selection
changes
- Allowed range: depend on each currency. If
out of range, display error message: “The
balance must be within [Minimum initial
balance] [Currency] and [Maximum initial
balance] [Currency]”
- If user enters a Balance value first, then
changes Currency: the entered numeric
amount is retained; only the currency unit
updates
- Format: [Balance] [Currency]
~~~

<a id="ac-04-03"></a>

#### **AC-04-03 — Phí**

**Nguồn:** mục FRD 7.4.4; [trang 17](../../FRD_Package%20with%20multi%20currency.pdf#page=17).
**Diễn giải:** Hiển thị giá trị phí với currency đã chọn, sử dụng công thức hoặc cấu hình được FRD tham chiếu.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 17 ---
Fee Read-only —
- Format: [Fee] [Currency]
- Value sourced from the existing fee
calculation logic (Refer US: Calculate fee for
the customize package)
~~~

<a id="ac-04-04"></a>

#### **AC-04-04 — Phí gốc**

**Nguồn:** mục FRD 7.4.4; [trang 17](../../FRD_Package%20with%20multi%20currency.pdf#page=17).
**Diễn giải:** Hiển thị giá trị phí với currency đã chọn, sử dụng công thức hoặc cấu hình được FRD tham chiếu.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 17 ---
Original
Fee
Read-only —
- Format: [Original Fee] [Currency]
- Value sourced from the existing fee
calculation logic (Refer US: Calculate fee for
the customize package)
~~~

<a id="ac-04-05"></a>

#### **AC-04-05 — Giảm giá**

**Nguồn:** mục FRD 7.4.4; [trang 17](../../FRD_Package%20with%20multi%20currency.pdf#page=17), [trang 18](../../FRD_Package%20with%20multi%20currency.pdf#page=18).
**Diễn giải:** Discount cố định USD được nhân tỷ giá; discount phần trăm giữ nguyên tỷ lệ.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 17 ---
Discount
Amount
Read-only — - For fixed-amount discount type:
--- Trang 18 ---
o Discount Amount = Discount Amount
(USD) * Currency Rate (Currency
Rate from BO → Package → Multi-
Currency → Currency Rate)
- For percentage discount type displays the
corresponding percentage value directly (no
conversion needed)
~~~

<a id="ac-04-06"></a>

#### **AC-04-06 — Số tiền checkout**

**Nguồn:** mục FRD 7.4.4; [trang 18](../../FRD_Package%20with%20multi%20currency.pdf#page=18).
**Diễn giải:** Hiển thị checkout amount theo currency đã chọn; FRD nêu Fee – Discount Amount.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 18 ---
Checkout
Amount
Read-only - - Format: [Fee – Discount Amount] [Currency]
~~~

<a id="ac-04-07"></a>

#### **AC-04-07 — Bảng mục tiêu challenge**

**Nguồn:** mục FRD 7.4.4; [trang 18](../../FRD_Package%20with%20multi%20currency.pdf#page=18).
**Diễn giải:** Cập nhật đơn vị các giá trị max loss/profit target theo currency đã chọn; giữ điều kiện của từng phase như FRD.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 18 ---
• Section 2: Challenge table – update currency for these fields based on the selected currency
(apply for Phase 1 and Funded Account):
◦ Max daily loss certain value:
▪ Current: 5% ($500)
▪ Expect new: 5% (500 USD); 5% (500 EUR),...
◦ Max total loss certain value:
▪ Current: 5% ($500)
▪ Expect new: 5% (500 USD); 5% (500 EUR),...
◦ Profit target certain value:
▪ Current: 5% ($500)
▪ Expect new: 5% (500 USD); 5% (500 EUR),...
~~~

<a id="ac-04-08"></a>

#### **AC-04-08 — Popup xác nhận customize**

**Nguồn:** mục FRD 7.4.4; [trang 18](../../FRD_Package%20with%20multi%20currency.pdf#page=18).
**Diễn giải:** Popup xác nhận trình bày các điều kiện và số tiền với currency đã chọn theo từng gói.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 18 ---
• Checkout Confirmation of Customize Challenge popup: Fee, Original Fee, Discount
Amount, Checkout Amount apply the same format and logic as the table above.
~~~

### 05. [cTrader package] Phase 1 of multicurrency for cTrader

Màn cTrader mô tả USD chọn được, currency khác hiển thị nhưng bị khóa với tooltip Coming soon; phần scope lại loại luồng multicurrency cTrader khỏi release.

<a id="ac-05-01"></a>

#### **AC-05-01 — AC chung**

**Nguồn:** mục FRD 7.5.4; [trang 19](../../FRD_Package%20with%20multi%20currency.pdf#page=19).
**Diễn giải:** Màn cTrader mô tả USD chọn được, currency khác hiển thị nhưng bị khóa với tooltip Coming soon; phần scope lại loại luồng multicurrency cTrader khỏi release.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-02](#q-02) — **Chờ trả lời:** Trong release này, màn FO cTrader có cần hiển thị USD chọn được và các currency khác disabled/Coming soon như 7.5, hay chỉ BO cần chuẩn bị tab cTrader?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 19 ---
− Display currency setup
o Display all currency configurations set up for the cTrader tab.
o Refer to US Currency List in FRD_Package with FRD_Package with multi
currency.docx)
− Currency availability
o USD: Enabled and selectable.
o Other currencies: Displayed but disabled.
▪ When the user hovers over a disabled currency, display the tooltip:
“Coming soon”.
− Apply for 1-Phase challenge, 2-Phase Challenge and instant of cTrader
~~~

### 06. [2-Phase Challenge_Customize package] Select multi-currency for customize

Tùy chỉnh 2-Phase theo currency: hiển thị danh sách, giới hạn balance, phí và các giá trị mục tiêu cho từng phase.

<a id="ac-06-01"></a>

#### **AC-06-01 — Chọn currency**

**Nguồn:** mục FRD 7.6.4; [trang 21](../../FRD_Package%20with%20multi%20currency.pdf#page=21), [trang 22](../../FRD_Package%20with%20multi%20currency.pdf#page=22).
**Diễn giải:** Người dùng chọn currency được phép hiển thị; thứ tự, mặc định, cờ và cách hiển thị theo thiết bị tuân theo mô tả gốc bên dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 21 ---
Field
Name
Type Required - Description
Currency Radio button Yes
- Lists all ACTIVE currencies in BO →
Customize Package Configuration →
Currency List
==> Get currency has toggle ON for field Display on
Customized package? on Currency List.
- Display the all currency list in a maximum of
2 lines by default.
o If the currency list contains more than
2 lines, display the “+More” button at
the end of the second line.
o When the user clicks “+More”:
Display the full currency list.
▪ Replace “+More” with a
“Less” button.
o When the user clicks “Less”:
▪ Collapse the currency list back
to 2 lines.
▪ Display the “+More” button
again if the currency list still
exceeds 2 lines.
- By default, the first currency in the list is
selected.
- Sort currencies according to the No. order
configured in BO.
- Tooltips: "The currency you choose here
applies to your package of payment, initial
balance and payouts."
--- Trang 22 ---
- Currency Flag: Display the flag configured
for each currency in the Currency Rate list.
Refer to US Currency Rate list in
FRD_Package with multi currency.docx
~~~

<a id="ac-06-02"></a>

#### **AC-06-02 — Số dư ban đầu**

**Nguồn:** mục FRD 7.6.4; [trang 22](../../FRD_Package%20with%20multi%20currency.pdf#page=22).
**Diễn giải:** Khi đổi currency, hiển thị đơn vị tương ứng; giữ giá trị số đã nhập và áp dụng giới hạn của currency đó như FRD mô tả.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-03](#q-03) — **Chờ trả lời:** Balance ở customize là trường user nhập hay read-only? Nếu nhập trước rồi đổi currency thì giữ nguyên số và revalidate theo giới hạn mới đúng không?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 22 ---
Balance
Number (read-only
display, currency-
dependent)
Yes
- Updates its displayed currency unit
immediately when Currency selection
changes
- Allowed range: depend on each currency. If
out of range, display error message: “The
balance must be within [Minimum initial
balance] [Currency] and [Maximum initial
balance] [Currency]”
- If user enters a Balance value first, then
changes Currency: the entered numeric
amount is retained; only the currency unit
updates
- Format: [Balance] [Currency]
~~~

<a id="ac-06-03"></a>

#### **AC-06-03 — Phí**

**Nguồn:** mục FRD 7.6.4; [trang 22](../../FRD_Package%20with%20multi%20currency.pdf#page=22).
**Diễn giải:** Hiển thị giá trị phí với currency đã chọn, sử dụng công thức hoặc cấu hình được FRD tham chiếu.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 22 ---
Fee Read-only —
- Format: [Fee] [Currency]
- Value sourced from the existing fee
calculation logic (Refer US: Calculate fee for
the customize package)
~~~

<a id="ac-06-04"></a>

#### **AC-06-04 — Phí gốc**

**Nguồn:** mục FRD 7.6.4; [trang 22](../../FRD_Package%20with%20multi%20currency.pdf#page=22).
**Diễn giải:** Hiển thị giá trị phí với currency đã chọn, sử dụng công thức hoặc cấu hình được FRD tham chiếu.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 22 ---
Original
Fee
Read-only —
- Format: [Original Fee] [Currency]
- Value sourced from the existing fee
calculation logic (Refer US: Calculate fee for
the customize package)
~~~

<a id="ac-06-05"></a>

#### **AC-06-05 — Giảm giá**

**Nguồn:** mục FRD 7.6.4; [trang 22](../../FRD_Package%20with%20multi%20currency.pdf#page=22), [trang 23](../../FRD_Package%20with%20multi%20currency.pdf#page=23).
**Diễn giải:** Discount cố định USD được nhân tỷ giá; discount phần trăm giữ nguyên tỷ lệ.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 22 ---
Discount
Amount
Read-only —
- For fixed-amount discount type:
o Discount Amount = Discount Amount
(USD) * Currency Rate (Currency
Rate from BO → Package → Multi-
Currency → Currency Rate)
--- Trang 23 ---
- For percentage discount type displays the
corresponding percentage value directly (no
conversion needed)
~~~

<a id="ac-06-06"></a>

#### **AC-06-06 — Số tiền checkout**

**Nguồn:** mục FRD 7.6.4; [trang 23](../../FRD_Package%20with%20multi%20currency.pdf#page=23).
**Diễn giải:** Hiển thị checkout amount theo currency đã chọn; FRD nêu Fee – Discount Amount.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 23 ---
Checkout
Amount
Read-only - - Format: [Fee – Discount Amount] [Currency]
~~~

<a id="ac-06-07"></a>

#### **AC-06-07 — Bảng mục tiêu challenge**

**Nguồn:** mục FRD 7.6.4; [trang 23](../../FRD_Package%20with%20multi%20currency.pdf#page=23).
**Diễn giải:** Cập nhật đơn vị các giá trị max loss/profit target theo currency đã chọn; giữ điều kiện của từng phase như FRD.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 23 ---
• Section 2: Challenge table – update currency for these fields based on the selected currency
(apply for Phase 1 and Funded Account):
◦ Max daily loss certain value:
▪ Current: 5% ($500)
▪ Expect new: 5% (500 USD); 5% (500 EUR),...
◦ Max total loss certain value:
▪ Current: 5% ($500)
▪ Expect new: 5% (500 USD); 5% (500 EUR),...
◦ Profit target certain value:
▪ Current: 5% ($500)
▪ Expect new: 5% (500 USD); 5% (500 EUR),...
~~~

<a id="ac-06-08"></a>

#### **AC-06-08 — Popup xác nhận customize**

**Nguồn:** mục FRD 7.6.4; [trang 23](../../FRD_Package%20with%20multi%20currency.pdf#page=23).
**Diễn giải:** Popup xác nhận trình bày các điều kiện và số tiền với currency đã chọn theo từng gói.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 23 ---
• Checkout Confirmation of Customize Challenge popup: Fee, Original Fee, Discount
Amount, Checkout Amount apply the same format and logic as the table above.
~~~

<a id="ac-06-09"></a>

#### **AC-06-09 — Danh sách thông báo lỗi**

**Nguồn:** mục FRD 7.6.4; [trang 23](../../FRD_Package%20with%20multi%20currency.pdf#page=23).
**Diễn giải:** Tùy chỉnh 2-Phase theo currency: hiển thị danh sách, giới hạn balance, phí và các giá trị mục tiêu cho từng phase. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 23 ---
Error Message Summary
Error Code Error Message
MCR_ERR_001 Please fill out this field
~~~

### 07. [1-Phase Challenge_Customize package] Select multi-currency for customize

Tùy chỉnh 1-Phase theo currency; ngoài giới hạn theo currency, balance chỉ nhận số nguyên là bội số của 1.000 và phí dựa trên cấu hình của currency đó.

<a id="ac-07-01"></a>

#### **AC-07-01 — Chọn currency**

**Nguồn:** mục FRD 7.7.4; [trang 25](../../FRD_Package%20with%20multi%20currency.pdf#page=25).
**Diễn giải:** Người dùng chọn currency được phép hiển thị; thứ tự, mặc định, cờ và cách hiển thị theo thiết bị tuân theo mô tả gốc bên dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 25 ---
Refer to US Customize Challenge Plan and Challenge – Checkout Confirmation of
Customize Challenge in FRD_FO_One-Phase Package.docx
Field
Name
Type Required • Description
Currency Radio
button
Yes • Lists all ACTIVE currencies in BO → Customize
Package Configuration → Currency List
==> Get currency has toggle ON for field Display on
Customized package? on Currency List.
◦ For mobile/web view, show all currency.
• By default, the first currency in the list is selected.
• Sort currencies according to the No. order configured in
BO.
• Tooltips: "The currency you choose here applies to your
package of payment, initial balance and payouts."
• Currency Flag: Display the flag configured for each
currency in the Currency Rate list. Refer to US Currency
Rate list in FRD_Package with multi currency.docx
~~~

<a id="ac-07-02"></a>

#### **AC-07-02 — Số dư ban đầu**

**Nguồn:** mục FRD 7.7.4; [trang 25](../../FRD_Package%20with%20multi%20currency.pdf#page=25), [trang 26](../../FRD_Package%20with%20multi%20currency.pdf#page=26).
**Diễn giải:** Khi đổi currency, hiển thị đơn vị tương ứng; giữ giá trị số đã nhập và áp dụng giới hạn của currency đó như FRD mô tả.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-03](#q-03) — **Chờ trả lời:** Balance ở customize là trường user nhập hay read-only? Nếu nhập trước rồi đổi currency thì giữ nguyên số và revalidate theo giới hạn mới đúng không?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 25 ---
Balance Number
(read-only
display,
currency-
dependent)
Yes • Updates its displayed currency unit immediately when
Currency selection changes
• Allowed range: depend on each currency (BO → 1-
Phase Challenge → Customize 1-Phase Challenge →
Initial Balance of the selected currency). If out of range,
display error message: "The balance must be within
[Minimum initial balance] [Currency] and [Maximum
initial balance] [Currency]"
• Keep the current validation: only accept integers,
multiple of 1000 ("The initial balance must be a multiple
of 1000")
• If user enters a Balance value first, then changes
--- Trang 26 ---
Currency: the entered numeric amount is retained; only
the currency unit updates
• Format: [Balance] [Currency]
• Tooltip: "Starting a trading account with virtual fund of
[Minimum initial balance] [Currency] and scale up to
[Maximum initial balance] [Currency] to trade"
~~~

<a id="ac-07-03"></a>

#### **AC-07-03 — Phí**

**Nguồn:** mục FRD 7.7.4; [trang 26](../../FRD_Package%20with%20multi%20currency.pdf#page=26).
**Diễn giải:** Hiển thị giá trị phí với currency đã chọn, sử dụng công thức hoặc cấu hình được FRD tham chiếu.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 26 ---
Fee Read-only — • Format: [Fee] [Currency]
• Value sourced from the existing fee calculation logic:
Fee = Initial Balance * X, X is configured for the selected
currency in BO → 1-Phase Challenge → Customize 1-
Phase Challenge → Fee
~~~

<a id="ac-07-04"></a>

#### **AC-07-04 — Phí gốc**

**Nguồn:** mục FRD 7.7.4; [trang 26](../../FRD_Package%20with%20multi%20currency.pdf#page=26).
**Diễn giải:** Hiển thị giá trị phí với currency đã chọn, sử dụng công thức hoặc cấu hình được FRD tham chiếu.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 26 ---
Original
Fee
Read-only — • Format: [Original Fee] [Currency]
• Value sourced from the existing fee calculation logic:
Original fee = [(Fee) + (Fee * Original fee %)], Original
fee % is configured for the selected currency in BO → 1-
Phase Challenge → Customize 1-Phase Challenge → Fee
~~~

<a id="ac-07-05"></a>

#### **AC-07-05 — Giảm giá**

**Nguồn:** mục FRD 7.7.4; [trang 26](../../FRD_Package%20with%20multi%20currency.pdf#page=26).
**Diễn giải:** Discount cố định USD được nhân tỷ giá; discount phần trăm giữ nguyên tỷ lệ.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 26 ---
Discount
Amount
Read-only — • For fixed-amount discount type:
◦ Discount Amount = Discount Amount (USD) *
Currency Rate (Currency Rate from BO → Package →
Multi-Currency → Currency Rate)
• For percentage discount type displays the corresponding
percentage value directly (no conversion needed)
~~~

<a id="ac-07-06"></a>

#### **AC-07-06 — Số tiền checkout**

**Nguồn:** mục FRD 7.7.4; [trang 26](../../FRD_Package%20with%20multi%20currency.pdf#page=26).
**Diễn giải:** Hiển thị checkout amount theo currency đã chọn; FRD nêu Fee – Discount Amount.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 26 ---
Checkout
Amount
Read-only - • Format: [Fee – Discount Amount] [Currency]
~~~

<a id="ac-07-07"></a>

#### **AC-07-07 — Bảng mục tiêu challenge**

**Nguồn:** mục FRD 7.7.4; [trang 26](../../FRD_Package%20with%20multi%20currency.pdf#page=26), [trang 27](../../FRD_Package%20with%20multi%20currency.pdf#page=27).
**Diễn giải:** Cập nhật đơn vị các giá trị max loss/profit target theo currency đã chọn; giữ điều kiện của từng phase như FRD.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 26 ---
• Section 2: Challenge table – update currency for these fields based on the selected currency
(apply for Phase 1 and Funded Account):
◦ Max daily loss certain value:
--- Trang 27 ---
▪ Current: 5% ($500)
▪ Expect new: 5% (500 USD); 5% (500 EUR),...
◦ Max total loss certain value:
▪ Current: 5% ($500)
▪ Expect new: 5% (500 USD); 5% (500 EUR),...
◦ Profit target certain value:
▪ Current: 5% ($500)
▪ Expect new: 5% (500 USD); 5% (500 EUR),...
~~~

<a id="ac-07-08"></a>

#### **AC-07-08 — Popup xác nhận customize**

**Nguồn:** mục FRD 7.7.4; [trang 27](../../FRD_Package%20with%20multi%20currency.pdf#page=27).
**Diễn giải:** Popup xác nhận trình bày các điều kiện và số tiền với currency đã chọn theo từng gói.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 27 ---
• Checkout Confirmation of Customize Challenge popup: Fee, Original Fee, Discount
Amount, Checkout Amount apply the same format and logic as the table above.
~~~

<a id="ac-07-09"></a>

#### **AC-07-09 — Danh sách thông báo lỗi**

**Nguồn:** mục FRD 7.7.4; [trang 27](../../FRD_Package%20with%20multi%20currency.pdf#page=27).
**Diễn giải:** Tùy chỉnh 1-Phase theo currency; ngoài giới hạn theo currency, balance chỉ nhận số nguyên là bội số của 1.000 và phí dựa trên cấu hình của currency đó. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 27 ---
Error Message Summary
Error Code Error Message
MCR_ERR_001 Please fill out this field
~~~

### 08. [Instant] Checkout with multicurrency package

Checkout Instant giữ currency được chọn, đổi equivalent amount theo currency phương thức thanh toán, ghi dữ liệu giao dịch và chuyển đổi USD cho các hệ thống liên quan.

<a id="ac-08-01"></a>

#### **AC-08-01 — AC chung**

**Nguồn:** mục FRD 7.8.4; [trang 28](../../FRD_Package%20with%20multi%20currency.pdf#page=28).
**Diễn giải:** Checkout Instant giữ currency được chọn, đổi equivalent amount theo currency phương thức thanh toán, ghi dữ liệu giao dịch và chuyển đổi USD cho các hệ thống liên quan.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 28 ---
• In check out screen:
◦ At Initial Balance field of the package information:
▪ Format: [Initial Balance] [Currency]. Example: 10,000 USD
◦ Currency of Checkout amount is selected currency
◦ Discount amount: Currency of discount amount is selected currency
▪ For fixed-amount discount type:
• Discount Amount = Discount Amount (USD) * Currency Rate
(Currency Rate from BO → Package → Multi-Currency →
Currency Rate)
▪ For percentage discount type displays the corresponding percentage value
directly (no conversion needed)
~~~

<a id="ac-08-02"></a>

#### **AC-08-02 — Phí xử lý**

**Nguồn:** mục FRD 7.8.4; [trang 29](../../FRD_Package%20with%20multi%20currency.pdf#page=29).
**Diễn giải:** Quy đổi processing fee sang currency đã chọn theo Currency Rate cấu hình ở BO.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 29 ---
◦ Processing Fee: convert to the selected currency (use Currency Rate from Currency
Rate from BO → Package → Multi-Currency → Currency Rate)
~~~

<a id="ac-08-03"></a>

#### **AC-08-03 — Quy đổi sang tiền tệ phương thức thanh toán**

**Nguồn:** mục FRD 7.8.4; [trang 29](../../FRD_Package%20with%20multi%20currency.pdf#page=29).
**Diễn giải:** Cùng currency thì giữ nguyên; nếu thanh toán USD thì chia tỷ giá; nếu currency phương thức khác USD, chuyển qua USD rồi nhân tỷ giá Country.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 29 ---
◦ Equivalent amount: convert to payment method currency:
▪ If the selected currency is the same with payment method currency, do not
convert anything.
• Example: package 30 JPY, do not use convert from Country to
convert equivalent amount, keep that value for payment method.
• Note: still convert to USD (use Currency Rate from Currency Rate
from BO → Package → Multi-Currency → Currency Rate) to
display value by USD for Wallet Transaction
▪ If the payment method requires currency USD and user checkout with
multicurrency # USD => use Currency Rate from Currency Rate from BO
→ Package → Multi-Currency → Currency Rate.
• Equivalent amount = Checkout amount [Currency] / Currency Rate
▪ If the payment method currency is not USD and the selected currency
(Checkout amount) is also not USD.
• Convert layer 1: Convert checkout amount to USD:
o Use Currency Rate from Currency Rate from BO →
Package → Multi-Currency → Currency Rate: Formula =
Checkout amount / Currency Rate
• Convert layer 2: Convert USD to payment method currency:
o Use Currency Rate from BO > Country > Currency:
Formula Equivalent amount = Convert to USD amount *
Rate.
~~~

<a id="ac-08-04"></a>

#### **AC-08-04 — Lịch sử giao dịch**

**Nguồn:** mục FRD 7.8.4; [trang 29](../../FRD_Package%20with%20multi%20currency.pdf#page=29).
**Diễn giải:** Ghi/hiển thị số gốc, số quy đổi USD và equivalent amount theo từng currency nêu trong AC.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-07](#q-07) — **Chờ trả lời:** FO Transaction History hiển thị Convert to USD là dấu “-” khi Amount là USD, còn BO hiển thị lại giá trị USD: đây có phải khác biệt có chủ đích? Với giao dịch cũ không gắn package, Balance Currency là USD hay “—”?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 29 ---
• Transaction History:
◦ Amount: Format [Checkout amount] [Currency]
◦ Convert to USD: Format: [Checkout amount] USD. Convert the Checkout Amount to
USD based on the stored conversion rate. (this is new column next to Amount field)
▪ When the amount field is USD, display “-” in this field.
◦ Equivalent amount: [Equivalent amount] [Payment method currency]
~~~

<a id="ac-08-05"></a>

#### **AC-08-05 — Tạo trading account**

**Nguồn:** mục FRD 7.8.4; [trang 29](../../FRD_Package%20with%20multi%20currency.pdf#page=29), [trang 30](../../FRD_Package%20with%20multi%20currency.pdf#page=30).
**Diễn giải:** Tạo tài khoản theo giai đoạn và giữ currency/group được chỉ ra trong AC; không suy ra kết quả runtime.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Chỉ phần thao tác nếu có trong mục AC.
- **Backend:** Điều phối yêu cầu và truyền currency/group theo AC.
- **Internal Service:** Ứng viên: dịch vụ trading/tạo tài khoản; chưa có code chứng minh ownership.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 29 ---
• Create trading account:
--- Trang 30 ---
◦ When Trader completed checkout with the selected currency, The trading account
creation process runs:
▪ The trading account record stores Currency = the selected currency
~~~

<a id="ac-08-06"></a>

#### **AC-08-06 — Hoa hồng affiliate**

**Nguồn:** mục FRD 7.8.4; [trang 30](../../FRD_Package%20with%20multi%20currency.pdf#page=30).
**Diễn giải:** Checkout Instant giữ currency được chọn, đổi equivalent amount theo currency phương thức thanh toán, ghi dữ liệu giao dịch và chuyển đổi USD cho các hệ thống liên quan. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 30 ---
• Affiliate:
◦ For the AP commission calculation, convert Checkout amount to USD (in case the
selected currency # USD)
▪ Formula = Checkout amount (Currency) / Currency Rate (Get Currency
Rate from BO > Package Management > Multicurrency > Currency Rate
management)
◦ Email:
▪ For field Checkout Amount: [Checkout Amount] USD in Email: apply
value after converting to USD of checkout amount.
• Example: Checkout amount = 30 EUR => 34.84 USD ==> Display
34.84 in email and keep unit USD.
▪ Email applies:
• AF4 - Inform AP has new commission transaction: WMT_Email
& Notification.xlsx
• AF8 - Reject Commission Transaction: WMT_Email &
Notification.xlsx
~~~

<a id="ac-08-07"></a>

#### **AC-08-07 — Bring a Friend**

**Nguồn:** mục FRD 7.8.4; [trang 30](../../FRD_Package%20with%20multi%20currency.pdf#page=30).
**Diễn giải:** Checkout Instant giữ currency được chọn, đổi equivalent amount theo currency phương thức thanh toán, ghi dữ liệu giao dịch và chuyển đổi USD cho các hệ thống liên quan. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 30 ---
• Bring a Friend:
◦ For the BAF calculation, convert Checkout amount of Referrals to USD (in case the
selected currency # USD)
▪ Formula = Checkout amount (Currency) / Currency Rate (Get Currency
Rate from BO > Package Management > Multicurrency > Currency Rate
management)
~~~

<a id="ac-08-08"></a>

#### **AC-08-08 — Ví USD**

**Nguồn:** mục FRD 7.8.4; [trang 30](../../FRD_Package%20with%20multi%20currency.pdf#page=30).
**Diễn giải:** Checkout Instant giữ currency được chọn, đổi equivalent amount theo currency phương thức thanh toán, ghi dữ liệu giao dịch và chuyển đổi USD cho các hệ thống liên quan. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 30 ---
• Wallet:
◦ For the type Purchase: Amount must convert to USD: refer to above checkout AC.
~~~

<a id="ac-08-09"></a>

#### **AC-08-09 — E-contract DocuSeal**

**Nguồn:** mục FRD 7.8.4; [trang 30](../../FRD_Package%20with%20multi%20currency.pdf#page=30).
**Diễn giải:** Truyền hoặc hiển thị one-time fee và initial balance cùng currency trên e-contract.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 30 ---
• Docuseal
◦ One time Fee: [Checkout amount] [Currency]
◦ Initial balance: [Initial balance] [Currency]
~~~

<a id="ac-08-10"></a>

#### **AC-08-10 — HubSpot**

**Nguồn:** mục FRD 7.8.4; [trang 30](../../FRD_Package%20with%20multi%20currency.pdf#page=30), [trang 31](../../FRD_Package%20with%20multi%20currency.pdf#page=31).
**Diễn giải:** Checkout Instant giữ currency được chọn, đổi equivalent amount theo currency phương thức thanh toán, ghi dữ liệu giao dịch và chuyển đổi USD cho các hệ thống liên quan. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 30 ---
• Hubspot
--- Trang 31 ---
◦ Amount: USD
◦ Get amount convert to USD to hubspot
▪ Formula = Checkout amount (Currency) / Currency Rate (Get Currency
Rate from BO > Package Management > Multicurrency > Currency Rate
management)
◦ One time Fee: [Checkout amount] [Currency]
◦ Initial balance: [Initial balance] [Currency]
~~~

<a id="ac-08-11"></a>

#### **AC-08-11 — Email**

**Nguồn:** mục FRD 7.8.4; [trang 32](../../FRD_Package%20with%20multi%20currency.pdf#page=32).
**Diễn giải:** Cập nhật nội dung hoặc định dạng tiền trong các email được FRD liệt kê.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 32 ---
- Update Email:
◦ Require:
▪ Change unit of Initial balance to the selected currency: Format: [Initial
balance] [Currency].
• Example: 10,000 EUR
▪ Payment detail: Change unit of amount to the selected currency for these
fields: Onetime Fee, Discount Amount, Checkout Amount.
• Example: 10,000 EUR
◦ Apply for these emails:
▪ Email 45 – ID: E000029: Check out successful (One-time payment -
Forex/Crypto/Stock) WMT_Email & Notification.xlsx
▪ Email 60 – ID: E000045: Check out successful (One-time payment -
Forex/Crypto/Stock) - for country do not send E-contract WMT_Email &
Notification.xlsx
▪ Email 23 – ID: E000011: Announcement of user’s successful payment
WMT_Email & Notification.xlsx
▪ Email 48 – ID: E000032: Checkout with Bank Transfer - VietLocalPay
WMT_Email & Notification.xlsx
▪ Email 30 – ID: E000018: Checkout with Bank Transfer WMT_Email &
Notification.xlsx
~~~

### 09. [2-Phase Challenge] Checkout with multicurrency package

Checkout 2-Phase kế thừa quy tắc Instant, đồng thời tài khoản phase 1 phải lưu currency được chọn và cập nhật các thông báo liên quan.

<a id="ac-09-01"></a>

#### **AC-09-01 — AC chung**

**Nguồn:** mục FRD 7.9.3; [trang 32](../../FRD_Package%20with%20multi%20currency.pdf#page=32), [trang 33](../../FRD_Package%20with%20multi%20currency.pdf#page=33).
**Diễn giải:** Checkout 2-Phase kế thừa quy tắc Instant, đồng thời tài khoản phase 1 phải lưu currency được chọn và cập nhật các thông báo liên quan.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 32 ---
https://www.figma.com/design/UiqMA8LpajKAj7jAsDknjf/-FO--WEMASTERTRADE--
2024-?node-id=39251-172126&t=p5giHIQRuvK1ZqDD-4
--- Trang 33 ---
• In check out screen (as the same [Instant] Checkout with multicurrency package)
◦ At Initial Balance field of the package information:
▪ Format: [Initial Balance] [Currency]. Example: 10,000 USD
◦ Currency of Checkout amount is selected currency
◦ Discount amount: Currency of discount amount is selected currency
▪ For fixed-amount discount type:
• Discount Amount = Discount Amount (USD) * Currency Rate
(Currency Rate from BO → Package → Multi-Currency →
Currency Rate)
▪ For percentage discount type displays the corresponding percentage value
directly (no conversion needed)
~~~

<a id="ac-09-02"></a>

#### **AC-09-02 — Phí xử lý**

**Nguồn:** mục FRD 7.9.3; [trang 34](../../FRD_Package%20with%20multi%20currency.pdf#page=34).
**Diễn giải:** Quy đổi processing fee sang currency đã chọn theo Currency Rate cấu hình ở BO.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 34 ---
◦ Processing Fee: convert to the selected currency (use Currency Rate from Currency
Rate from BO → Package → Multi-Currency → Currency Rate)
~~~

<a id="ac-09-03"></a>

#### **AC-09-03 — Quy đổi sang tiền tệ phương thức thanh toán**

**Nguồn:** mục FRD 7.9.3; [trang 34](../../FRD_Package%20with%20multi%20currency.pdf#page=34).
**Diễn giải:** Cùng currency thì giữ nguyên; nếu thanh toán USD thì chia tỷ giá; nếu currency phương thức khác USD, chuyển qua USD rồi nhân tỷ giá Country.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 34 ---
◦ Equivalent amount: convert to payment method currency:
▪ If the selected currency is the same with payment method currency, do not
convert anything.
• Example: package 30 JPY, do not use convert from Country to
convert equivalent amount, keep that value for payment method.
• Note: still convert to USD (use Currency Rate from Currency Rate
from BO → Package → Multi-Currency → Currency Rate) to
display value by USD for Wallet Transaction
▪ If the payment method requires currency USD and user checkout with
multicurrency # USD => use Currency Rate from Currency Rate from BO
→ Package → Multi-Currency → Currency Rate.
• Equivalent amount = Checkout amount [Currency] / Currency Rate
▪ If the payment method currency is not USD and the selected currency
(Checkout amount) is also not USD.
• Convert layer 1: Convert checkout amount to USD:
o Use Currency Rate from Currency Rate from BO →
Package → Multi-Currency → Currency Rate: Formula =
Checkout amount / Currency Rate
• Convert layer 2: Convert USD to payment method currency:
o Use Currency Rate from BO > Country > Currency:
Formula Equivalent amount = Convert to USD amount *
Rate.
~~~

<a id="ac-09-04"></a>

#### **AC-09-04 — Lịch sử giao dịch**

**Nguồn:** mục FRD 7.9.3; [trang 34](../../FRD_Package%20with%20multi%20currency.pdf#page=34).
**Diễn giải:** Ghi/hiển thị số gốc, số quy đổi USD và equivalent amount theo từng currency nêu trong AC.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-07](#q-07) — **Chờ trả lời:** FO Transaction History hiển thị Convert to USD là dấu “-” khi Amount là USD, còn BO hiển thị lại giá trị USD: đây có phải khác biệt có chủ đích? Với giao dịch cũ không gắn package, Balance Currency là USD hay “—”?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 34 ---
• Transaction History: (as the same [Instant] Checkout with multicurrency package)
◦ Amount: Format [Checkout amount] [Currency]
◦ Convert to USD: Format: [Checkout amount] USD. Convert the Checkout Amount to
USD based on the stored conversion rate. (this is new column next to Amount field)
▪ When the amount field is USD, display “-” in this field.
◦ Equivalent amount: [Equivalent amount] [Payment method currency]
~~~

<a id="ac-09-05"></a>

#### **AC-09-05 — Hoa hồng affiliate**

**Nguồn:** mục FRD 7.9.3; [trang 34](../../FRD_Package%20with%20multi%20currency.pdf#page=34), [trang 35](../../FRD_Package%20with%20multi%20currency.pdf#page=35).
**Diễn giải:** Checkout 2-Phase kế thừa quy tắc Instant, đồng thời tài khoản phase 1 phải lưu currency được chọn và cập nhật các thông báo liên quan. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 34 ---
• Affiliate: (as the same [Instant] Checkout with multicurrency package)
--- Trang 35 ---
◦ For the AP commission calculation, convert Checkout amount to USD (in case the
selected currency # USD)
▪ Formula = Checkout amount (Currency) / Currency Rate (Get Currency
Rate from BO > Package Management > Multicurrency > Currency Rate
management)
◦ Email:
▪ For field Checkout Amount: [Checkout Amount] USD in Email: apply
value after converting to USD of checkout amount.
• Example: Checkout amount = 30 EUR => 34.84 USD ==> Display
34.84 in email and keep unit USD.
▪ Email applies:
• AF4 - Inform AP has new commission transaction: WMT_Email
& Notification.xlsx
• AF8 - Reject Commission Transaction: WMT_Email &
Notification.xlsx
~~~

<a id="ac-09-06"></a>

#### **AC-09-06 — Bring a Friend**

**Nguồn:** mục FRD 7.9.3; [trang 35](../../FRD_Package%20with%20multi%20currency.pdf#page=35).
**Diễn giải:** Checkout 2-Phase kế thừa quy tắc Instant, đồng thời tài khoản phase 1 phải lưu currency được chọn và cập nhật các thông báo liên quan. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 35 ---
• Bring a Friend: (as the same [Instant] Checkout with multicurrency package)
◦ For the BAF calculation, convert Checkout amount of Referrals to USD (in case the
selected currency # USD)
▪ Formula = Checkout amount (Currency) / Currency Rate (Get Currency
Rate from BO > Package Management > Multicurrency > Currency Rate
management)
~~~

<a id="ac-09-07"></a>

#### **AC-09-07 — Ví USD**

**Nguồn:** mục FRD 7.9.3; [trang 35](../../FRD_Package%20with%20multi%20currency.pdf#page=35).
**Diễn giải:** Checkout 2-Phase kế thừa quy tắc Instant, đồng thời tài khoản phase 1 phải lưu currency được chọn và cập nhật các thông báo liên quan. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 35 ---
• Wallet: (as the same [Instant] Checkout with multicurrency package)
◦ For the type Purchase: Amount must convert to USD: refer to above checkout AC.
~~~

<a id="ac-09-08"></a>

#### **AC-09-08 — Tạo trading account**

**Nguồn:** mục FRD 7.9.3; [trang 35](../../FRD_Package%20with%20multi%20currency.pdf#page=35).
**Diễn giải:** Tạo tài khoản theo giai đoạn và giữ currency/group được chỉ ra trong AC; không suy ra kết quả runtime.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Chỉ phần thao tác nếu có trong mục AC.
- **Backend:** Điều phối yêu cầu và truyền currency/group theo AC.
- **Internal Service:** Ứng viên: dịch vụ trading/tạo tài khoản; chưa có code chứng minh ownership.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 35 ---
• Create trading account:
◦ For phase 1:
▪ When Trader completed checkout with the selected currency, The trading
account creation process runs:
• The trading account of phase 1 stores Currency = the selected
currency
~~~

<a id="ac-09-09"></a>

#### **AC-09-09 — Email**

**Nguồn:** mục FRD 7.9.3; [trang 36](../../FRD_Package%20with%20multi%20currency.pdf#page=36).
**Diễn giải:** Cập nhật nội dung hoặc định dạng tiền trong các email được FRD liệt kê.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 36 ---
- Update Email:
◦ Require:
▪ Change unit of Initial balance to the selected currency: Format: [Initial
balance] [Currency].
• Example: 10,000 EUR
▪ Payment detail: Change unit of amount to the selected currency for these
fields: Onetime Fee, Discount Amount, Checkout Amount.
• Example: 10,000 EUR
◦ Apply for these emails:
▪ Email ID TSE0000016: Create Trading account for phase 1 - MT5
WCT_Email, notification, tooltips template.xlsx
▪ Email CL6 Announcement of user’s successful payment WMT_Email &
Notification.xlsx
▪ Email 48 – ID: E000032: Checkout with Bank Transfer - VietLocalPay
WMT_Email & Notification.xlsx
▪ Email 30 – ID: E000018: Checkout with Bank Transfer WMT_Email &
Notification.xlsx
~~~

<a id="ac-09-10"></a>

#### **AC-09-10 — HubSpot**

**Nguồn:** mục FRD 7.9.3; [trang 36](../../FRD_Package%20with%20multi%20currency.pdf#page=36).
**Diễn giải:** Checkout 2-Phase kế thừa quy tắc Instant, đồng thời tài khoản phase 1 phải lưu currency được chọn và cập nhật các thông báo liên quan. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 36 ---
• Hubspot:
◦ Amount: USD
◦ Get amount convert to USD to hubspot
▪ Formula = Checkout amount (Currency) / Currency Rate (Get Currency
Rate from BO > Package Management > Multicurrency > Currency Rate
management)
◦ One time Fee: [Checkout amount] [Currency]
◦ Initial balance: [Initial balance] [Currency
~~~

### 10. [1-Phase Challenge] Checkout with multicurrency package

Checkout 1-Phase kế thừa quy tắc 2-Phase; tài khoản phase 1 lưu currency và group cấu hình theo currency của package.

<a id="ac-10-01"></a>

#### **AC-10-01 — AC chung**

**Nguồn:** mục FRD 7.10.3; [trang 37](../../FRD_Package%20with%20multi%20currency.pdf#page=37).
**Diễn giải:** Checkout 1-Phase kế thừa quy tắc 2-Phase; tài khoản phase 1 lưu currency và group cấu hình theo currency của package.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 37 ---
https://www.figma.com/design/UiqMA8LpajKAj7jAsDknjf/-FO--WEMASTERTRADE--
2024-?node-id=39251-172126&t=p5giHIQRuvK1ZqDD-4
• In check out screen (as the same [2-Phase Challenge] Checkout with multicurrency package)
◦ At Initial Balance field of the package information:
▪ Format: [Initial Balance] [Currency]. Example: 10,000 USD
◦ Currency of Checkout amount is selected currency
◦ Discount amount: Currency of discount amount is selected currency
▪ For fixed-amount discount type:
• Discount Amount = Discount Amount (USD) * Currency Rate (Currency Rate
from BO → Package → Multi-Currency → Currency Rate)
▪ For percentage discount type displays the corresponding percentage value
directly (no conversion needed)
~~~

<a id="ac-10-02"></a>

#### **AC-10-02 — Phí xử lý**

**Nguồn:** mục FRD 7.10.3; [trang 37](../../FRD_Package%20with%20multi%20currency.pdf#page=37).
**Diễn giải:** Quy đổi processing fee sang currency đã chọn theo Currency Rate cấu hình ở BO.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 37 ---
◦ Processing Fee: convert to the selected currency (use Currency Rate from Currency
Rate from BO → Package → Multi-Currency → Currency Rate)
~~~

<a id="ac-10-03"></a>

#### **AC-10-03 — Quy đổi sang tiền tệ phương thức thanh toán**

**Nguồn:** mục FRD 7.10.3; [trang 37](../../FRD_Package%20with%20multi%20currency.pdf#page=37), [trang 38](../../FRD_Package%20with%20multi%20currency.pdf#page=38).
**Diễn giải:** Cùng currency thì giữ nguyên; nếu thanh toán USD thì chia tỷ giá; nếu currency phương thức khác USD, chuyển qua USD rồi nhân tỷ giá Country.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 37 ---
◦ Equivalent amount: convert to payment method currency:
▪ If the selected currency is the same with payment method currency, do not
convert anything.
• Example: package 30 JPY, do not use convert from Country to convert
equivalent amount, keep that value for payment method.
• Note: still convert to USD (use Currency Rate from Currency Rate from BO →
Package → Multi-Currency → Currency Rate) to display value by USD for
Wallet Transaction
--- Trang 38 ---
▪ If the payment method requires currency USD and user checkout with
multicurrency # USD => use Currency Rate from Currency Rate from BO
→ Package → Multi-Currency → Currency Rate.
• Equivalent amount = Checkout amount [Currency] / Currency Rate
▪ If the payment method currency is not USD and the selected currency
(Checkout amount) is also not USD.
• Convert layer 1: Convert checkout amount to USD:
◦ Use Currency Rate from Currency Rate from BO → Package → Multi-
Currency → Currency Rate: Formula = Checkout amount / Currency Rate
• Convert layer 2: Convert USD to payment method currency:
◦ Use Currency Rate from BO > Country > Currency: Formula Equivalent
amount = Convert to USD amount * Rate.
~~~

<a id="ac-10-04"></a>

#### **AC-10-04 — Lịch sử giao dịch**

**Nguồn:** mục FRD 7.10.3; [trang 38](../../FRD_Package%20with%20multi%20currency.pdf#page=38).
**Diễn giải:** Ghi/hiển thị số gốc, số quy đổi USD và equivalent amount theo từng currency nêu trong AC.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-07](#q-07) — **Chờ trả lời:** FO Transaction History hiển thị Convert to USD là dấu “-” khi Amount là USD, còn BO hiển thị lại giá trị USD: đây có phải khác biệt có chủ đích? Với giao dịch cũ không gắn package, Balance Currency là USD hay “—”?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 38 ---
• Transaction History: (as the same [2-Phase Challenge] Checkout with multicurrency
package)
◦ Amount: Format [Checkout amount] [Currency]
◦ Convert to USD: Format: [Checkout amount] USD. Convert the Checkout Amount to
USD based on the stored conversion rate. (this is new column next to Amount field)
▪ When the amount field is USD, display "-" in this field.
◦ Equivalent amount: [Equivalent amount] [Payment method currency]
~~~

<a id="ac-10-05"></a>

#### **AC-10-05 — Hoa hồng affiliate**

**Nguồn:** mục FRD 7.10.3; [trang 38](../../FRD_Package%20with%20multi%20currency.pdf#page=38).
**Diễn giải:** Checkout 1-Phase kế thừa quy tắc 2-Phase; tài khoản phase 1 lưu currency và group cấu hình theo currency của package. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 38 ---
• Affiliate: (as the same [2-Phase Challenge] Checkout with multicurrency package)
◦ For the AP commission calculation, convert Checkout amount to USD (in case the
selected currency # USD)
▪ Formula = Checkout amount (Currency) / Currency Rate (Get Currency
Rate from BO > Package Management > Multicurrency > Currency Rate
management)
◦ Email: For field Checkout Amount: [Checkout Amount] USD in Email: apply value
after converting to USD of checkout amount. Email applies: AF4, AF8
~~~

<a id="ac-10-06"></a>

#### **AC-10-06 — Bring a Friend**

**Nguồn:** mục FRD 7.10.3; [trang 38](../../FRD_Package%20with%20multi%20currency.pdf#page=38), [trang 39](../../FRD_Package%20with%20multi%20currency.pdf#page=39).
**Diễn giải:** Checkout 1-Phase kế thừa quy tắc 2-Phase; tài khoản phase 1 lưu currency và group cấu hình theo currency của package. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 38 ---
• Bring a Friend: (as the same [2-Phase Challenge] Checkout with multicurrency package)
◦ For the BAF calculation, convert Checkout amount of Referrals to USD (in case the
selected currency # USD)
--- Trang 39 ---
▪ Formula = Checkout amount (Currency) / Currency Rate (Get Currency
Rate from BO > Package Management > Multicurrency > Currency Rate
management)
~~~

<a id="ac-10-07"></a>

#### **AC-10-07 — Ví USD**

**Nguồn:** mục FRD 7.10.3; [trang 39](../../FRD_Package%20with%20multi%20currency.pdf#page=39).
**Diễn giải:** Checkout 1-Phase kế thừa quy tắc 2-Phase; tài khoản phase 1 lưu currency và group cấu hình theo currency của package. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 39 ---
• Wallet: (as the same [2-Phase Challenge] Checkout with multicurrency package)
◦ For the type Purchase: Amount must convert to USD: refer to above checkout AC.
~~~

<a id="ac-10-08"></a>

#### **AC-10-08 — Tạo trading account**

**Nguồn:** mục FRD 7.10.3; [trang 39](../../FRD_Package%20with%20multi%20currency.pdf#page=39).
**Diễn giải:** Tạo tài khoản theo giai đoạn và giữ currency/group được chỉ ra trong AC; không suy ra kết quả runtime.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Chỉ phần thao tác nếu có trong mục AC.
- **Backend:** Điều phối yêu cầu và truyền currency/group theo AC.
- **Internal Service:** Ứng viên: dịch vụ trading/tạo tài khoản; chưa có code chứng minh ownership.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 39 ---
• Create trading account:
◦ For phase 1: refer to US Create trading account for phase 1 when user check out
successfully FRD_FO_One-Phase Package.docx
▪ When Trader completed checkout with the selected currency, The trading
account creation process runs:
• The trading account of phase 1 stores Currency = the selected currency
• Group: the group configured for the selected currency (Supported Currency of
the package, or Customize 1-Phase Challenge → Groups of the selected
currency)
~~~

<a id="ac-10-09"></a>

#### **AC-10-09 — HubSpot**

**Nguồn:** mục FRD 7.10.3; [trang 39](../../FRD_Package%20with%20multi%20currency.pdf#page=39).
**Diễn giải:** Checkout 1-Phase kế thừa quy tắc 2-Phase; tài khoản phase 1 lưu currency và group cấu hình theo currency của package. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 39 ---
• Hubspot:
◦ Amount: USD
◦ Get amount convert to USD to hubspot
▪ Formula = Checkout amount (Currency) / Currency Rate (Get Currency
Rate from BO > Package Management > Multicurrency > Currency Rate
management)
◦ One time Fee: [Checkout amount] [Currency]
◦ Initial balance: [Initial balance] [Currency
~~~

<a id="ac-10-10"></a>

#### **AC-10-10 — Email**

**Nguồn:** mục FRD 7.10.3; [trang 39](../../FRD_Package%20with%20multi%20currency.pdf#page=39), [trang 40](../../FRD_Package%20with%20multi%20currency.pdf#page=40).
**Diễn giải:** Cập nhật nội dung hoặc định dạng tiền trong các email được FRD liệt kê.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 39 ---
• Update Email:
◦ Require:
▪ Change unit of Initial balance to the selected currency: Format: [Initial
balance] [Currency].
• Example: 10,000 EUR
▪ Payment detail: Change unit of amount to the selected currency for these
fields: Onetime Fee, Discount Amount, Checkout Amount.
• Example: 10,000 EUR
--- Trang 40 ---
◦ Apply for these emails:
▪ Email ID TSE0000016: Create Trading account for phase 1 - MT5
WCT_Email, notification, tooltips template.xlsx
▪ Email CL6 Announcement of user's successful payment WMT_Email &
Notification.xlsx
▪ Email 48 – ID: E000032: Checkout with Bank Transfer - VietLocalPay
WMT_Email & Notification.xlsx
▪ Email 30 – ID: E000018: Checkout with Bank Transfer WMT_Email &
Notification.xlsx
~~~

### 11. [2-Phase Challenge] Upgrade to phase in 2-Phase Challenge package

Khi nâng 2-Phase, phase 2 và funded giữ currency của phase 1; cập nhật thông tin trên certificate và email.

<a id="ac-11-01"></a>

#### **AC-11-01 — Tạo tài khoản giai đoạn tiếp theo**

**Nguồn:** mục FRD 7.11.4; [trang 40](../../FRD_Package%20with%20multi%20currency.pdf#page=40), [trang 41](../../FRD_Package%20with%20multi%20currency.pdf#page=41).
**Diễn giải:** Tạo tài khoản theo giai đoạn và giữ currency/group được chỉ ra trong AC; không suy ra kết quả runtime.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Chỉ phần thao tác nếu có trong mục AC.
- **Backend:** Điều phối yêu cầu và truyền currency/group theo AC.
- **Internal Service:** Ứng viên: dịch vụ trading/tạo tài khoản; chưa có code chứng minh ownership.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-10](#q-10) — **Chờ trả lời:** Khi currency đã bị xóa khỏi cấu hình, group nào phải được lưu và dùng lại cho phase tiếp theo: group tại thời điểm mua, tại phase trước, hay group khác?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 40 ---
• Create trading account:
◦ Phase 2: refer to Upgrading from Phase 1 to Phase 2 in the Challenge Plan
FRD_WMT_Challenge_FE-1.0.docx
▪ The currency of phase 2 is the same as phase 1.
▪ In case that currency is deleted for this balance, stored and use this group
for this phase.
◦ Funded Stage: refer to Upgrading from Phases 2 to Funded Account
FRD_WMT_Challenge_FE-1.0.docx
--- Trang 41 ---
▪ The currency of a funded account is the same as in phase 1.
▪ In case that currency is deleted for this balance, stored and use this group
for funded phase.
~~~

<a id="ac-11-02"></a>

#### **AC-11-02 — Chứng chỉ**

**Nguồn:** mục FRD 7.11.4; [trang 41](../../FRD_Package%20with%20multi%20currency.pdf#page=41).
**Diễn giải:** Điều chỉnh dữ liệu tiền/currency trên certificate theo từng giai đoạn.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 41 ---
• Certificate:
◦ Phase 1: Format of initial balance: [Initial balance] [Currency]
▪ Refer to US: Automatically generate a certificate of challenge when pass
the phase 1   FRD_WMT_Certificates_1.0.docx
◦ Phase 2: Format of initial balance: [Initial balance] [Currency]
▪ Refer to US: Automatically generate a certificate of challenge when pass
the phase 2  FRD_WMT_Certificates_1.0.docx
◦ Funded account: Format of initial balance: [Initial balance] [Currency]
▪ Refer to US: Automatically generate a certificate of challenge when user
confirms to Funded Account  FRD_WMT_Certificates_1.0.docx
~~~

<a id="ac-11-03"></a>

#### **AC-11-03 — Email**

**Nguồn:** mục FRD 7.11.4; [trang 41](../../FRD_Package%20with%20multi%20currency.pdf#page=41), [trang 42](../../FRD_Package%20with%20multi%20currency.pdf#page=42), [trang 43](../../FRD_Package%20with%20multi%20currency.pdf#page=43).
**Diễn giải:** Cập nhật nội dung hoặc định dạng tiền trong các email được FRD liệt kê.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-02](#q-02) — **Chờ trả lời:** Trong release này, màn FO cTrader có cần hiển thị USD chọn được và các currency khác disabled/Coming soon như 7.5, hay chỉ BO cần chuẩn bị tab cTrader?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 41 ---
• Update Email:
◦ Require:
▪ Change unit of Initial balance to the selected currency: Format: [Initial
balance] [Currency].
• Example: 10,000 EUR
◦ Apply for these emails:
▪ Scope for MT5
• TSE0000017 Create trading account for phase 2 WCT_Email,
notification, tooltips template.xlsx
• TSE0000018 Create trading account for Funded Account
WCT_Email, notification, tooltips template.xlsx
• TSE000005, Reach Rish Consistency [RC value of Option 1]%
first time (Current balance ≥ Initial balance)
• TSE000006, Reach Rish Consistency [RC value of Option 1]%
second time
• TSE000007, Reach Rish Consistency [RC value of Option 2]%
first time (Current balance ≥ Initial balance)
--- Trang 42 ---
• TSE000008, Reach Rish Consistency second time  (For [RC value
of Option 2])
• TSE000009, Create demo trading account
• TSE000010, Reach Rish Consistency  [RC value of Option 1]%
first time (Current balance < Initial balance)
• TSE0000011, Reach Rish Consistency [RC value of Option 2]%
first time (Current balance < Initial balance)
• TSE0000012, Trading account is breaching RC in phase 1
• TSE0000013, Trading account is disabled trading function due to
breaching RC 1st
• TSE0000014, Trading account is terminated due to breaching RC
2nd
• TSE0000015, Trading account is terminated due to breaching RC-
Funded Account
• TSE0000016, Create Trading account for phase 1
• TSE0000017, Create trading account for phase 2
• TSE0000018, Create trading account for Funded Account
• TSE0000019, Failed a Challenge
• TSE0000021, Reach Max Total Loss
▪ Scope for CTrader
• TSE0000020, Trading account is terminated due to breaching RC
(RCT)
• TSE0000022, Create master account
• TSE0000023, Create demo trading account for Match Trader /
cTrader
• TSE0000024, Create Trading account for phase 1 (Match
Trader/cTrader)
• TSE0000025, Create trading account for phase 2 (Match
Trader/ctrader)
--- Trang 43 ---
• TSE0000026, Create trading account for Funded Account (Match
Trader/ctrader)
~~~

### 12. [1-Phase Challenge] Upgrade to Funded Account in 1-Phase Challenge

Khi nâng 1-Phase lên funded, request và tài khoản funded giữ currency của phase 1; certificate, e-contract và email thể hiện đơn vị tương ứng.

<a id="ac-12-01"></a>

#### **AC-12-01 — Yêu cầu lên funded**

**Nguồn:** mục FRD 7.12.4; [trang 43](../../FRD_Package%20with%20multi%20currency.pdf#page=43).
**Diễn giải:** Khi nâng 1-Phase lên funded, request và tài khoản funded giữ currency của phase 1; certificate, e-contract và email thể hiện đơn vị tương ứng. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Chỉ phần thao tác nếu có trong mục AC.
- **Backend:** Điều phối yêu cầu và truyền currency/group theo AC.
- **Internal Service:** Ứng viên: dịch vụ trading/tạo tài khoản; chưa có code chứng minh ownership.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 43 ---
• Request a move to the funded account round: refer to US Request a move to the funded
account round FRD_FO_One-Phase Package.docx
◦ The upgrade request created in BO keeps the currency of the trading account of phase 1.
~~~

<a id="ac-12-02"></a>

#### **AC-12-02 — Tạo tài khoản giai đoạn tiếp theo**

**Nguồn:** mục FRD 7.12.4; [trang 43](../../FRD_Package%20with%20multi%20currency.pdf#page=43).
**Diễn giải:** Tạo tài khoản theo giai đoạn và giữ currency/group được chỉ ra trong AC; không suy ra kết quả runtime.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Chỉ phần thao tác nếu có trong mục AC.
- **Backend:** Điều phối yêu cầu và truyền currency/group theo AC.
- **Internal Service:** Ứng viên: dịch vụ trading/tạo tài khoản; chưa có code chứng minh ownership.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-10](#q-10) — **Chờ trả lời:** Khi currency đã bị xóa khỏi cấu hình, group nào phải được lưu và dùng lại cho phase tiếp theo: group tại thời điểm mua, tại phase trước, hay group khác?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 43 ---
• Create trading account:
◦ Funded Account: refer to Confirm the terms and conditions to Upgrading from
Phases 1 to Funded Account FRD_FO_One-Phase Package.docx
▪ The currency of a funded account is the same as in phase 1.
▪ In case that currency is deleted for this balance, stored and use this group for
funded phase.
~~~

<a id="ac-12-03"></a>

#### **AC-12-03 — Chứng chỉ**

**Nguồn:** mục FRD 7.12.4; [trang 43](../../FRD_Package%20with%20multi%20currency.pdf#page=43), [trang 44](../../FRD_Package%20with%20multi%20currency.pdf#page=44).
**Diễn giải:** Điều chỉnh dữ liệu tiền/currency trên certificate theo từng giai đoạn.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 43 ---
• Certificate:
◦ Phase 1: Format of initial balance: [Initial balance] [Currency]
▪ Refer to US: Automatically generate a certificate of challenge when passing phase
1 FRD_WMT_Certificates_1.0.docx
◦ Funded account: Format of initial balance: [Initial balance] [Currency]
--- Trang 44 ---
▪ Refer to US: Automatically generate a certificate when user created funded account
successfully FRD_WMT_Certificates_1.0.docx
~~~

<a id="ac-12-04"></a>

#### **AC-12-04 — E-contract DocuSeal**

**Nguồn:** mục FRD 7.12.4; [trang 44](../../FRD_Package%20with%20multi%20currency.pdf#page=44).
**Diễn giải:** Truyền hoặc hiển thị one-time fee và initial balance cùng currency trên e-contract.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 44 ---
• E-contract (Docuseal): Create an e-contract – Funded (One-phase Challenge)
FRD_DocuSeal-1.0.
◦ One time Fee: [Checkout amount] [Currency]
◦ Initial balance: [Initial balance] [Currency]
~~~

<a id="ac-12-05"></a>

#### **AC-12-05 — Email**

**Nguồn:** mục FRD 7.12.4; [trang 44](../../FRD_Package%20with%20multi%20currency.pdf#page=44).
**Diễn giải:** Cập nhật nội dung hoặc định dạng tiền trong các email được FRD liệt kê.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 44 ---
• Update Email:
◦ Require:
▪ Change unit of Initial balance to the selected currency: Format: [Initial balance]
[Currency].
• Example: 10,000 EUR
◦ Apply for these emails:
▪ Scope for MT5
• TSE0000030 Create trading account for Funded Account (One Phase)
WCT_Email, notification, tooltips template.xlsx
• The emails of the MT5 scope in [2-Phase Challenge] Upgrade to phase in 2-
Phase Challenge package that are sent for the 1-Phase Challenge trading
accounts (TSE000005 – TSE0000015, TSE0000019, TSE0000021)
~~~

### 13. [2-Phase Challenge] Request a Refund

Refund 2-Phase quy đổi challenge fee và profit share sang USD; công thức funded kết hợp lợi nhuận của phase 1 và phase 2.

<a id="ac-13-01"></a>

#### **AC-13-01 — Request a refund for phase 2**

**Nguồn:** mục FRD 7.13.4.1; [trang 45](../../FRD_Package%20with%20multi%20currency.pdf#page=45).
**Diễn giải:** Refund 2-Phase quy đổi challenge fee và profit share sang USD; công thức funded kết hợp lợi nhuận của phase 1 và phase 2. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 45 ---
7.13.4.1. Request a refund for phase 2
https://www.figma.com/design/UiqMA8LpajKAj7jAsDknjf/-FO--WEMASTERTRADE--
2024-?node-id=11829-313255&t=xXvrjCBTL3FMnkcP-4
Refer to US Request a Refund for phase 2  FRD_WMT_Challenge_FE-1.0.docx
− Challenge Fee (Label): Display challenge fee of this account
o Formula: Challenge Fee = Checkout amount USD of this challenge * Refund ratio
of this trading account
o Checkout amount USD of this challenge – refer to field Convert checkout amount
to USD in User story [Challenge] Checkout with multicurrency package
o Unit: USD
~~~

<a id="ac-13-02"></a>

#### **AC-13-02 — Request a refund for funded account**

**Nguồn:** mục FRD 7.13.4.2; [trang 45](../../FRD_Package%20with%20multi%20currency.pdf#page=45), [trang 46](../../FRD_Package%20with%20multi%20currency.pdf#page=46), [trang 47](../../FRD_Package%20with%20multi%20currency.pdf#page=47).
**Diễn giải:** Refund 2-Phase quy đổi challenge fee và profit share sang USD; công thức funded kết hợp lợi nhuận của phase 1 và phase 2. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

> **Sơ đồ nguồn:** Chuyển tả từ sơ đồ trang 47: Profit Share (USD) = (Rate₁ × Profit₁ + Rate₂ × Profit₂) ÷ Currency Rate. Ví dụ trong hình: 80% × 1.000 EUR + 90% × 500 EUR = 1.250 EUR; tỷ giá 0,92; 1.250 ÷ 0,92 = 1.358,70 USD. Hình chỉ mô tả phần Profit Share, không phải toàn bộ Refund Amount.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 45 ---
7.13.4.2. Request a refund for funded account
https://www.figma.com/design/UiqMA8LpajKAj7jAsDknjf/-FO--WEMASTERTRADE--
2024-?node-id=11829-313255&t=xXvrjCBTL3FMnkcP-4
Refer to US View Challenge Refund Information and Request A Refund for funded account
stage
--- Trang 46 ---
• Refund Amount: Formula: Refund amount = Check amount USD of this challenge
package * Refund ratio% + Profit Share
o Profit Share = (Profit Share - Phase 1 of this trading account * Closed Net Profit
of trading account for phase 1 + Profit Share - Phase 2 of this trading account *
Closed Net Profit of trading account for phase 2) / Currency Rate (Currency Rate
from BO → Package → Multi-Currency → Currency Rate)
o If currency of trading account is USD, Currency rate = 1
o Unit: USD
• Profit Share (Label): Display Profit Share of this account
o Formula: Profit Share = (Profit Share - Phase 1 of this trading account * Closed
Net Profit of trading account for phase 1 + Profit Share - Phase 2 of this trading
account * Closed Net Profit of trading account for phase 2) / Currency Rate
o If currency of trading account is USD, Currency rate = 1
o Unit: USD
~~~

### 14. [1-Phase Challenge] Request a Refund

Refund 1-Phase tính challenge fee và profit share theo USD; điều kiện mục tiêu vẫn theo currency tài khoản.

<a id="ac-14-01"></a>

#### **AC-14-01 — Request a refund for phase 1**

**Nguồn:** mục FRD 7.14.5; [trang 48](../../FRD_Package%20with%20multi%20currency.pdf#page=48).
**Diễn giải:** Refund 1-Phase tính challenge fee và profit share theo USD; điều kiện mục tiêu vẫn theo currency tài khoản. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 48 ---
7.14.5. Request a refund for phase 1
https://www.figma.com/design/UiqMA8LpajKAj7jAsDknjf/-FO--WEMASTERTRADE--
2024-?node-id=11829-313255&t=xXvrjCBTL3FMnkcP-4
Refer to US Request A Refund for phase 1 FRD_FO_One-Phase Package.docx
• Challenge Fee (Label): Display challenge fee of this account
◦ Formula: Challenge Fee = Checkout amount USD of this challenge * Refund ratio of
this trading account
◦ Checkout amount USD of this challenge – refer to field Convert checkout amount to
USD in User story [1-Phase Challenge] Checkout with multicurrency package
◦ Unit: USD
• Total Refund Amount (Label): Formula: Total Refund Amount = Challenge Fee
◦ Unit: USD
~~~

<a id="ac-14-02"></a>

#### **AC-14-02 — View Challenge Refund Information**

**Nguồn:** mục FRD 7.14.6; [trang 48](../../FRD_Package%20with%20multi%20currency.pdf#page=48), [trang 49](../../FRD_Package%20with%20multi%20currency.pdf#page=49).
**Diễn giải:** Refund 1-Phase tính challenge fee và profit share theo USD; điều kiện mục tiêu vẫn theo currency tài khoản. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 48 ---
7.14.6. View Challenge Refund Information
https://www.figma.com/design/UiqMA8LpajKAj7jAsDknjf/-FO--WEMASTERTRADE--
2024-?node-id=11829-313255&t=xXvrjCBTL3FMnkcP-4
--- Trang 49 ---
Refer to US View Challenge Refund Information FRD_FO_One-Phase Package.docx
• Refund Amount: Formula: Refund amount = Check amount USD of this challenge package
* Refund ratio% + Profit Share
◦ Profit Share = (Profit Share - Phase 1 of this trading account * Closed Net Profit of
trading account for phase 1) / Currency Rate (Currency Rate from BO → Package →
Multi-Currency → Currency Rate)
◦ If currency of trading account is USD, Currency rate = 1
◦ Unit: USD
• Refund objectives:
◦ Total payout amount >= [Initial Balance of this trading account * Minimum Profit to
Withdraw Refund %] [Currency]
◦ Current Result – Total payout amount: [Total payout amount] [Currency]. Total payout
amount is calculated in the currency of the trading account.
~~~

<a id="ac-14-03"></a>

#### **AC-14-03 — Request a refund for funded account**

**Nguồn:** mục FRD 7.14.7; [trang 49](../../FRD_Package%20with%20multi%20currency.pdf#page=49).
**Diễn giải:** Refund 1-Phase tính challenge fee và profit share theo USD; điều kiện mục tiêu vẫn theo currency tài khoản. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 49 ---
7.14.7. Request a refund for funded account
Refer to US Request A Refund for funded account stage FRD_FO_One-Phase Package.docx
• Challenge Fee (Label): Display challenge fee of this account
◦ Formula: Challenge Fee = Checkout amount USD of this challenge * Refund ratio of
this trading account
◦ Unit: USD
• Profit Share (Label): Display Profit Share of this account
◦ Formula: Profit Share = (Profit Share - Phase 1 of this trading account * Closed Net
Profit of trading account for phase 1) / Currency Rate
◦ If currency of trading account is USD, Currency rate = 1
◦ Unit: USD
• Total Refund Amount (Label): Formula: Total Refund Amount = Challenge Fee + Profit
Share
◦ Unit: USD
~~~

### 15. WeTrader – Account detail for multi-currency

WeTrader list và account detail thể hiện currency của tài khoản trong balance, chart, objective, trading history và statistics.

<a id="ac-15-01"></a>

#### **AC-15-01 — AC chung**

**Nguồn:** mục FRD 7.15.4; [trang 50](../../FRD_Package%20with%20multi%20currency.pdf#page=50), [trang 51](../../FRD_Package%20with%20multi%20currency.pdf#page=51).
**Diễn giải:** WeTrader list và account detail thể hiện currency của tài khoản trong balance, chart, objective, trading history và statistics.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 50 ---
• In We Traders List > Instant screen: At Initial Balance field of the trading information:
◦ Format: [Initial Balance] [Currency]. Example: 10,000 USD
• In We Traders List > 2-Phase Challenge screen: At Initial Balance field of the trading
information:
◦ Format: [Initial Balance] [Currency]. Example: 10,000 USD
• In We Traders List > 1-Phase screen: At Initial Balance field of the trading information:
◦ Format: [Initial Balance] [Currency]. Example: 10,000 USD
--- Trang 51 ---
• In Account Details - We Traders screen:
https://www.figma.com/design/UiqMA8LpajKAj7jAsDknjf/-FO--WEMASTERTRADE--
2024-?node-id=46056-286834&t=xXvrjCBTL3FMnkcP-4
◦ Balance Chart:
▪ In title: Balance (Currency)
▪ Vertical axis: Remove USD, display 0
▪ Point hover content: Balance: [Balance] [Currency]
◦ Initial Balance section: Format: [Initial Balance] [Currency]. Example: 10,000 USD
◦ Trading Objectives:
▪ Update currency based on the initial balance unit in these field:
• Daily Loss
• Total Loss
◦ In trading history tab:
▪ Remove USD in table and trading history details, replace the selected
currency of this trading account.
◦ Statistics tab:
▪ Remove USD, replace the selected currency of this trading account.
◦ Apply the Account Details changes above for the trading accounts of 1-Phase Challenge
(Phase 1 and Funded Account).
~~~

### 16. Profit Request with multi-currency

Profit request hiển thị số tiền theo currency tài khoản, tính quy đổi USD và giải thích rằng tiền vào ví được thanh toán bằng USD.

<a id="ac-16-01"></a>

#### **AC-16-01 — AC chung**

**Nguồn:** mục FRD 7.16.4; [trang 52](../../FRD_Package%20with%20multi%20currency.pdf#page=52).
**Diễn giải:** Đây là phạm vi áp dụng cho các AC cùng chủ đề, không phải một tiêu chí độc lập: Apply for the trading accounts of 1-Phase Challenge the same as 2-Phase Challenge.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 52 ---
Apply for the trading accounts of 1-Phase Challenge the same as 2-Phase Challenge.
~~~

<a id="ac-16-02"></a>

#### **AC-16-02 — Profit request > Profit Request list**

**Nguồn:** mục FRD 7.16.4.1; [trang 53](../../FRD_Package%20with%20multi%20currency.pdf#page=53).
**Diễn giải:** Profit request hiển thị số tiền theo currency tài khoản, tính quy đổi USD và giải thích rằng tiền vào ví được thanh toán bằng USD. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 53 ---
7.16.4.1. Profit request > Profit Request list
https://www.figma.com/design/UiqMA8LpajKAj7jAsDknjf/-FO--WEMASTERTRADE--
2024-?node-id=27553-140488&t=xXvrjCBTL3FMnkcP-4
− Header title row of profit request list:
− Amount (USD) ==> Amount
o Data change from [Amount] to [Amount] [Currency]
− Net Profit to Receive (USD) ==> Net Profit to Receive
o Data change from [Net Profit to Receive] to [Net Profit to Receive]
[Currency]
~~~

<a id="ac-16-03"></a>

#### **AC-16-03 — Profit request > Quest**

**Nguồn:** mục FRD 7.16.4.2; [trang 53](../../FRD_Package%20with%20multi%20currency.pdf#page=53).
**Diễn giải:** Profit request hiển thị số tiền theo currency tài khoản, tính quy đổi USD và giải thích rằng tiền vào ví được thanh toán bằng USD. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 53 ---
7.16.4.2. Profit request > Quest
https://www.figma.com/design/UiqMA8LpajKAj7jAsDknjf/-FO--WEMASTERTRADE--
2024-?node-id=35890-174827&t=xXvrjCBTL3FMnkcP-4
− Header title row of quest list: Net Profit to Receive (USD) ==> Net Profit to Receive
o Data change from [Net Profit to Receive] to [Net Profit to Receive]
[Currency]
~~~

<a id="ac-16-04"></a>

#### **AC-16-04 — Submit profit request**

**Nguồn:** mục FRD 7.16.4.3; [trang 53](../../FRD_Package%20with%20multi%20currency.pdf#page=53), [trang 54](../../FRD_Package%20with%20multi%20currency.pdf#page=54).
**Diễn giải:** Profit request hiển thị số tiền theo currency tài khoản, tính quy đổi USD và giải thích rằng tiền vào ví được thanh toán bằng USD. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 53 ---
7.16.4.3. Submit profit request
https://www.figma.com/design/UiqMA8LpajKAj7jAsDknjf/-FO--WEMASTERTRADE--
2024-?node-id=27553-175155&t=xXvrjCBTL3FMnkcP-4
When user submits a profit request, in the profit request details:
• Available Profit to Request: Read only field.
o If Account Profit Ratio < [minimum of profit ratio]: Display “-”
o If Account Profit Ratio >= [minimum of profit ratio]: Available Profit to Request
= Closed Net to Profit. Format: [Closed Net to Profit] [Currency]
• Convert to USD: Read only field
o Formula: Convert to USD = Available Profit to Request / Currency rate
corresponding to the currency of the trading account (Refer to Config Currency
Rate)
o Unit: USD
o Around 2 decimals
--- Trang 54 ---
o Display tooltip: Currently, the system uses USD as the standard payout currency
to ensure consistency and better fund management. Your profit will be converted
to USD before being deposited into the wallet
• Update email submit profit request:
o Email E000006 Submit Profit request WMT_Email & Notification.xlsx
▪ Update format Available Profit to Request: [Available Profit to Withdraw]
[Currency]
▪ Add new field: Convert to USD: [Convert to USD amount] USD (only
display this field when currency of trading account # USD)
~~~

<a id="ac-16-05"></a>

#### **AC-16-05 — Confirm the Net Profit receive**

**Nguồn:** mục FRD 7.16.4.4; [trang 54](../../FRD_Package%20with%20multi%20currency.pdf#page=54).
**Diễn giải:** Popup xác nhận hiển thị net profit; nếu tài khoản không phải USD, hiển thị thêm số quy đổi USD.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 54 ---
7.16.4.4. Confirm the Net Profit receive
Refer to US Confirm the Net Profit received FRD_PROFIT REQUEST.docx
https://www.figma.com/design/UiqMA8LpajKAj7jAsDknjf/-FO--WEMASTERTRADE--
2024-?node-id=27553-175076&t=xXvrjCBTL3FMnkcP-4
- Change the content of popup confirm:
• New Content for Multicurrency:
▪ If the currency of account # USD: “The profit you can request is [Net
Profit to Receive] [Currency], equivalent to [Convert to USD for Net
Profit to Receive] USD. Do you agree with this Net profit?”
▪ If the currency of account = USD: “The profit you can request is [Net
Profit to Receive] USD. Do you agree with this Net profit?”
~~~

### 17. Currency List

Back Office quản lý currency, thứ tự, trạng thái, phạm vi hiển thị, điều kiện thêm/xóa và xử lý currency đang được sử dụng.

<a id="ac-17-01"></a>

#### **AC-17-01 — Display Currency List**

**Nguồn:** mục FRD 7.17.5.1; [trang 55](../../FRD_Package%20with%20multi%20currency.pdf#page=55).
**Diễn giải:** Admin xem currency, trạng thái, các toggle hiển thị và thay đổi thứ tự; thứ tự cần được lưu.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 55 ---
7.17.5.1. Display Currency List
- When Admin accesses Multi-Currency > Currency List, the system displays the list of
configured currencies.
- This functionality applies to both MT5 and cTrader tabs.
- The currency list contains the following columns:
o No.
o Currency: Displays the currency code (e.g., USD, EUR, GBP).
o Name: Displays the full name of the currency (e.g., US Dollar, Euro, British
Pound).
o Status: Displays a toggle to enable or disable the currency.
o Display on Trading capital?: Display Yes/No option toggle
o Display on Customized package?: Display Yes/No option toggle
o Delete: hide in USD currency. Refer to AC Delete currency
- Reorder:
o Admin can reorder currencies using the drag-and-drop scroll.
o The No. is automatically updated based on the new order after reordering.
o The currency order is saved and displayed consistently according to the updated
No. Order.
~~~

<a id="ac-17-02"></a>

#### **AC-17-02 — Add new currency**

**Nguồn:** mục FRD 7.17.5.2; [trang 55](../../FRD_Package%20with%20multi%20currency.pdf#page=55), [trang 56](../../FRD_Package%20with%20multi%20currency.pdf#page=56).
**Diễn giải:** Back Office quản lý currency, thứ tự, trạng thái, phạm vi hiển thị, điều kiện thêm/xóa và xử lý currency đang được sử dụng. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 55 ---
7.17.5.2. Add new currency
UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---BO---
New?node-id=26279-61278&t=q33ezT5o3zSk35oo-4
• Admin can click Add new to add a new currency. The popup displays:
o Active check box: Default Check
--- Trang 56 ---
▪ If the currency is active status, it will be displayed in the currency list of
the customized package on the client page
o Display on Trading capital?: Toggle – default ON
▪ Meaning:
• ON: Display this currency on field Currency so that user select.
• OFF: Hide this currency on field Currency.
o Display on Customized package?: Toggle – default ON
▪ Meaning:
• ON: Display this currency on field Currency so that user select.
• OFF: Hide this currency on field Currency.
o Currency: Dropdown list – Required field - Support search for dropdown
▪ Call API to get the currency list. Format: [Currency]. Ex:  USD
▪ List Currency here
https://docs.google.com/spreadsheets/d/1q22sy77Cw3HWSom8AnjmjSeq3
uYcWrhS/edit?usp=sharing&ouid=105428219028242803744&rtpof=true
&sd=true
▪ Placeholder: Select currency
o Name: read-only, auto filled based on the selected currency.
o Text note: “When a new currency is added, Admin can access the Customized
Package configuration to set up the conditions for that currency by selecting the
currency and adjusting the corresponding configuration.”
o For required fields, If the value is null, display an error message: “Please fill out
this field”
o Add button: Click on this button, the system executes:
▪ If user adds a currency that already exists in the list, display an error:
[Currency] has been already added
▪ If the user adds a currency (Excluding USD) without a configured
currency rate, display the error message: “Please add the currency rate
first.”
▪ If there are no error: Create a record in the currency list
o Cancel button: Click on this button to cancel the addition
~~~

<a id="ac-17-03"></a>

#### **AC-17-03 — Enable/Disable Currency**

**Nguồn:** mục FRD 7.17.5.3; [trang 57](../../FRD_Package%20with%20multi%20currency.pdf#page=57).
**Diễn giải:** Back Office quản lý currency, thứ tự, trạng thái, phạm vi hiển thị, điều kiện thêm/xóa và xử lý currency đang được sử dụng. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-08](#q-08) — **Chờ trả lời:** USD có phải luôn bật cả hai toggle hiển thị không? Giao dịch được xem là pending từ thời điểm nào để vẫn xử lý khi currency bị disable hoặc xóa?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 57 ---
7.17.5.3. Enable/Disable Currency
Apply this change for 2 new fields: Toggle Display on Trading capital and Display on
Customized package.
New update:
- Admin can enable or disable a currency using the toggle.
- The popup displays:
o Title: Change Currency Status?
o Message: Are you sure you want to enable/disable [Currency] for Trading
capital/Customized package?
▪ Enable or disable depend on the status of currency.
o If Admin clicks Confirm:
▪ The system updates the currency status.
▪ The toggle changes to the new status.
o If Admin clicks Cancel:
▪ The currency status remains unchanged.
The toggle returns/remains at its previous status.
Old content:
- Admin can enable or disable a currency using the Status toggle.
- The popup displays:
o Title: Change Currency Status?
o Message: Are you sure you want to enable/disable [Currency]?
▪ Enable or disable depend on the status of currency.
o If Admin clicks Confirm:
▪ The system updates the currency status.
▪ The toggle changes to the new status.
o If Admin clicks Cancel:
▪ The currency status remains unchanged.
▪ The toggle returns/remains at its previous status.
~~~

<a id="ac-17-04"></a>

#### **AC-17-04 — Currency in Use**

**Nguồn:** mục FRD 7.17.5.4; [trang 57](../../FRD_Package%20with%20multi%20currency.pdf#page=57), [trang 58](../../FRD_Package%20with%20multi%20currency.pdf#page=58).
**Diễn giải:** Phân biệt giao dịch đang pending với người dùng chưa checkout khi currency bị disable hoặc xóa.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-08](#q-08) — **Chờ trả lời:** USD có phải luôn bật cả hai toggle hiển thị không? Giao dịch được xem là pending từ thời điểm nào để vẫn xử lý khi currency bị disable hoặc xóa?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 57 ---
7.17.5.4. Currency in Use
- In case pending transaction using currency, it still applies for that currency.
--- Trang 58 ---
- In case user before checkout step and select currency done, that currency is disable and
delete, display error message when checkout: “The selected currency for this package is
currently unavailable, please reload page to update your selection”
~~~

<a id="ac-17-05"></a>

#### **AC-17-05 — Default / Required Currency**

**Nguồn:** mục FRD 7.17.5.4.1; [trang 59](../../FRD_Package%20with%20multi%20currency.pdf#page=59).
**Diễn giải:** Bảo vệ currency mặc định/bắt buộc và xử lý đặc biệt với USD; ý nghĩa các toggle cần xác nhận.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-08](#q-08) — **Chờ trả lời:** USD có phải luôn bật cả hai toggle hiển thị không? Giao dịch được xem là pending từ thời điểm nào để vẫn xử lý khi currency bị disable hoặc xóa?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 59 ---
7.17.5.4.1. Default / Required Currency
- The system must prevent Admin from disabling or deleting a currency if it is configured
as a required/default currency (by Delete AC below)
- USD cannot be deleted and Inactive 2 toggle Display on Trading capital and Display on
Customized package.
~~~

<a id="ac-17-06"></a>

#### **AC-17-06 — Delete currency**

**Nguồn:** mục FRD 7.17.5.5; [trang 59](../../FRD_Package%20with%20multi%20currency.pdf#page=59).
**Diễn giải:** Hỏi xác nhận xóa và chặn nếu currency đang nằm trong Supported Currency của package.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-08](#q-08) — **Chờ trả lời:** USD có phải luôn bật cả hai toggle hiển thị không? Giao dịch được xem là pending từ thời điểm nào để vẫn xử lý khi currency bị disable hoặc xóa?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 59 ---
7.17.5.5. Delete currency
UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---BO---
New?node-id=26357-88281&t=q33ezT5o3zSk35oo-4
- Delete: button, when user clicks on the button, the confirmation popup will be displayed
as above:
o Title: Delete Currency
o Content:
▪ “Are you sure you want to delete this currency?
All configurations associated with this currency in customized packages
will be permanently deleted. We recommend deactivating the currency
instead of deleting it.”
o Cancel: Button, on click, discard delete currency action and close popup
o Confirm: Button, on click the system will execute:
▪ Check: If at least 1 package has this currency (any status), show error
message: “Cannot delete [EUR]. This currency is currently used in
Supported Currency of: [Package ID A], [Package ID B]. We recommend
deactivating the currency instead of deleting it.”
▪ If pass:
• Delete the country from the configured currency list
▪ Display the toast message: "The currency has been deleted successfully”
~~~

### 18. Currency Rate list

Back Office quản lý tỷ giá thủ công: USD sang currency bằng phép nhân, tỷ giá hợp lệ lớn hơn 0 đến 100.000, tối đa 4 chữ số thập phân; USD có tỷ giá cố định 1.

<a id="ac-18-01"></a>

#### **AC-18-01 — Display Currency Rate list**

**Nguồn:** mục FRD 7.18.4.1; [trang 60](../../FRD_Package%20with%20multi%20currency.pdf#page=60).
**Diễn giải:** Back Office quản lý tỷ giá thủ công: USD sang currency bằng phép nhân, tỷ giá hợp lệ lớn hơn 0 đến 100.000, tối đa 4 chữ số thập phân; USD có tỷ giá cố định 1. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 60 ---
7.18.4.1. Display Currency Rate list
− System displays the Currency Rate page under Multi-Currency > Currency Rate.
− Display the following columns:
o Currency
o Currency Name
o Currency Rate
o Updated Date
o Updated By
o Detail: Each record has a Detail button. Click button to navigate to detail popup –
edit view.
− Sort by Updated date – newest to oldest
− Display 20 items per page
− Currency Rate is used to convert an amount from USD to the selected currency.
o Conversion formula:
▪ Converted Amount = Currency Rate × Amount in USD
~~~

<a id="ac-18-02"></a>

#### **AC-18-02 — Search and filter**

**Nguồn:** mục FRD 7.18.4.2; [trang 60](../../FRD_Package%20with%20multi%20currency.pdf#page=60), [trang 61](../../FRD_Package%20with%20multi%20currency.pdf#page=61).
**Diễn giải:** Áp dụng các cột tìm kiếm/bộ lọc được nêu; quy tắc chung được tham chiếu trong nguồn.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 60 ---
7.18.4.2.  Search and filter
- Search field:
o Currency
o Currency Name
o Currency Rate
--- Trang 61 ---
- Filter by date:
o Updated Date
Apply the standard Search & Filter rules as defined here: Search & Filter
~~~

<a id="ac-18-03"></a>

#### **AC-18-03 — Add New Currency Rate**

**Nguồn:** mục FRD 7.18.4.3; [trang 61](../../FRD_Package%20with%20multi%20currency.pdf#page=61), [trang 62](../../FRD_Package%20with%20multi%20currency.pdf#page=62).
**Diễn giải:** Admin nhập currency/rate và cờ SVG; áp dụng required, giới hạn kích thước, chữ số thập phân và khoảng giá trị theo FRD.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 61 ---
7.18.4.3. Add New Currency Rate
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---BO---New?node-
id=26270-58613&t=q33ezT5o3zSk35oo-4
- When user clicks Add new, system navigates to the Add Currency Rate popup.
- The add new popup displays:
o Currency:
▪ Dropdown list – Required field - Support search for dropdown
▪ Call API to get the currency list. Format: [Currency]. Ex:  USD
• List Currency here
https://docs.google.com/spreadsheets/d/1q22sy77Cw3HWSom8Anj
mjSeq3uYcWrhS/edit?usp=sharing&ouid=1054282190282428037
44&rtpof=true&sd=true
• Hide USD in the selection list.
▪ Placeholder: Select currency
o Name: read-only, auto filled based on the selected currency.
o Flag: Upload file field.
▪ Required field
▪ Size file accepted: svg
▪ User can upload one flag image for the currency.
▪ Maximum file size: 5 MB.
• The system must validate the uploaded file size.
• If the uploaded file exceeds 5 MB, the system must prevent the
upload and display an appropriate error message “File size cannot
exceed 5 MB.”
• File name: Logo_[Currency]_Timestamp
▪ After uploading successfully, the uploaded flag is displayed in the Flag
field.
--- Trang 62 ---
▪ The uploaded flag is saved and associated with the corresponding
currency.
▪ Tooltip: The selected flag will be displayed as the currency logo on the
Client site for both Customized Package and Trading Capital.
▪ Textnote: “Image dimensions: 18 × 18 px.”
o Currency Rate:
▪ Required field, textbox
▪ Placeholder: Enter currency rate
▪ Accept numeric values only.
▪ Allow up to 4 decimal places.
▪ Accepted range: (0, 100,000].
▪ Text note: “Formula: Converted Amount = Currency Rate × Amount in
USD”
o For required fields, If the value is null, display an error message: “Please fill out
this field”
o Add button: Click on this button, the system executes:
▪ If user adds a currency that already exists in the list, display an error:
[Currency] has been already added
▪ If there are no error: Create a record in the currency list
o Cancel button: Click on this button to cancel the addition
~~~

<a id="ac-18-04"></a>

#### **AC-18-04 — View/Edit Currency Rate Detail**

**Nguồn:** mục FRD 7.18.4.4; [trang 62](../../FRD_Package%20with%20multi%20currency.pdf#page=62), [trang 63](../../FRD_Package%20with%20multi%20currency.pdf#page=63).
**Diễn giải:** Back Office quản lý tỷ giá thủ công: USD sang currency bằng phép nhân, tỷ giá hợp lệ lớn hơn 0 đến 100.000, tối đa 4 chữ số thập phân; USD có tỷ giá cố định 1. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 62 ---
7.18.4.4. View/Edit Currency Rate Detail
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---BO---New?node-
id=26270-58792&t=q33ezT5o3zSk35oo-4
− When user clicks Detail, system opens the detail page of the selected currency.
− The detail page displays the configured:
o Currency
o Name
o Flag
o Currency Rate
− User can update the Currency Rate/Flag
--- Trang 63 ---
− When the rate is updated successfully:
o System saves the new rate.
o Updated Date is updated to the current date/time.
o Updated By is updated to the account that performed the update.
− For record of currency USD, only edit field Flag, hard code Currency Rate = 1
~~~

### 19. [Instant_Package] List currency for instant package

Admin cấu hình Supported Currency và group cho package Instant, lưu cùng package; package cũ được gán USD và group hiện hữu.

<a id="ac-19-01"></a>

#### **AC-19-01 — View supported currency**

**Nguồn:** mục FRD 7.19.4.1; [trang 63](../../FRD_Package%20with%20multi%20currency.pdf#page=63), [trang 64](../../FRD_Package%20with%20multi%20currency.pdf#page=64).
**Diễn giải:** Hiển thị danh sách currency, group, status và thao tác detail của package.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 63 ---
7.19.4.1.   View supported currency
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=8075-246859&t=mmakhlW40VDrpi8x-4
− In Package Detail (both Add Package and Edit Package views), display the Supported
Currency section with the following information:
• No. : from 1 to N
• Currency
• Currency Name
• Group Name
• Status
• Detail: click to open popup Detail – Edit view
− Display 10 items per page
--- Trang 64 ---
− Sort by added date – Newest to oldest
~~~

<a id="ac-19-02"></a>

#### **AC-19-02 — Add new currency for package**

**Nguồn:** mục FRD 7.19.4.2; [trang 64](../../FRD_Package%20with%20multi%20currency.pdf#page=64), [trang 65](../../FRD_Package%20with%20multi%20currency.pdf#page=65).
**Diễn giải:** Chọn currency và group phù hợp; kiểm tra required, trùng currency và thiếu tỷ giá trước khi thêm.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-09](#q-09) — **Chờ trả lời:** Khi Add Currency cho package, “create a record” là tạo bản nháp trong FE hay ghi DB ngay? Việc Edit FE-only chỉ được persist khi Save package đúng không?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 64 ---
7.19.4.2. Add new currency for package
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---BO---New?node-
id=26240-13165&t=q33ezT5o3zSk35oo-4
− Admin can click Add Currency to add a new currency to the package.
− Admin can click Add Currency to add a new currency. The popup displays:
o Active check box: Default Check
▪ If the currency is active status, it will be displayed in the currency list of
the package on the client page
o Currency: Dropdown list – Required field - Support search for dropdown
▪ Call API to get the currency list. Format: [Currency]. Ex:  USD
▪ Get List currency configured on list Currency List
▪ Placeholder: Select currency
o Name: read-only, auto filled based on the selected currency.
o Group:
▪ Dropdown field.
▪ Required field.
▪ Placeholder: Select Group.
▪ The dropdown displays the groups associated with the selected currency
(refer to US Group name configuration FRD_Package with multi
currency.
▪ If no currency is selected, the Group field remains empty, and no group
options are available.
--- Trang 65 ---
o For required fields, If the value is null, display an error message: “Please fill out
this field”
o Add button: Click on this button, the system executes:
▪ If user adds a currency that already exists in the list, display an error:
[Currency] has been already added
▪ If the user adds a currency (Excluding USD) without a configured
currency rate, display the error message: “Please add the currency rate
first.”
▪ If there are no error: Create a record in the currency list
o Cancel button: Click on this button to cancel the addition
~~~

<a id="ac-19-03"></a>

#### **AC-19-03 — Edit currency for package**

**Nguồn:** mục FRD 7.19.4.3; [trang 65](../../FRD_Package%20with%20multi%20currency.pdf#page=65).
**Diễn giải:** Cho sửa cấu hình currency của package; AC ghi trạng thái chỉnh trên FE trước khi lưu package.
**Lớp đề xuất:** FE — **Cần User xác nhận**.
- **FE:** Chỉnh dữ liệu bản nháp trên FE theo mô tả; xem Q-09 về thời điểm lưu.
- **Backend:** Không suy ra ghi DB ngay từ AC Edit FE-only.
- **Internal Service:** Chưa thấy yêu cầu trực tiếp.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-09](#q-09) — **Chờ trả lời:** Khi Add Currency cho package, “create a record” là tạo bản nháp trong FE hay ghi DB ngay? Việc Edit FE-only chỉ được persist khi Save package đúng không?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 65 ---
7.19.4.3. Edit currency for package
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---BO---New?node-
id=26357-99502&t=q33ezT5o3zSk35oo-4
o Admin can click Detail to view and edit the selected currency configuration.
o Admin can update the applicable currency information.
o All validation is the same as adding new.
o Save button: Click on this button, the system executes:
▪ If user adds a currency that already exists in the list, display an error:
[Currency] has been already added
▪ If the user adds a currency (Excluding USD) without a configured
currency rate, display the error message: “Please add the currency rate
first.”
▪ If no errors occur: The system saves the selected currency on the FE only.
It is not saved to the database.
o Cancel button: Click on this button to cancel the addition
~~~

<a id="ac-19-04"></a>

#### **AC-19-04 — Save the package**

**Nguồn:** mục FRD 7.19.4.4; [trang 65](../../FRD_Package%20with%20multi%20currency.pdf#page=65), [trang 66](../../FRD_Package%20with%20multi%20currency.pdf#page=66).
**Diễn giải:** Lưu package cùng Supported Currency khi có tối thiểu một currency ACTIVE; nếu không, hiển thị lỗi quy định.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-09](#q-09) — **Chờ trả lời:** Khi Add Currency cho package, “create a record” là tạo bản nháp trong FE hay ghi DB ngay? Việc Edit FE-only chỉ được persist khi Save package đúng không?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 65 ---
7.19.4.4. Save the package
− When Admin clicks Save, the system validates the Supported Currency configuration.
o If no currency ACTIVE is configured, the system displays the error message: “At
least 1 currency setup for a package”.
--- Trang 66 ---
o If the validation passes, the system saves the package together with its Supported
Currency configuration.
~~~

<a id="ac-19-05"></a>

#### **AC-19-05 — Default**

**Nguồn:** mục FRD 7.19.4.5; [trang 66](../../FRD_Package%20with%20multi%20currency.pdf#page=66).
**Diễn giải:** Package mới có danh sách trống; package cũ được gán USD, group hiện tại và trạng thái Active như FRD.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 66 ---
7.19.4.5. Default
− When Admin adds a new package, the Supported Currency list will be empty (keep
display header row of table).
− Existing packages (before release)
o Each existing package is automatically assigned 1 Supported Currency record:
Currency = USD, Group = the current Group Name of the package, Status =
Active.
o Initial Balance and One-time Fee of existing packages are kept as is and are
treated as USD values.
o Existing packages keep displaying on the Client site with USD, and Admin can
edit them without the "At least 1 currency setup for a package" error
~~~

<a id="ac-19-06"></a>

#### **AC-19-06 — Related impact**

**Nguồn:** mục FRD 7.19.5; [trang 67](../../FRD_Package%20with%20multi%20currency.pdf#page=67).
**Diễn giải:** Admin cấu hình Supported Currency và group cho package Instant, lưu cùng package; package cũ được gán USD và group hiện hữu. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE — **Cần User xác nhận**.
- **FE:** Ẩn hoặc đổi nhãn/đơn vị tại màn package như FRD mô tả.
- **Backend:** Nguồn dữ liệu và thay đổi API chưa được xác minh.
- **Internal Service:** Chưa thấy yêu cầu trực tiếp.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 67 ---
7.19.5. Related impact
- Hide field Group in Package detail (both Add Package and Edit Package views)
~~~

### 20. [2-Phase Challenge_Package] List currency for 2-Phase challenge package

Áp dụng cấu hình Supported Currency và xử lý package cũ tương tự cho 2-Phase Challenge.

<a id="ac-20-01"></a>

#### **AC-20-01 — View supported currency**

**Nguồn:** mục FRD 7.20.4.1; [trang 67](../../FRD_Package%20with%20multi%20currency.pdf#page=67).
**Diễn giải:** Hiển thị danh sách currency, group, status và thao tác detail của package.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 67 ---
7.20.4.1.  View supported currency
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=27333-37774&t=mmakhlW40VDrpi8x-4
− In Package Detail (both Add Package and Edit Package views), display the Supported
Currency section with the following information:
• No. : from 1 to N
• Currency
• Currency Name
• Group Name
• Status
• Detail: click to open popup Detail – Edit view
− Display 10 items per page
− Sort by added date – Newest to oldest
~~~

<a id="ac-20-02"></a>

#### **AC-20-02 — Add new currency for package**

**Nguồn:** mục FRD 7.20.4.2; [trang 68](../../FRD_Package%20with%20multi%20currency.pdf#page=68), [trang 69](../../FRD_Package%20with%20multi%20currency.pdf#page=69).
**Diễn giải:** Chọn currency và group phù hợp; kiểm tra required, trùng currency và thiếu tỷ giá trước khi thêm.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-09](#q-09) — **Chờ trả lời:** Khi Add Currency cho package, “create a record” là tạo bản nháp trong FE hay ghi DB ngay? Việc Edit FE-only chỉ được persist khi Save package đúng không?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 68 ---
7.20.4.2. Add new currency for package
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=27333-37997&t=mmakhlW40VDrpi8x-4
− Admin can click Add Currency to add a new currency to the package.
− Admin can click Add Currency to add a new currency. The popup displays:
o Active check box: Default Check
▪ If the currency is active status, it will be displayed in the currency list of
the package on the client page
o Currency: Dropdown list – Required field - Support search for dropdown
▪ Call API to get the currency list. Format: [Currency]. Ex:  USD
▪ Get List currency configured on list Currency List
▪ Placeholder: Select currency
o Name: read-only, auto filled based on the selected currency.
o Group:
▪ Dropdown field.
▪ Required field.
▪ Placeholder: Select Group.
▪ The dropdown displays the groups associated with the selected currency
(refer to US Group name configuration FRD_Package with multi
currency.
▪ If no currency is selected, the Group field remains empty, and no group
options are available.
--- Trang 69 ---
o For required fields, If the value is null, display an error message: “Please fill out
this field”
o Add button: Click on this button, the system executes:
▪ If user adds a currency that already exists in the list, display an error:
[Currency] has been already added
▪ If the user adds a currency (Excluding USD) without a configured
currency rate, display the error message: “Please add the currency rate
first.”
▪ If there are no error: Create a record in the currency list
o Cancel button: Click on this button to cancel the addition
~~~

<a id="ac-20-03"></a>

#### **AC-20-03 — Edit currency for package**

**Nguồn:** mục FRD 7.20.4.3; [trang 69](../../FRD_Package%20with%20multi%20currency.pdf#page=69).
**Diễn giải:** Cho sửa cấu hình currency của package; AC ghi trạng thái chỉnh trên FE trước khi lưu package.
**Lớp đề xuất:** FE — **Cần User xác nhận**.
- **FE:** Chỉnh dữ liệu bản nháp trên FE theo mô tả; xem Q-09 về thời điểm lưu.
- **Backend:** Không suy ra ghi DB ngay từ AC Edit FE-only.
- **Internal Service:** Chưa thấy yêu cầu trực tiếp.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-09](#q-09) — **Chờ trả lời:** Khi Add Currency cho package, “create a record” là tạo bản nháp trong FE hay ghi DB ngay? Việc Edit FE-only chỉ được persist khi Save package đúng không?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 69 ---
7.20.4.3. Edit currency for package
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=27333-38003&t=mmakhlW40VDrpi8x-4
o Admin can click Detail to view and edit the selected currency configuration.
o Admin can update the applicable currency information.
o All validation is the same as adding new.
o Save button: Click on this button, the system executes:
▪ If user adds a currency that already exists in the list, display an error:
[Currency] has been already added
▪ If no errors occur: The system saves the selected currency on the FE only.
It is not saved to the database.
o Cancel button: Click on this button to cancel the addition
~~~

<a id="ac-20-04"></a>

#### **AC-20-04 — Save the package**

**Nguồn:** mục FRD 7.20.4.4; [trang 69](../../FRD_Package%20with%20multi%20currency.pdf#page=69).
**Diễn giải:** Lưu package cùng Supported Currency khi có tối thiểu một currency ACTIVE; nếu không, hiển thị lỗi quy định.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-09](#q-09) — **Chờ trả lời:** Khi Add Currency cho package, “create a record” là tạo bản nháp trong FE hay ghi DB ngay? Việc Edit FE-only chỉ được persist khi Save package đúng không?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 69 ---
7.20.4.4. Save the package
− When Admin clicks Save, the system validates the Supported Currency configuration.
o If no currency ACTIVE is configured, the system displays the error message: “At
least 1 currency setup for a package”.
o If the validation passes, the system saves the package together with its Supported
Currency configuration.
~~~

<a id="ac-20-05"></a>

#### **AC-20-05 — Default**

**Nguồn:** mục FRD 7.20.4.5; [trang 70](../../FRD_Package%20with%20multi%20currency.pdf#page=70).
**Diễn giải:** Package mới có danh sách trống; package cũ được gán USD, group hiện tại và trạng thái Active như FRD.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 70 ---
7.20.4.5. Default
− When Admin adds a new package, the Supported Currency list will be empty (keep
display header row of table).
− Existing packages (before release)
o Each existing package is automatically assigned 1 Supported Currency
record: Currency = USD, Group = the current Group Name of the package,
Status = Active.
o Initial Balance and One-time Fee of existing packages are kept as is and are
treated as USD values.
o Existing packages keep displaying on the Client site with USD, and Admin
can edit them without the "At least 1 currency setup for a package" error
~~~

<a id="ac-20-06"></a>

#### **AC-20-06 — Related impact**

**Nguồn:** mục FRD 7.20.5; [trang 70](../../FRD_Package%20with%20multi%20currency.pdf#page=70).
**Diễn giải:** Áp dụng cấu hình Supported Currency và xử lý package cũ tương tự cho 2-Phase Challenge. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE — **Cần User xác nhận**.
- **FE:** Ẩn hoặc đổi nhãn/đơn vị tại màn package như FRD mô tả.
- **Backend:** Nguồn dữ liệu và thay đổi API chưa được xác minh.
- **Internal Service:** Chưa thấy yêu cầu trực tiếp.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 70 ---
7.20.5. Related impact
- Hide field Group in Package detail (both Add Package and Edit Package views)
~~~

### 21. [1-Phase Challenge_Package] List currency for 1-Phase Challenge package

Áp dụng Supported Currency và xử lý package cũ cho 1-Phase Challenge; FRD dùng nhầm các nhãn 7.22 ở các tiểu mục trang 71–73.

<a id="ac-21-01"></a>

#### **AC-21-01 — AC chung**

**Nguồn:** mục FRD 7.21.4; [trang 70](../../FRD_Package%20with%20multi%20currency.pdf#page=70).
**Diễn giải:** Đây là tham chiếu tới tài liệu bên ngoài chưa được kiểm tra; không tự bổ sung AC từ tài liệu đó.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 70 ---
Refer to US 1-Phase Challenge Package – Add new/Edit 1-Phase Challenge Package
FRD_BO_One-Phase Package.docx
~~~

<a id="ac-21-02"></a>

#### **AC-21-02 — View supported currency**

**Nguồn:** mục FRD 7.22.4.1; [trang 71](../../FRD_Package%20with%20multi%20currency.pdf#page=71).
**Diễn giải:** Hiển thị danh sách currency, group, status và thao tác detail của package.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 71 ---
7.22.4.1. View supported currency
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=4540-27489&t=mmakhlW40VDrpi8x-4
• In Package Detail (both Add Package and Edit Package views), display the Supported
Currency section with the following information:
• No. : from 1 to N
• Currency
• Currency Name
• Group Name
• Status
• Detail: click to open popup Detail – Edit view
• Display 10 items per page
• Sort by added date – Newest to oldest
~~~

<a id="ac-21-03"></a>

#### **AC-21-03 — Add new currency for package**

**Nguồn:** mục FRD 7.22.4.2; [trang 71](../../FRD_Package%20with%20multi%20currency.pdf#page=71), [trang 72](../../FRD_Package%20with%20multi%20currency.pdf#page=72).
**Diễn giải:** Chọn currency và group phù hợp; kiểm tra required, trùng currency và thiếu tỷ giá trước khi thêm.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-09](#q-09) — **Chờ trả lời:** Khi Add Currency cho package, “create a record” là tạo bản nháp trong FE hay ghi DB ngay? Việc Edit FE-only chỉ được persist khi Save package đúng không?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 71 ---
7.22.4.2. Add new currency for package
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=28213-130479&t=mmakhlW40VDrpi8x-4
• Admin can click Add Currency to add a new currency to the package.
• Admin can click Add new to add a new currency. The popup displays:
◦ Active check box: Default Check
▪ If the currency is active status, it will be displayed in the currency list of the
package on the client page
◦ Currency: Dropdown list – Required field - Support search for dropdown
▪ Call API to get the currency list. Format: [Currency]. Ex: USD
▪ Get List currency configured on list Currency List
▪ Placeholder: Select currency
◦ Name: read-only, auto filled based on the selected currency.
◦ Group:
▪ Dropdown field.
▪ Required field.
--- Trang 72 ---
▪ Placeholder: Select Group.
▪ The dropdown displays the groups associated with the selected currency (refer to
US Group name configuration FRD_Package with multi currency.
▪ If no currency is selected, the Group field remains empty, and no group options are
available.
◦ For required fields, If the value is null, display an error message: "Please fill out this
field"
◦ Add button: Click on this button, the system executes:
▪ If user adds a currency that already exists in the list, display an error: [Currency]
has been already added
▪ If the user adds a currency (Excluding USD) without a configured currency rate,
display the error message: "Please add the currency rate first."
▪ If there are no error: Create a record in the currency list
◦ Cancel button: Click on this button to cancel the addition
~~~

<a id="ac-21-04"></a>

#### **AC-21-04 — Edit currency for package**

**Nguồn:** mục FRD 7.22.4.3; [trang 72](../../FRD_Package%20with%20multi%20currency.pdf#page=72).
**Diễn giải:** Cho sửa cấu hình currency của package; AC ghi trạng thái chỉnh trên FE trước khi lưu package.
**Lớp đề xuất:** FE — **Cần User xác nhận**.
- **FE:** Chỉnh dữ liệu bản nháp trên FE theo mô tả; xem Q-09 về thời điểm lưu.
- **Backend:** Không suy ra ghi DB ngay từ AC Edit FE-only.
- **Internal Service:** Chưa thấy yêu cầu trực tiếp.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-09](#q-09) — **Chờ trả lời:** Khi Add Currency cho package, “create a record” là tạo bản nháp trong FE hay ghi DB ngay? Việc Edit FE-only chỉ được persist khi Save package đúng không?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 72 ---
7.22.4.3. Edit currency for package
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=28213-130485&t=mmakhlW40VDrpi8x-4
• Admin can click Detail to view and edit the selected currency configuration.
• Admin can update the applicable currency information.
• All validation is the same as adding new.
• Save button: Click on this button, the system executes:
◦ If user adds a currency that already exists in the list, display an error: [Currency] has
been already added
◦ If no errors occur: The system saves the selected currency on the FE only. It is not saved
to the database.
• Cancel button: Click on this button to cancel the addition
~~~

<a id="ac-21-05"></a>

#### **AC-21-05 — Save the package**

**Nguồn:** mục FRD 7.22.4.4; [trang 72](../../FRD_Package%20with%20multi%20currency.pdf#page=72), [trang 73](../../FRD_Package%20with%20multi%20currency.pdf#page=73).
**Diễn giải:** Lưu package cùng Supported Currency khi có tối thiểu một currency ACTIVE; nếu không, hiển thị lỗi quy định.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-09](#q-09) — **Chờ trả lời:** Khi Add Currency cho package, “create a record” là tạo bản nháp trong FE hay ghi DB ngay? Việc Edit FE-only chỉ được persist khi Save package đúng không?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 72 ---
7.22.4.4. Save the package
• When Admin clicks Add/Save, the system validates the Supported Currency configuration.
--- Trang 73 ---
◦ If no currency ACTIVE is configured, the system displays the error message: "At least
1 currency setup for a package".
◦ If the validation passes, the system saves the package together with its Supported
Currency configuration.
~~~

<a id="ac-21-06"></a>

#### **AC-21-06 — Default**

**Nguồn:** mục FRD 7.22.4.5; [trang 73](../../FRD_Package%20with%20multi%20currency.pdf#page=73).
**Diễn giải:** Package mới có danh sách trống; package cũ được gán USD, group hiện tại và trạng thái Active như FRD.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 73 ---
7.22.4.5. Default
• When Admin adds a new package, the Supported Currency list will be empty (keep
display header row of table).
• Existing packages (before release)
◦ Each existing package is automatically assigned 1 Supported Currency record:
Currency = USD, Group = the current Group Name of the package, Status = Active.
◦ Initial Balance and One-time Fee of existing packages are kept as is and are
treated as USD values.
◦ Existing packages keep displaying on the Client site with USD, and Admin can edit
them without the "At least 1 currency setup for a package" error
~~~

<a id="ac-21-07"></a>

#### **AC-21-07 — Related impact**

**Nguồn:** mục FRD 7.22.5; [trang 73](../../FRD_Package%20with%20multi%20currency.pdf#page=73).
**Diễn giải:** Áp dụng Supported Currency và xử lý package cũ cho 1-Phase Challenge; FRD dùng nhầm các nhãn 7.22 ở các tiểu mục trang 71–73. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE — **Cần User xác nhận**.
- **FE:** Ẩn hoặc đổi nhãn/đơn vị tại màn package như FRD mô tả.
- **Backend:** Nguồn dữ liệu và thay đổi API chưa được xác minh.
- **Internal Service:** Chưa thấy yêu cầu trực tiếp.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 73 ---
7.22.5. Related impact
• Hide field Group Name in Package detail (both Add Package and Edit Package views)
• Initial Balance, One-time Fee: remove "Unit: USD". The value is displayed on the Client
site with the currency selected by the user (refer to US [1-Phase Challenge_Trading capital]
View multi-currency package)
~~~

### 22. [Instant_Customized packages] Setup customized package for each currency

Cấu hình customize Instant theo từng currency; currency mới clone cấu hình USD và thay đổi chưa lưu cần popup xác nhận khi chuyển.

<a id="ac-22-01"></a>

#### **AC-22-01 — AC chung**

**Nguồn:** mục FRD 7.22.5; [trang 74](../../FRD_Package%20with%20multi%20currency.pdf#page=74), [trang 75](../../FRD_Package%20with%20multi%20currency.pdf#page=75).
**Diễn giải:** Cấu hình customize Instant theo từng currency; currency mới clone cấu hình USD và thay đổi chưa lưu cần popup xác nhận khi chuyển.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-12](#q-12) — **Chờ trả lời:** Khi clone cấu hình USD sang currency mới, giữ nguyên các giá trị số hay quy đổi các trường tiền theo tỷ giá; những trường nào cần admin kiểm tra lại?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 74 ---
- Display a Currency dropdown.
o Default value: USD.
o The dropdown list is populated based on the configured Currency List (BO >
Package management > Currency List – both Active and Inactive)
o When a new currency is added to the Currency List, the system automatically
adds that currency to the dropdown and clones the configuration data from USD
for the newly added currency.
- When a currency is deleted from the Currency List:
o The currency is removed from the dropdown.
o All configuration data associated with that currency are permanently deleted.
- When Admin selects a specific currency from the dropdown:
o The system displays the configuration data for the selected currency.
o Any changes made are applied only to the selected currency.
--- Trang 75 ---
o The Save Changes button saves the configuration for the currently selected
currency.
- When Admin makes any changes to the currency configuration, the system marks the
configuration as unsaved.
- When Admin attempts to switch to another currency while there are unsaved changes, the
system displays a confirmation popup:
o Title: “You have unsaved changes”
o Message: “Your changes have not been saved. Do you want to save them before
leaving?”
o Save Changes: Save the current currency configuration, then switch to the
selected currency.
o Discard Changes: Discard all unsaved changes, then switch to the selected
currency.
o Cancel: Close the popup and remain in the current currency without losing any
changes.
o If there are no unsaved changes, Admin can switch between currencies without
displaying the confirmation popup.
~~~

<a id="ac-22-02"></a>

#### **AC-22-02 — Tab 1 – Initial balance**

**Nguồn:** mục FRD 7.22.5.1; [trang 76](../../FRD_Package%20with%20multi%20currency.pdf#page=76).
**Diễn giải:** Cấu hình hoặc hiển thị initial balance theo currency đang chọn; các validation tham chiếu tài liệu hiện hành.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 76 ---
7.22.5.1. Tab 1 – Initial balance
- View UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--
WeMasterTrade--New-?node-id=26251-16360&t=mmakhlW40VDrpi8x-4
- Based on the above general AC.
- The validation flow remains the same as the current flow. Refer to the existing User Story
(US).
~~~

<a id="ac-22-03"></a>

#### **AC-22-03 — Tab 2 – Group**

**Nguồn:** mục FRD 7.22.5.2; [trang 76](../../FRD_Package%20with%20multi%20currency.pdf#page=76).
**Diễn giải:** Xử lý group gắn với currency đã chọn theo các điều kiện và phụ thuộc trong FRD.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 76 ---
7.22.5.2. Tab 2 – Group
- View UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---
BO---New?node-id=26251-15506&t=q33ezT5o3zSk35oo-4
- Based on the above general AC.
- Get list group based on the selected currency (refer to US Group name configuration
FRD_Package with multi currency.
- The validation flow remains the same as the current flow.
~~~

<a id="ac-22-04"></a>

#### **AC-22-04 — Tab 3 – Add-Ons**

**Nguồn:** mục FRD 7.22.5.3; [trang 76](../../FRD_Package%20with%20multi%20currency.pdf#page=76).
**Diễn giải:** Đây là tiêu đề nhóm do BA đặt; không tự phát sinh một AC độc lập. Xem các điều kiện con ở các nhóm tiếp theo.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 76 ---
7.22.5.3. Tab 3 – Add-Ons
~~~

<a id="ac-22-05"></a>

#### **AC-22-05 — Expert Advisor**

**Nguồn:** mục FRD 7.22.5.3.1; [trang 76](../../FRD_Package%20with%20multi%20currency.pdf#page=76).
**Diễn giải:** Cấu hình customize Instant theo từng currency; currency mới clone cấu hình USD và thay đổi chưa lưu cần popup xác nhận khi chuyển. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 76 ---
7.22.5.3.1. Expert Advisor
- View UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---
BO---New?node-id=26251-13127&t=q33ezT5o3zSk35oo-4
- Based on the above general AC.
- The validation flow remains the same as the current flow. Refer to the existing User Story
(US).
~~~

<a id="ac-22-06"></a>

#### **AC-22-06 — Max daily loss option**

**Nguồn:** mục FRD 7.22.5.3.2; [trang 76](../../FRD_Package%20with%20multi%20currency.pdf#page=76).
**Diễn giải:** Cấu hình customize Instant theo từng currency; currency mới clone cấu hình USD và thay đổi chưa lưu cần popup xác nhận khi chuyển. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 76 ---
7.22.5.3.2. Max daily loss option
- View UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---
BO---New?node-id=26251-11945&t=q33ezT5o3zSk35oo-4
- Based on the above general AC.
- The validation flow remains the same as the current flow. Refer to the existing User Story
(US).
~~~

<a id="ac-22-07"></a>

#### **AC-22-07 — Max total loss option**

**Nguồn:** mục FRD 7.22.5.3.3; [trang 76](../../FRD_Package%20with%20multi%20currency.pdf#page=76), [trang 77](../../FRD_Package%20with%20multi%20currency.pdf#page=77).
**Diễn giải:** Cấu hình customize Instant theo từng currency; currency mới clone cấu hình USD và thay đổi chưa lưu cần popup xác nhận khi chuyển. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 76 ---
7.22.5.3.3. Max total loss option
- View UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---
BO---New?node-id=26251-11308&t=q33ezT5o3zSk35oo-4
- Based on the above general AC.
--- Trang 77 ---
- The validation flow remains the same as the current flow. Refer to the existing User Story
(US).
~~~

<a id="ac-22-08"></a>

#### **AC-22-08 — Tab 4 – Risk Consistency**

**Nguồn:** mục FRD 7.22.5.4; [trang 77](../../FRD_Package%20with%20multi%20currency.pdf#page=77).
**Diễn giải:** Cấu hình customize Instant theo từng currency; currency mới clone cấu hình USD và thay đổi chưa lưu cần popup xác nhận khi chuyển. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 77 ---
7.22.5.4. Tab 4 – Risk Consistency
- View UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---
BO---New?node-id=26240-14688&t=q33ezT5o3zSk35oo-4
- Based on the above general AC.
- The validation flow remains the same as the current flow. Refer to the existing User Story
(US).
~~~

<a id="ac-22-09"></a>

#### **AC-22-09 — Tab 5 – Profit Consistency**

**Nguồn:** mục FRD 7.22.5.5; [trang 77](../../FRD_Package%20with%20multi%20currency.pdf#page=77).
**Diễn giải:** Cấu hình customize Instant theo từng currency; currency mới clone cấu hình USD và thay đổi chưa lưu cần popup xác nhận khi chuyển. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 77 ---
7.22.5.5. Tab 5 – Profit Consistency
- View UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---
BO---New?node-id=26248-14979&t=q33ezT5o3zSk35oo-4
- Based on the above general AC.
- The validation flow remains the same as the current flow. Refer to the existing User Story
(US).
~~~

<a id="ac-22-10"></a>

#### **AC-22-10 — Tab 6 – Profit Target**

**Nguồn:** mục FRD 7.22.5.6; [trang 77](../../FRD_Package%20with%20multi%20currency.pdf#page=77).
**Diễn giải:** Cấu hình customize Instant theo từng currency; currency mới clone cấu hình USD và thay đổi chưa lưu cần popup xác nhận khi chuyển. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 77 ---
7.22.5.6. Tab 6 – Profit Target
- View UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---
BO---New?node-id=26248-16247&t=q33ezT5o3zSk35oo-4
- Based on the above general AC.
- The validation flow remains the same as the current flow. Refer to the existing User Story
(US).
~~~

<a id="ac-22-11"></a>

#### **AC-22-11 — Tab 7 – Leverage**

**Nguồn:** mục FRD 7.22.5.7; [trang 77](../../FRD_Package%20with%20multi%20currency.pdf#page=77).
**Diễn giải:** Cấu hình customize Instant theo từng currency; currency mới clone cấu hình USD và thay đổi chưa lưu cần popup xác nhận khi chuyển. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 77 ---
7.22.5.7. Tab 7 – Leverage
- View UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/WMT---
BO---New?node-id=26248-15655&t=q33ezT5o3zSk35oo-4
- Based on the above general AC.
- The validation flow remains the same as the current flow. Refer to the existing User Story
(US).
~~~

### 23. [2-Phase Challenge_Customized packages] Setup 2-Phase challenge

Cấu hình customize 2-Phase theo currency, bao gồm lựa chọn currency, lưu, thay đổi chưa lưu, initial balance và group.

<a id="ac-23-01"></a>

#### **AC-23-01 — AC chung**

**Nguồn:** mục FRD 7.23.4; [trang 78](../../FRD_Package%20with%20multi%20currency.pdf#page=78), [trang 79](../../FRD_Package%20with%20multi%20currency.pdf#page=79).
**Diễn giải:** Cấu hình customize 2-Phase theo currency, bao gồm lựa chọn currency, lưu, thay đổi chưa lưu, initial balance và group.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-12](#q-12) — **Chờ trả lời:** Khi clone cấu hình USD sang currency mới, giữ nguyên các giá trị số hay quy đổi các trường tiền theo tỷ giá; những trường nào cần admin kiểm tra lại?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 78 ---
- Display a Currency dropdown.
o Default value: USD.
o The dropdown list is populated based on the configured Currency List (BO >
Package management > Currency List – both Active and Inactive)
o When a new currency is added to the Currency List, the system automatically
adds that currency to the dropdown and clones the configuration data from USD
for the newly added currency.
- When a currency is deleted from the Currency List:
o The currency is removed from the dropdown.
o All configuration data associated with that currency are permanently deleted.
- When Admin selects a specific currency from the dropdown:
o The system displays the configuration data for the selected currency.
o Any changes made are applied only to the selected currency.
o The Save Changes button saves the configuration for the currently selected
currency.
- When Admin makes any changes to the currency configuration, the system marks the
configuration as unsaved.
- When Admin attempts to switch to another currency while there are unsaved changes, the
system displays a confirmation popup:
--- Trang 79 ---
o Title: “You have unsaved changes”
o Message: “Your changes have not been saved. Do you want to save them before
leaving?”
o Save Changes: Save the current currency configuration, then switch to the
selected currency.
o Discard Changes: Discard all unsaved changes, then switch to the selected
currency.
o Cancel: Close the popup and remain in the current currency without losing any
changes.
o If there are no unsaved changes, Admin can switch between currencies without
displaying the confirmation popup.
~~~

<a id="ac-23-02"></a>

#### **AC-23-02 — Tab 1 – Initial balance**

**Nguồn:** mục FRD 7.23.4.1; [trang 80](../../FRD_Package%20with%20multi%20currency.pdf#page=80).
**Diễn giải:** Cấu hình hoặc hiển thị initial balance theo currency đang chọn; các validation tham chiếu tài liệu hiện hành.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 80 ---
7.23.4.1. Tab 1 – Initial balance
- View UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--
WeMasterTrade--New-?node-id=27333-38450&t=mmakhlW40VDrpi8x-4
- Based on the above general AC.
- The validation flow remains the same as the current flow. Refer to the existing User Story
(US Configure Initial Balance for 2-phase of the Challenge  FRD_WMT_Challenge_BO-
1.0.docx).
~~~

<a id="ac-23-03"></a>

#### **AC-23-03 — Tab 2 – Group**

**Nguồn:** mục FRD 7.23.4.2; [trang 80](../../FRD_Package%20with%20multi%20currency.pdf#page=80).
**Diễn giải:** Xử lý group gắn với currency đã chọn theo các điều kiện và phụ thuộc trong FRD.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 80 ---
7.23.4.2. Tab 2 – Group
- View UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--
WeMasterTrade--New-?node-id=27333-38467&t=mmakhlW40VDrpi8x-4
- Based on the above general AC.
- The validation flow remains the same as the current flow. Refer to the existing User Story
(US Configure Groups for 2-phase of the Challenge FRD_WMT_Challenge_BO-
1.0.docx).
- Get list group based on the selected currency (refer to US Group name configuration
FRD_Package with multi currency.
~~~

### 24. [1-Phase Challenge_Customized packages] Setup 1-Phase Challenge

Cấu hình customize 1-Phase theo currency; các tab Initial Balance và Group dùng nhãn tiểu mục 7.25 dù nằm dưới 7.24.

<a id="ac-24-01"></a>

#### **AC-24-01 — AC chung**

**Nguồn:** mục FRD 7.24.4; [trang 80](../../FRD_Package%20with%20multi%20currency.pdf#page=80), [trang 81](../../FRD_Package%20with%20multi%20currency.pdf#page=81).
**Diễn giải:** Cấu hình customize 1-Phase theo currency; các tab Initial Balance và Group dùng nhãn tiểu mục 7.25 dù nằm dưới 7.24.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.
- [Q-12](#q-12) — **Chờ trả lời:** Khi clone cấu hình USD sang currency mới, giữ nguyên các giá trị số hay quy đổi các trường tiền theo tỷ giá; những trường nào cần admin kiểm tra lại?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 80 ---
• Display a Currency dropdown.
--- Trang 81 ---
◦ Default value: USD.
◦ The dropdown list is populated based on the configured Currency List (BO > Package
management > Currency List – both Active and Inactive)
◦ When a new currency is added to the Currency List, the system automatically adds that
currency to the dropdown and clones the configuration data from USD for the newly
added currency.
• When a currency is deleted from the Currency List:
◦ The currency is removed from the dropdown.
◦ All configuration data associated with that currency are permanently deleted.
• When Admin selects a specific currency from the dropdown:
◦ The system displays the configuration data for the selected currency.
◦ Any changes made are applied only to the selected currency.
◦ The Save Changes button saves the configuration for the currently selected currency.
• When Admin makes any changes to the currency configuration, the system marks the
configuration as unsaved.
• When Admin attempts to switch to another currency while there are unsaved changes, the
system displays a confirmation popup:
◦ Title: "You have unsaved changes"
◦ Message: "Your changes have not been saved. Do you want to save them before
leaving?"
◦ Save Changes: Save the current currency configuration, then switch to the selected
currency.
◦ Discard Changes: Discard all unsaved changes, then switch to the selected currency.
◦ Cancel: Close the popup and remain in the current currency without losing any
changes.
◦ If there are no unsaved changes, Admin can switch between currencies without
displaying the confirmation popup.
~~~

<a id="ac-24-02"></a>

#### **AC-24-02 — Tab 1 – Initial balance**

**Nguồn:** mục FRD 7.25.4.1; [trang 81](../../FRD_Package%20with%20multi%20currency.pdf#page=81), [trang 82](../../FRD_Package%20with%20multi%20currency.pdf#page=82).
**Diễn giải:** Cấu hình hoặc hiển thị initial balance theo currency đang chọn; các validation tham chiếu tài liệu hiện hành.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 81 ---
7.25.4.1. Tab 1 – Initial balance
• View UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--
WeMasterTrade--New-?node-id=4623-103387&t=mmakhlW40VDrpi8x-4
--- Trang 82 ---
• Based on the above general AC.
• The validation flow remains the same as the current flow. Refer to the existing User Story
(US Configure Initial Balance for 1-Phase Challenge package FRD_BO_One-Phase
Package.docx).
• Unit of Minimum initial balance and Maximum initial balance: the selected currency
(replace USD).
~~~

<a id="ac-24-03"></a>

#### **AC-24-03 — Tab 4 – Group**

**Nguồn:** mục FRD 7.25.4.2; [trang 82](../../FRD_Package%20with%20multi%20currency.pdf#page=82).
**Diễn giải:** Xử lý group gắn với currency đã chọn theo các điều kiện và phụ thuộc trong FRD.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 82 ---
7.25.4.2. Tab 4 – Group
• View UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--
WeMasterTrade--New-?node-id=8312-58542&t=mmakhlW40VDrpi8x-4
• Based on the above general AC.
• The validation flow remains the same as the current flow. Refer to the existing User Story
(US Configure Group for 1-Phase Challenge package FRD_BO_One-Phase Package.docx).
• Get list group based on the selected currency (refer to US Group name configuration
FRD_Package with multi currency.
~~~

### 25. Profit Request with multi-currency

Back Office xử lý profit request theo currency tài khoản, quy đổi USD, xác nhận net profit, cập nhật wallet/email và certificate.

<a id="ac-25-01"></a>

#### **AC-25-01 — AC chung**

**Nguồn:** mục FRD 7.25.4; [trang 82](../../FRD_Package%20with%20multi%20currency.pdf#page=82).
**Diễn giải:** Đây là phạm vi áp dụng cho các AC cùng chủ đề, không phải một tiêu chí độc lập: Apply for the trading accounts of 1-Phase Challenge the same as 2-Phase Challenge.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 82 ---
Apply for the trading accounts of 1-Phase Challenge the same as 2-Phase Challenge.
~~~

<a id="ac-25-02"></a>

#### **AC-25-02 — Profit request > Profit Request list**

**Nguồn:** mục FRD 7.25.4.1; [trang 83](../../FRD_Package%20with%20multi%20currency.pdf#page=83).
**Diễn giải:** Back Office xử lý profit request theo currency tài khoản, quy đổi USD, xác nhận net profit, cập nhật wallet/email và certificate. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 83 ---
7.25.4.1. Profit request > Profit Request list
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=8039-209851&t=mmakhlW40VDrpi8x-4
- In the profit request list in BO: Display Available Profit to Request and Convert to USD field.
− Header title row of profit request list:  Amount (USD) ==> Amount
o Data change from [Amount] to [Amount] [Currency]
− Convert to USD: Read only field (new field)
o Formula: Convert to USD = Available Profit to Withdraw / Currency rate
corresponding to the currency of the trading account
o Unit: USD
~~~

<a id="ac-25-03"></a>

#### **AC-25-03 — Profit request > Profit request details**

**Nguồn:** mục FRD 7.25.4.2; [trang 83](../../FRD_Package%20with%20multi%20currency.pdf#page=83).
**Diễn giải:** Back Office xử lý profit request theo currency tài khoản, quy đổi USD, xác nhận net profit, cập nhật wallet/email và certificate. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 83 ---
7.25.4.2. Profit request > Profit request details
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=8039-209845&t=mmakhlW40VDrpi8x-4
• Available Profit to Withdraw: Format: [Available Profit to Withdraw] [Currency]
• Convert to USD: Read-only field.
o Formula: Convert to USD = Available Profit to Withdraw / Currency Rate
corresponding to the trading account's currency.
o Unit: USD
• Net Profit to Receive:
o Formula: Net Profit to Receive = (Available Profit to Withdraw × Profit Share
Rate)
o If Profit Share Rate has not been entered: Display “-”
o Format: [Net Profit to Receive] [Currency]
• Convert to USD for Net Profit to Receive:
o Formula: Convert to USD for Net Profit to Receive = (Convert to USD × Profit
Share Rate)
o Around 2 decimals
o If Profit Share Rate has not been entered: Display “-”
o Unit: USD
~~~

<a id="ac-25-04"></a>

#### **AC-25-04 — Profit request > Send Net Profit to receive**

**Nguồn:** mục FRD 7.25.4.3; [trang 84](../../FRD_Package%20with%20multi%20currency.pdf#page=84).
**Diễn giải:** Back Office xử lý profit request theo currency tài khoản, quy đổi USD, xác nhận net profit, cập nhật wallet/email và certificate. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 84 ---
7.25.4.3. Profit request > Send Net Profit to receive
- Update email content:
o Email E000025 Confirm the Net Profit WMT_Email & Notification.xlsx
▪ Add new field: Convert to USD: [Convert to USD amount] USD (only
display this field when currency of trading account # USD)
▪ Update format Net Profit to Receive: [Net Profit to Receive] [Currency]
▪ Add new field: Convert to USD amount for Net Profit to Receive:
[Convert to USD amount for Net Profit to Receive] USD (only display this
field when currency of trading account # USD)
- Update notification:
o Notification ID N00024 Confirm the proposed Net Profit amount WMT_Email &
Notification.xlsx
▪ New content: The Net profit you can request is [Net Profit to Receive]
[Currency]. Please confirm if you would like to the proposed net profit
amount
~~~

<a id="ac-25-05"></a>

#### **AC-25-05 — Profit request > Approve profit request**

**Nguồn:** mục FRD 7.25.4.4; [trang 84](../../FRD_Package%20with%20multi%20currency.pdf#page=84), [trang 85](../../FRD_Package%20with%20multi%20currency.pdf#page=85).
**Diễn giải:** Back Office xử lý profit request theo currency tài khoản, quy đổi USD, xác nhận net profit, cập nhật wallet/email và certificate. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 84 ---
7.25.4.4. Profit request > Approve profit request
- For wallet flow:
o Amount: display the Convert to USD for Net Profit to Receive
▪ Apply change for both BO and FO Wallet Transaction.
o Refer to US Approve profit request FRD_PROFIT REQUEST.docx
- For email update:
o Update:
▪ Update field Available Profit to Request
• Format: [Available Profit to Request] [Currency]
▪ Update field Net Profit to Receive: [Net Profit to Receive] [Currency]
▪ Add new field Convert to USD: [Convert to USD amount for Net Profit to
Receive] USD
o Email applies:
▪ Email 32 – ID: E000019 - Submit Withdrawal request Approved
- trading account belonging to the one-time withdraw package
WMT_Email & Notification.xlsx
--- Trang 85 ---
▪ Email 38 – ID: E000023 - Submit Withdrawal Request Approved
- trading account not belonging to the one-time withdrawal package
WMT_Email & Notification.xlsx
~~~

<a id="ac-25-06"></a>

#### **AC-25-06 — Profit request > Approve profit request > Certificate**

**Nguồn:** mục FRD 7.25.4.5; [trang 85](../../FRD_Package%20with%20multi%20currency.pdf#page=85).
**Diễn giải:** Điều chỉnh dữ liệu tiền/currency trên certificate theo từng giai đoạn.
**Lớp đề xuất:** Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Không thấy yêu cầu giao diện trực tiếp ở mục này; chỉ là đề xuất.
- **Backend:** Chuẩn bị và bàn giao dữ liệu/đơn vị theo AC.
- **Internal Service:** Ứng viên: dịch vụ email, ví, affiliate, certificate hoặc tích hợp đích tương ứng; ranh giới chưa được xác minh.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-04](#q-04) — **Chờ trả lời:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 85 ---
7.25.4.5. Profit request > Approve profit request > Certificate
o In the profit split certificate: Amount to Request = [Available Profit to Request]
[Currency]
▪ Ref US: Automatically generate a certificate of profit split when a
withdrawal request has been completed
~~~

### 26. [2-Phase Challenge] 2-Phase Challenge list

Danh sách và chi tiết 2-Phase Challenge hiển thị currency; chi tiết giữ initial balance theo currency và total payment quy đổi USD.

<a id="ac-26-01"></a>

#### **AC-26-01 — AC chung**

**Nguồn:** mục FRD 7.26.4; [trang 86](../../FRD_Package%20with%20multi%20currency.pdf#page=86).
**Diễn giải:** Danh sách và chi tiết 2-Phase Challenge hiển thị currency; chi tiết giữ initial balance theo currency và total payment quy đổi USD.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 86 ---
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=27333-38086&t=mmakhlW40VDrpi8x-4
- Add new field “Currency” in the 2-Phase challenge list
- Display the currency of all 2-Phase challenge
- Apply filter select for this column
~~~

<a id="ac-26-02"></a>

#### **AC-26-02 — View 2-Phase challenge detail**

**Nguồn:** mục FRD 7.26.4.1; [trang 86](../../FRD_Package%20with%20multi%20currency.pdf#page=86).
**Diễn giải:** Danh sách và chi tiết 2-Phase Challenge hiển thị currency; chi tiết giữ initial balance theo currency và total payment quy đổi USD. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 86 ---
7.26.4.1. View 2-Phase challenge detail
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=27333-38099&t=mmakhlW40VDrpi8x-4
- Field Initial balance update format: [Initial balance] [Currency]
- Field Total Payment: display checkout amount converts to USD (refer to US [Challenge]
Checkout with multicurrency package)
~~~

### 27. [1-Phase Challenge] 1-Phase Challenge list

Danh sách và chi tiết 1-Phase Challenge hiển thị và lọc currency; FRD đánh số chi tiết là 7.28.4.1 dù nằm dưới 7.27.

<a id="ac-27-01"></a>

#### **AC-27-01 — AC chung**

**Nguồn:** mục FRD 7.27.4; [trang 87](../../FRD_Package%20with%20multi%20currency.pdf#page=87).
**Diễn giải:** Danh sách và chi tiết 1-Phase Challenge hiển thị và lọc currency; FRD đánh số chi tiết là 7.28.4.1 dù nằm dưới 7.27.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 87 ---
Refer to US 1-Phase Challenge List – View 1-Phase Challenge List and 1-Phase Challenge
List – Search and Filter FRD_BO_One-Phase Package.docx
• Field "Currency" in the 1-Phase Challenge list: display the currency of all 1-Phase Challenge
• Apply filter select for this column
~~~

<a id="ac-27-02"></a>

#### **AC-27-02 — View 1-Phase Challenge detail**

**Nguồn:** mục FRD 7.28.4.1; [trang 87](../../FRD_Package%20with%20multi%20currency.pdf#page=87).
**Diễn giải:** Danh sách và chi tiết 1-Phase Challenge hiển thị và lọc currency; FRD đánh số chi tiết là 7.28.4.1 dù nằm dưới 7.27. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 87 ---
7.28.4.1. View 1-Phase Challenge detail
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=8172-298704&t=mmakhlW40VDrpi8x-4
Refer to US 1-Phase Challenge List – View Details of 1-Phase Challenge FRD_BO_One-
Phase Package.docx
• Field Initial balance update format: [Initial balance] [Currency]
• Field Total Payment: display checkout amount converts to USD (refer to US [1-Phase
Challenge] Checkout with multicurrency package)
~~~

### 28. [Group] Group name configuration

Group name có currency, filter theo currency và ràng buộc xóa khi group đã được package sử dụng.

<a id="ac-28-01"></a>

#### **AC-28-01 — AC chung**

**Nguồn:** mục FRD 7.28.4; [trang 88](../../FRD_Package%20with%20multi%20currency.pdf#page=88).
**Diễn giải:** Đây là tham chiếu tới tài liệu bên ngoài chưa được kiểm tra; không tự bổ sung AC từ tài liệu đó.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 88 ---
The currency AC: FRD_BO_Phase 2-1.0.docx
~~~

<a id="ac-28-02"></a>

#### **AC-28-02 — View group list**

**Nguồn:** mục FRD 7.28.4.1; [trang 88](../../FRD_Package%20with%20multi%20currency.pdf#page=88).
**Diễn giải:** Xử lý group gắn với currency đã chọn theo các điều kiện và phụ thuộc trong FRD.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 88 ---
7.28.4.1. View group list
UI here: https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=4127-76328&t=b5iwLdMUPLGnOkKW-4
- Add new field “Currency” in the group list
- Display the currency of all group
- Apply a select filter to this column. The filter options should include only the currencies
configured for the selected group.
~~~

<a id="ac-28-03"></a>

#### **AC-28-03 — Add new group**

**Nguồn:** mục FRD 7.28.4.2; [trang 88](../../FRD_Package%20with%20multi%20currency.pdf#page=88), [trang 89](../../FRD_Package%20with%20multi%20currency.pdf#page=89).
**Diễn giải:** Xử lý group gắn với currency đã chọn theo các điều kiện và phụ thuộc trong FRD.
**Lớp đề xuất:** FE · Backend — **Cần User xác nhận**.
- **FE:** Ứng viên cho nhập liệu, hiển thị, filter hoặc thông báo trong AC.
- **Backend:** Ứng viên cho dữ liệu, validation, tính toán hoặc lưu cấu hình khi AC cần; mức thay đổi thực tế chưa xác minh.
- **Internal Service:** Chưa đủ bằng chứng xác định một internal service riêng cho mục này.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 88 ---
7.28.4.2. Add new group
https://www.figma.com/design/fUZXGX8d0X2CkvF3tOComc/-BO--WeMasterTrade--
New-?node-id=27078-24290&t=mmakhlW40VDrpi8x-4
--- Trang 89 ---
- Add new field “Currency” in the add new group
- Display the list of currency configured in BO > Currency List
- Placeholder: Select currency
Update flow when delete group: based on this US Group Name Configuration – Delete group
name
- If there is a package created with this group name, the system displays an error message:
"This group name is being used for the package. Therefore, you cannot delete it”
Apply for the group names used in the 1-Phase Challenge package (Supported Currency of the
package and Customize 1-Phase Challenge → Groups).
~~~

### 29. [Transaction] Transaction for multicurrency

Transaction list/detail lưu và hiển thị checkout currency, tỷ giá tại thời điểm giao dịch, USD, payment method currency và balance currency; FRD có ví dụ 5 trường hợp.

<a id="ac-29-01"></a>

#### **AC-29-01 — AC chung**

**Nguồn:** mục FRD 7.29.4; [trang 90](../../FRD_Package%20with%20multi%20currency.pdf#page=90).
**Diễn giải:** Đây là phạm vi áp dụng cho các AC cùng chủ đề, không phải một tiêu chí độc lập: Apply for the transactions of Instant, 2-Phase Challenge and 1-Phase Challenge packages.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 90 ---
Apply for the transactions of Instant, 2-Phase Challenge and 1-Phase Challenge packages.
~~~

<a id="ac-29-02"></a>

#### **AC-29-02 — Danh sách giao dịch**

**Nguồn:** mục FRD 7.29.4; [trang 90](../../FRD_Package%20with%20multi%20currency.pdf#page=90), [trang 91](../../FRD_Package%20with%20multi%20currency.pdf#page=91).
**Diễn giải:** Hiển thị amount theo currency đã chọn, số quy đổi USD, equivalent amount, method currency và balance currency theo AC.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?
- [Q-07](#q-07) — **Chờ trả lời:** FO Transaction History hiển thị Convert to USD là dấu “-” khi Amount là USD, còn BO hiển thị lại giá trị USD: đây có phải khác biệt có chủ đích? Với giao dịch cũ không gắn package, Balance Currency là USD hay “—”?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 90 ---
− Transaction List:
o Amount: Format [Checkout amount] [Currency]
▪ Checkout amount: the amount the trader paid for the package, in the
currency selected at checkout (after discount and processing fee).
▪ Currency: the currency selected at checkout (3-character currency code, e.g.
USD, EUR, JPY).
▪ Example: 30 EUR
o Convert to USD: Format: [Checkout amount] USD. Convert the Checkout Amount
to USD based on the stored conversion rate. (this is new column next to Amount
field)
▪ Position: new column, placed right after the Amount column.
▪ Formula: Convert to USD = Checkout amount / Currency Rate
• Currency Rate: the rate of the selected currency stored in the
transaction at the time of checkout (Currency Rate from BO →
Package → Multi-Currency → Currency Rate).
• The value is not recalculated when Admin updates the Currency Rate
after the transaction was created.
• The value is the same as the field Convert checkout amount to USD
in User story [Instant] / [2-Phase Challenge] / [1-Phase Challenge]
Checkout with multicurrency package.
▪ When the amount field is USD, display amount by USD.
• Example: Amount = 30 USD → Convert to USD = 30 USD
▪ Example: Amount = 30 EUR, Currency Rate EUR = 0.8 → Convert to USD
= 37.5 USD
--- Trang 91 ---
o Equivalent amount: [Equivalent amount]
▪ Format: [Equivalent amount]
▪ The amount actually charged by the payment method, in the currency of the
payment method.
▪ Formula: follow the Equivalent amount rules of User story [Instant]
Checkout with multicurrency package:
• Selected currency = payment method currency: Equivalent amount =
Checkout amount (no conversion).
• Payment method currency = USD and selected currency # USD:
Equivalent amount = Checkout amount / Currency Rate.
• Payment method currency # USD and selected currency # USD:
Equivalent amount = (Checkout amount / Currency Rate) * Rate of
BO → Country → Currency.
o Update currency current to Method Currency
▪ Rename the current column "Currency" to "Method Currency".
▪ Display the currency of the payment method used for the transaction (3-
character currency code).
▪ The value and logic of the column are unchanged; only the label changes.
o Add column Balance Currency: display currency of initial balance
▪ Display the currency of the initial balance of the purchased package (= the
currency of the trading account created from this transaction).
▪ Format: 3-character currency code (e.g. USD, EUR).
▪ If the transaction is not linked to a package (no initial balance), display "—".
~~~

<a id="ac-29-03"></a>

#### **AC-29-03 — Giao dịch cũ**

**Nguồn:** mục FRD 7.29.4; [trang 91](../../FRD_Package%20with%20multi%20currency.pdf#page=91), [trang 92](../../FRD_Package%20with%20multi%20currency.pdf#page=92).
**Diễn giải:** Với giao dịch trước release, giữ số tiền hiện có và áp dụng quy tắc mặc định USD theo phạm vi FRD.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-07](#q-07) — **Chờ trả lời:** FO Transaction History hiển thị Convert to USD là dấu “-” khi Amount là USD, còn BO hiển thị lại giá trị USD: đây có phải khác biệt có chủ đích? Với giao dịch cũ không gắn package, Balance Currency là USD hay “—”?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 91 ---
− Transactions created before release
o Amount: keep the current value, currency = USD.
o Convert to USD: display the same value as Amount (USD).
o Equivalent amount and Method Currency: keep the current values.
o Balance Currency: USD.
Example:
--- Trang 92 ---
Case
Amoun
t
Currenc
y Rate
(Package
)
Conver
t to
USD
Method
Currenc
y
Rate
(Country
)
Equivalen
t amount
Balance
Currenc
y
1. USD
package
, USD
method
30 USD 1 30 USD USD — 30 USD USD
2. EUR
package
, USD
method
30 EUR 0.8
37.5
USD
USD — 37.5 USD EUR
3. JPY
package
, JPY
method
4,500
JPY
150 30 USD JPY — 4,500 JPY JPY
4. EUR
package
, VND
method
30 EUR 0.8
37.5
USD
VND 26,000
975,000
VND
EUR
5. USD
package
, VND
method
30 USD 1 30 USD VND 26,000
780,000
VND
USD
~~~

<a id="ac-29-04"></a>

#### **AC-29-04 — Chi tiết giao dịch**

**Nguồn:** mục FRD 7.29.4; [trang 92](../../FRD_Package%20with%20multi%20currency.pdf#page=92), [trang 93](../../FRD_Package%20with%20multi%20currency.pdf#page=93), [trang 94](../../FRD_Package%20with%20multi%20currency.pdf#page=94).
**Diễn giải:** Hiển thị amount theo currency đã chọn, số quy đổi USD, equivalent amount, method currency và balance currency theo AC.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Hiển thị currency, số tiền và trạng thái theo AC nếu có màn hình.
- **Backend:** Áp dụng hoặc điều phối quy tắc tính toán, lưu và cung cấp dữ liệu.
- **Internal Service:** Ứng viên: dịch vụ payment, trading, wallet hoặc profit; cần xác nhận nơi thực thi và contract.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-05](#q-05) — **Chờ trả lời:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?
- [Q-06](#q-06) — **Chờ trả lời:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?
- [Q-07](#q-07) — **Chờ trả lời:** FO Transaction History hiển thị Convert to USD là dấu “-” khi Amount là USD, còn BO hiển thị lại giá trị USD: đây có phải khác biệt có chủ đích? Với giao dịch cũ không gắn package, Balance Currency là USD hay “—”?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 92 ---
− Transaction Detail: Display these field:
o Amount: Format [Checkout amount] [Currency]
▪ Checkout amount: the amount the trader paid for the package, in the
currency selected at checkout (after discount and processing fee).
--- Trang 93 ---
▪ Currency: the currency selected at checkout (3-character currency code, e.g.
USD, EUR, JPY).
▪ Example: 30 EUR
o Convert to USD: Format: [Checkout amount] USD. Convert the Checkout Amount
to USD based on the stored conversion rate. (this is new column next to Amount
field)
▪ Position: new column, placed right after the Amount column.
▪ Formula: Convert to USD = Checkout amount / Currency Rate
• Currency Rate: the rate of the selected currency stored in the
transaction at the time of checkout (Currency Rate from BO →
Package → Multi-Currency → Currency Rate).
• The value is not recalculated when Admin updates the Currency Rate
after the transaction was created.
• The value is the same as the field Convert checkout amount to USD
in User story [Instant] / [2-Phase Challenge] / [1-Phase Challenge]
Checkout with multicurrency package.
▪ When the amount field is USD, display amount by USD.
• Example: Amount = 30 USD → Convert to USD = 30 USD
▪ Example: Amount = 30 EUR, Currency Rate EUR = 0.8 → Convert to USD
= 37.5 USD
o Equivalent amount: [Equivalent amount]
▪ Format: [Equivalent amount]
▪ The amount actually charged by the payment method, in the currency of the
payment method.
▪ Formula: follow the Equivalent amount rules of User story [Instant]
Checkout with multicurrency package:
• Selected currency = payment method currency: Equivalent amount =
Checkout amount (no conversion).
• Payment method currency = USD and selected currency # USD:
Equivalent amount = Checkout amount / Currency Rate.
--- Trang 94 ---
• Payment method currency # USD and selected currency # USD:
Equivalent amount = (Checkout amount / Currency Rate) * Rate of
BO → Country → Currency.
▪ In case equivalent amount is null, return Equivalent amount = Amount
o Update currency current to Method Currency
▪ Rename the current column "Currency" to "Method Currency".
▪ Display the currency of the payment method used for the transaction (3-
character currency code).
▪ The value and logic of the column are unchanged; only the label changes.
o Balance Currency: display currency of initial balance
▪ Display the currency of the initial balance of the purchased package (= the
currency of the trading account created from this transaction).
~~~

### 30. Account Management

Trading Service Account Management thêm currency, xử lý tài khoản cũ USD và hiển thị currency trong account detail.

<a id="ac-30-01"></a>

#### **AC-30-01 — AC chung**

**Nguồn:** mục FRD 7.30.4; [trang 94](../../FRD_Package%20with%20multi%20currency.pdf#page=94).
**Diễn giải:** Đây là phạm vi áp dụng cho các AC cùng chủ đề, không phải một tiêu chí độc lập: Apply for the trading accounts of 1-Phase Challenge (Phase 1 and Funded Account).
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Màn quản trị hiển thị các trường, cột hoặc filter theo AC.
- **Backend:** Ứng viên cung cấp dữ liệu và filter cho màn hình; chưa xác định ranh giới API.
- **Internal Service:** Ứng viên là Trading Service cung cấp dữ liệu tài khoản/risk; FRD không xác định mã nguồn hay owner.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 94 ---
Apply for the trading accounts of 1-Phase Challenge (Phase 1 and Funded Account).
~~~

<a id="ac-30-02"></a>

#### **AC-30-02 — Account management list**

**Nguồn:** mục FRD 7.30.4.1; [trang 95](../../FRD_Package%20with%20multi%20currency.pdf#page=95).
**Diễn giải:** Trading Service Account Management thêm currency, xử lý tài khoản cũ USD và hiển thị currency trong account detail. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Màn quản trị hiển thị các trường, cột hoặc filter theo AC.
- **Backend:** Ứng viên cung cấp dữ liệu và filter cho màn hình; chưa xác định ranh giới API.
- **Internal Service:** Ứng viên là Trading Service cung cấp dữ liệu tài khoản/risk; FRD không xác định mã nguồn hay owner.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 95 ---
7.30.4.1. Account management list
https://www.figma.com/design/Jt8JHwiLpZIE08gyMDCoSK/-WMT----UI-draft?node-
id=11174-8651&t=cbpoZliTm15sxUGK-4
- Add new field “Currency” (Between field Initial Balance and Account Status)
- Display the currency of any trading account.
- For the trading account before release, mark it currency “USD”
~~~

<a id="ac-30-03"></a>

#### **AC-30-03 — View Account detail**

**Nguồn:** mục FRD 7.30.4.2; [trang 95](../../FRD_Package%20with%20multi%20currency.pdf#page=95).
**Diễn giải:** Trading Service Account Management thêm currency, xử lý tài khoản cũ USD và hiển thị currency trong account detail. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Màn quản trị hiển thị các trường, cột hoặc filter theo AC.
- **Backend:** Ứng viên cung cấp dữ liệu và filter cho màn hình; chưa xác định ranh giới API.
- **Internal Service:** Ứng viên là Trading Service cung cấp dữ liệu tài khoản/risk; FRD không xác định mã nguồn hay owner.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 95 ---
7.30.4.2. View Account detail
https://www.figma.com/design/Jt8JHwiLpZIE08gyMDCoSK/-WMT----UI-draft?node-
id=11579-12373&t=cbpoZliTm15sxUGK-4
- Field Initial balance update format: [Initial balance] [Currency]
- Field Max Daily Loss: Update the display format to [Max Daily Loss value] [Currency].
o The currency must be displayed as a 3-character currency code (e.g., USD, EUR).
o The currency code is fixed at the right end of the field.
- Field Max Total Loss: Update the display format to [Max Total Loss value] [Currency].
o The currency must be displayed as a 3-character currency code (e.g., USD, EUR).
o The currency code is fixed at the right end of the field.
~~~

### 31. Risk management – Account Overview

Trading Service Risk Account Overview bỏ nhãn cố định USD, thêm bộ lọc và cột currency dựa trên dữ liệu tài khoản.

<a id="ac-31-01"></a>

#### **AC-31-01 — AC chung**

**Nguồn:** mục FRD 7.31.4; [trang 95](../../FRD_Package%20with%20multi%20currency.pdf#page=95).
**Diễn giải:** Đây là phạm vi áp dụng cho các AC cùng chủ đề, không phải một tiêu chí độc lập: Apply for the trading accounts of 1-Phase Challenge (Phase 1 and Funded Account).
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Màn quản trị hiển thị các trường, cột hoặc filter theo AC.
- **Backend:** Ứng viên cung cấp dữ liệu và filter cho màn hình; chưa xác định ranh giới API.
- **Internal Service:** Ứng viên là Trading Service cung cấp dữ liệu tài khoản/risk; FRD không xác định mã nguồn hay owner.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 95 ---
Apply for the trading accounts of 1-Phase Challenge (Phase 1 and Funded Account).
~~~

<a id="ac-31-02"></a>

#### **AC-31-02 — Filter section**

**Nguồn:** mục FRD 7.31.4.1; [trang 96](../../FRD_Package%20with%20multi%20currency.pdf#page=96).
**Diễn giải:** Áp dụng các cột tìm kiếm/bộ lọc được nêu; quy tắc chung được tham chiếu trong nguồn.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Màn quản trị hiển thị các trường, cột hoặc filter theo AC.
- **Backend:** Ứng viên cung cấp dữ liệu và filter cho màn hình; chưa xác định ranh giới API.
- **Internal Service:** Ứng viên là Trading Service cung cấp dữ liệu tài khoản/risk; FRD không xác định mã nguồn hay owner.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 96 ---
7.31.4.1. Filter section
Refer to US Filter Section  Account Overview .docx
https://www.figma.com/design/Jt8JHwiLpZIE08gyMDCoSK/-WMT----UI-draft?node-
id=27572-12896&t=cbpoZliTm15sxUGK-4
- Change label of field:
o Initial Balance (USD) --> Initial Balance
o Total PnL (USD) --> Total PnL
o Highest Daily PnL (USD) --> Highest Daily PnL
- Add new filter: Currency
o Default: all currency
o Placeholder: Select
o Get list currency existed from Result Account overview list
o Position: Above the Initial Balance field.
~~~

<a id="ac-31-03"></a>

#### **AC-31-03 — Result list**

**Nguồn:** mục FRD 7.31.4.2; [trang 96](../../FRD_Package%20with%20multi%20currency.pdf#page=96).
**Diễn giải:** Trading Service Risk Account Overview bỏ nhãn cố định USD, thêm bộ lọc và cột currency dựa trên dữ liệu tài khoản. Xem điều kiện cụ thể và trích dẫn BA ngay dưới.
**Lớp đề xuất:** FE · Backend · Internal Service — **Cần User xác nhận**.
- **FE:** Màn quản trị hiển thị các trường, cột hoặc filter theo AC.
- **Backend:** Ứng viên cung cấp dữ liệu và filter cho màn hình; chưa xác định ranh giới API.
- **Internal Service:** Ứng viên là Trading Service cung cấp dữ liệu tài khoản/risk; FRD không xác định mã nguồn hay owner.

**Câu hỏi gắn với AC:**
- [Q-01](#q-01) — **Chờ trả lời:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?
- [Q-11](#q-11) — **Chờ trả lời:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Nội dung BA trích từ PDF:**

~~~text
--- Trang 96 ---
7.31.4.2. Result list
Refer to US View account overview  Account Overview .docx
https://www.figma.com/design/Jt8JHwiLpZIE08gyMDCoSK/-WMT----UI-draft?node-
id=27572-12896&t=cbpoZliTm15sxUGK-4
- Change label of field:
o Initial Balance (USD) --> Initial Balance
o Total PnL (USD) --> Total PnL
o Highest Daily PnL (USD) --> Highest Daily PnL
- Add new column: Currency
o Display currency of trading account
o Position: between field Initial Balance and Total PnL
~~~

## 6. Các câu hỏi chờ User xác nhận

Bạn có thể trả lời theo mã câu hỏi và, nếu cần, chỉ rõ mã AC. Các mục chưa được trả lời tiếp tục ở trạng thái chờ.

<a id="q-01"></a>

### Q-01 — Xác nhận phân công lớp

**Trạng thái:** Chờ trả lời.

**Câu hỏi:** Với từng nhóm AC được đánh dấu, FE, Backend và Internal Service nào là owner thực tế? Những ranh giới API/sự kiện giữa các nhóm là gì?

**Bằng chứng / giới hạn:** Ví dụ này giả định không có mã nguồn WeMasterTrade; đối chiếu kiến trúc và code khi áp dụng thật.

**Rủi ro và đề xuất:** Sai owner có thể làm thiếu việc hoặc triển khai trùng; đề xuất: review từng nhóm AC cùng đại diện các team.

**AC liên quan:** Tất cả 158 nhóm AC; ví dụ [AC-01-01](#ac-01-01), [AC-01-02](#ac-01-02), [AC-01-03](#ac-01-03), [AC-01-04](#ac-01-04).

<a id="q-02"></a>

### Q-02 — Phạm vi cTrader

**Trạng thái:** Chờ trả lời.

**Câu hỏi:** Trong release này, màn FO cTrader có cần hiển thị USD chọn được và các currency khác disabled/Coming soon như 7.5, hay chỉ BO cần chuẩn bị tab cTrader?

**Bằng chứng / giới hạn:** FRD trang 4 loại luồng multicurrency cTrader khỏi release; trang 19 lại mô tả hành vi hiển thị, và trang 42 liệt kê email cTrader.

**Rủi ro và đề xuất:** Hai cách hiểu dẫn đến phạm vi FE và tích hợp khác nhau; đề xuất: BA xác nhận riêng phần hiển thị và phần xử lý.

**AC liên quan:** [AC-05-01](#ac-05-01), [AC-11-03](#ac-11-03).

<a id="q-03"></a>

### Q-03 — Balance nhập hay chỉ đọc

**Trạng thái:** Chờ trả lời.

**Câu hỏi:** Balance ở customize là trường user nhập hay read-only? Nếu nhập trước rồi đổi currency thì giữ nguyên số và revalidate theo giới hạn mới đúng không?

**Bằng chứng / giới hạn:** Các bảng trang 17, 22, 25–26 ghi read-only nhưng cũng mô tả user nhập và giữ giá trị khi đổi currency.

**Rủi ro và đề xuất:** Thiết kế trường và xác thực có thể sai; đề xuất: xác nhận với BA và đối chiếu thiết kế/flow hiện hành.

**AC liên quan:** [AC-04-02](#ac-04-02), [AC-06-02](#ac-06-02), [AC-07-02](#ac-07-02).

<a id="q-04"></a>

### Q-04 — Currency hiển thị và tiền payout

**Trạng thái:** Chờ trả lời.

**Câu hỏi:** Tooltip nói currency đã chọn áp dụng cho payouts: có phải chỉ số tiền tham chiếu được hiển thị theo currency tài khoản, còn tiền thực trả vào ví luôn là USD?

**Bằng chứng / giới hạn:** Trang 4, 54 quy định settlement USD; tooltip trên trang 17, 21 và 25 dễ hiểu là payout theo currency đã chọn.

**Rủi ro và đề xuất:** Người dùng có thể hiểu sai số tiền nhận; đề xuất: thống nhất wording và tách currency hiển thị khỏi currency settlement.

**AC liên quan:** [AC-04-01](#ac-04-01), [AC-06-01](#ac-06-01), [AC-07-01](#ac-07-01), [AC-16-01](#ac-16-01), [AC-16-02](#ac-16-02), [AC-16-03](#ac-16-03), [AC-16-04](#ac-16-04), [AC-16-05](#ac-16-05), [AC-25-01](#ac-25-01), [AC-25-02](#ac-25-02), [AC-25-03](#ac-25-03), [AC-25-04](#ac-25-04), [AC-25-05](#ac-25-05), [AC-25-06](#ac-25-06).

<a id="q-05"></a>

### Q-05 — Tỷ giá và làm tròn

**Trạng thái:** Chờ trả lời.

**Câu hỏi:** Refund và profit request dùng tỷ giá được chốt ở checkout, lúc tạo request hay lúc duyệt/chi trả? Quy tắc làm tròn, số chữ số theo từng currency và thời điểm làm tròn là gì?

**Bằng chứng / giới hạn:** Trang 90, 93 yêu cầu snapshot tỷ giá tại checkout cho transaction; trang 46, 49, 53, 83 chỉ dẫn Currency Rate và một số chỗ ghi khoảng 2 chữ số.

**Rủi ro và đề xuất:** Dùng tỷ giá hoặc làm tròn không nhất quán làm lệch tiền; đề xuất: BA/Finance quy định thời điểm chốt và ví dụ đối chiếu cho JPY, EUR, USD.

**AC liên quan:** [AC-08-01](#ac-08-01), [AC-08-02](#ac-08-02), [AC-08-03](#ac-08-03), [AC-08-04](#ac-08-04), [AC-08-06](#ac-08-06), [AC-08-07](#ac-08-07), [AC-08-08](#ac-08-08), [AC-08-10](#ac-08-10), [AC-09-01](#ac-09-01), [AC-09-02](#ac-09-02), [AC-09-03](#ac-09-03), [AC-09-04](#ac-09-04), [AC-09-05](#ac-09-05), [AC-09-06](#ac-09-06), [AC-09-07](#ac-09-07), [AC-09-10](#ac-09-10), [AC-10-01](#ac-10-01), [AC-10-02](#ac-10-02), [AC-10-03](#ac-10-03), [AC-10-04](#ac-10-04), [AC-10-05](#ac-10-05), [AC-10-06](#ac-10-06), [AC-10-07](#ac-10-07), [AC-10-09](#ac-10-09), [AC-13-02](#ac-13-02), [AC-14-01](#ac-14-01), [AC-14-02](#ac-14-02), [AC-14-03](#ac-14-03), [AC-16-04](#ac-16-04), [AC-16-05](#ac-16-05), [AC-18-01](#ac-18-01), [AC-18-02](#ac-18-02), [AC-18-03](#ac-18-03), [AC-18-04](#ac-18-04), [AC-25-02](#ac-25-02), [AC-25-03](#ac-25-03), [AC-25-04](#ac-25-04), [AC-25-05](#ac-25-05), [AC-29-02](#ac-29-02), [AC-29-03](#ac-29-03), [AC-29-04](#ac-29-04).

<a id="q-06"></a>

### Q-06 — Processing fee trong checkout

**Trạng thái:** Chờ trả lời.

**Câu hỏi:** Checkout Amount dùng làm cơ sở discount, commission, wallet và transaction có bao gồm processing fee hay chưa; processing fee được cộng tại bước nào?

**Bằng chứng / giới hạn:** Trang 18, 23, 26 mô tả Fee – Discount; trang 90 và 92 mô tả Checkout amount sau discount và processing fee.

**Rủi ro và đề xuất:** Có thể cộng thiếu hoặc hai lần phí; đề xuất: cung cấp công thức và ví dụ có processing fee khác 0.

**AC liên quan:** [AC-04-03](#ac-04-03), [AC-04-04](#ac-04-04), [AC-04-05](#ac-04-05), [AC-04-06](#ac-04-06), [AC-06-03](#ac-06-03), [AC-06-04](#ac-06-04), [AC-06-05](#ac-06-05), [AC-06-06](#ac-06-06), [AC-07-03](#ac-07-03), [AC-07-04](#ac-07-04), [AC-07-05](#ac-07-05), [AC-07-06](#ac-07-06), [AC-08-01](#ac-08-01), [AC-08-02](#ac-08-02), [AC-08-03](#ac-08-03), [AC-09-01](#ac-09-01), [AC-09-02](#ac-09-02), [AC-09-03](#ac-09-03), [AC-10-01](#ac-10-01), [AC-10-02](#ac-10-02), [AC-10-03](#ac-10-03), [AC-29-02](#ac-29-02), [AC-29-04](#ac-29-04).

<a id="q-07"></a>

### Q-07 — Hiển thị USD và dữ liệu cũ

**Trạng thái:** Chờ trả lời.

**Câu hỏi:** FO Transaction History hiển thị Convert to USD là dấu “-” khi Amount là USD, còn BO hiển thị lại giá trị USD: đây có phải khác biệt có chủ đích? Với giao dịch cũ không gắn package, Balance Currency là USD hay “—”?

**Bằng chứng / giới hạn:** Trang 29, 34, 38 khác cách hiển thị tại trang 90–91; trang 91 đồng thời nêu fallback USD cho giao dịch cũ và “—” khi không có package.

**Rủi ro và đề xuất:** Các màn và migration có thể không nhất quán; đề xuất: xác nhận theo từng màn và từng loại giao dịch.

**AC liên quan:** [AC-08-04](#ac-08-04), [AC-09-04](#ac-09-04), [AC-10-04](#ac-10-04), [AC-29-02](#ac-29-02), [AC-29-03](#ac-29-03), [AC-29-04](#ac-29-04).

<a id="q-08"></a>

### Q-08 — Vô hiệu hóa currency và giao dịch đang xử lý

**Trạng thái:** Chờ trả lời.

**Câu hỏi:** USD có phải luôn bật cả hai toggle hiển thị không? Giao dịch được xem là pending từ thời điểm nào để vẫn xử lý khi currency bị disable hoặc xóa?

**Bằng chứng / giới hạn:** Trang 57–59 mô tả pending vẫn dùng currency, chặn checkout mới và câu USD “cannot be deleted and Inactive 2 toggle”.

**Rủi ro và đề xuất:** Một thao tác quản trị có thể làm gián đoạn checkout hoặc khóa USD; đề xuất: quy định trạng thái chuyển tiếp và test tình huống đồng thời.

**AC liên quan:** [AC-17-03](#ac-17-03), [AC-17-04](#ac-17-04), [AC-17-05](#ac-17-05), [AC-17-06](#ac-17-06).

<a id="q-09"></a>

### Q-09 — Lưu Supported Currency

**Trạng thái:** Chờ trả lời.

**Câu hỏi:** Khi Add Currency cho package, “create a record” là tạo bản nháp trong FE hay ghi DB ngay? Việc Edit FE-only chỉ được persist khi Save package đúng không?

**Bằng chứng / giới hạn:** Trang 64–66, 68–69 và 71–73 mô tả Add, Edit chỉ FE và Save package cùng lúc.

**Rủi ro và đề xuất:** Nhấn Cancel hoặc lỗi Save có thể để lại dữ liệu dở dang; đề xuất: xác nhận vòng đời nháp và giao dịch lưu package.

**AC liên quan:** [AC-19-02](#ac-19-02), [AC-19-03](#ac-19-03), [AC-19-04](#ac-19-04), [AC-20-02](#ac-20-02), [AC-20-03](#ac-20-03), [AC-20-04](#ac-20-04), [AC-21-03](#ac-21-03), [AC-21-04](#ac-21-04), [AC-21-05](#ac-21-05).

<a id="q-10"></a>

### Q-10 — Group khi nâng phase

**Trạng thái:** Chờ trả lời.

**Câu hỏi:** Khi currency đã bị xóa khỏi cấu hình, group nào phải được lưu và dùng lại cho phase tiếp theo: group tại thời điểm mua, tại phase trước, hay group khác?

**Bằng chứng / giới hạn:** Trang 40–41, 43 ghi “stored and use this group” nhưng không xác định nơi lưu và thời điểm chốt.

**Rủi ro và đề xuất:** Tài khoản mới có thể được tạo sai group hoặc không tạo được; đề xuất: xác nhận nguồn snapshot và cách xử lý thiếu group.

**AC liên quan:** [AC-11-01](#ac-11-01), [AC-12-02](#ac-12-02).

<a id="q-11"></a>

### Q-11 — Phiên bản, đánh số và tài liệu phụ thuộc

**Trạng thái:** Chờ trả lời.

**Câu hỏi:** Bìa ghi version 1.0 nhưng revision có 1.1; bản nào là căn cứ? Vui lòng xác nhận các tiểu mục lệch số 7.22/7.25/7.28 và nội dung hiện hành trong FRD/thiết kế được tham chiếu.

**Bằng chứng / giới hạn:** Trang 1–2, 70–74, 81–82, 87; nhiều AC tham chiếu tài liệu, Figma và spreadsheet ngoài PDF chưa được kiểm tra.

**Rủi ro và đề xuất:** Áp dụng nhầm phiên bản hoặc thiếu quy tắc kế thừa; đề xuất: BA cung cấp bản được duyệt và các phụ thuộc cần thiết khi triển khai thật.

**AC liên quan:** [AC-01-03](#ac-01-03), [AC-02-03](#ac-02-03), [AC-03-01](#ac-03-01), [AC-03-03](#ac-03-03), [AC-04-01](#ac-04-01), [AC-05-01](#ac-05-01), [AC-06-01](#ac-06-01), [AC-07-01](#ac-07-01), [AC-08-08](#ac-08-08), [AC-09-07](#ac-09-07), [AC-10-07](#ac-10-07), [AC-10-08](#ac-10-08), [AC-11-01](#ac-11-01), [AC-11-02](#ac-11-02), [AC-12-01](#ac-12-01), [AC-12-02](#ac-12-02), [AC-12-03](#ac-12-03), [AC-13-01](#ac-13-01), [AC-13-02](#ac-13-02), [AC-14-01](#ac-14-01), [AC-14-02](#ac-14-02), [AC-14-03](#ac-14-03), [AC-16-04](#ac-16-04), [AC-16-05](#ac-16-05), [AC-17-01](#ac-17-01), [AC-19-02](#ac-19-02), [AC-20-02](#ac-20-02), [AC-21-01](#ac-21-01), [AC-21-02](#ac-21-02), [AC-21-03](#ac-21-03), [AC-21-04](#ac-21-04), [AC-21-05](#ac-21-05), [AC-21-06](#ac-21-06), [AC-21-07](#ac-21-07), [AC-22-02](#ac-22-02), [AC-22-03](#ac-22-03), [AC-22-05](#ac-22-05), [AC-22-06](#ac-22-06), [AC-22-07](#ac-22-07), [AC-22-08](#ac-22-08), [AC-22-09](#ac-22-09), [AC-22-10](#ac-22-10), [AC-22-11](#ac-22-11), [AC-23-02](#ac-23-02), [AC-23-03](#ac-23-03), [AC-24-01](#ac-24-01), [AC-24-02](#ac-24-02), [AC-24-03](#ac-24-03), [AC-25-05](#ac-25-05), [AC-26-02](#ac-26-02), [AC-27-01](#ac-27-01), [AC-27-02](#ac-27-02), [AC-31-02](#ac-31-02), [AC-31-03](#ac-31-03).

<a id="q-12"></a>

### Q-12 — Clone cấu hình USD sang currency mới

**Trạng thái:** Chờ trả lời.

**Câu hỏi:** Khi clone cấu hình USD sang currency mới, giữ nguyên các giá trị số hay quy đổi các trường tiền theo tỷ giá; những trường nào cần admin kiểm tra lại?

**Bằng chứng / giới hạn:** Trang 74, 78 và 81 yêu cầu clone cấu hình USD nhưng không quy định chuyển đổi các giá trị tiền.

**Rủi ro và đề xuất:** Giới hạn và phí có thể sai theo đơn vị mới; đề xuất: BA/Finance chỉ rõ từng loại trường và ví dụ khởi tạo.

**AC liên quan:** [AC-22-01](#ac-22-01), [AC-23-01](#ac-23-01), [AC-24-01](#ac-24-01).

## 7. Phạm vi kiểm tra và giới hạn

- Đã trích xuất văn bản theo từng trang của cả 97 trang. Trang 47 là sơ đồ nằm trong ảnh, đã đọc trực quan; trang 97 được render và xác nhận trắng.
- Đã xem 12 hình nhúng trên 11 trang: 5, 9, 12, 15, 19, 20, 24, 47, 50, 51 và 89. Bảng ví dụ trang 92 đã được render để đối chiếu bố cục.
- FRD có những tiểu mục đánh số trùng/lệch: 7.22 dưới chủ đề 7.21, 7.25 dưới chủ đề 7.24, và 7.28.4.1 dưới chủ đề 7.27. Báo cáo giữ số gốc và phân nhóm theo vị trí thực tế; Q-11 chờ BA xác nhận.
- Trích xuất PDF có thể thay đổi bullet/xuống dòng hoặc tách bảng; báo cáo cung cấp liên kết tới trang nguồn. Nội dung trong hình và các tài liệu bên ngoài chưa được biến thành AC mới nếu FRD không nêu rõ.
- Không có code, schema, hợp đồng API, môi trường chạy hay bằng chứng dữ liệu ứng dụng WeMasterTrade trong phạm vi ví dụ. Không thể kết luận hiện trạng đã đáp ứng/chưa đáp ứng các AC hoặc xác nhận owner.
- Đề xuất: khi áp dụng vào project thật, liên kết repo/contract liên quan, giải đáp các câu hỏi, rồi cập nhật cả báo cáo Markdown và HTML.
