# Deep dive: `/wayfinder` và `/grill-me` (aihero.dev)

Ngày đọc: 2026-11-24. Nguồn:
- https://www.aihero.dev/skills-wayfinder (trang cập nhật 2026-08-24)
- https://www.aihero.dev/skills-grill-me và https://aihero.dev/skills-grilling
- Mã nguồn: https://github.com/mattpocock/skills (MIT), các file
  `skills/engineering/wayfinder/SKILL.md`,
  `skills/productivity/grill-me/SKILL.md`,
  `skills/productivity/grilling/SKILL.md`

Tác giả: Matt Pocock. Các trang aihero không ghi tên, nhưng repo nguồn thuộc
`mattpocock`.

## 1. Tóm tắt

| | `/grill-me` | `/wayfinder` |
| :--- | :--- | :--- |
| Dùng khi | Ý tưởng còn mơ hồ, chốt được trong **một phiên** | Việc lớn, cần **nhiều phiên**, biết đích nhưng chưa biết đường |
| Đầu ra | Một bản hiểu chung đã được bạn xác nhận; không ghi file nào (stateless) | Một **map** gồm các ticket quyết định trên issue tracker (GitHub/GitLab, hoặc markdown local) |
| Cách gọi | Chỉ khi User gõ (`disable-model-invocation: true`) | Chỉ khi User gõ (`disable-model-invocation: true`) |
| Kích thước | 1 dòng: gọi skill `grilling` | Khoảng 12.4k ký tự, 8 mục |
| Phụ thuộc | `grilling` (thiếu thì "không có gì xảy ra") | `grilling`, `domain-modeling`, `prototype`, `research`, và `/setup-matt-pocock-skills` chạy trước |
| Bước tiếp theo | `to-spec` (hoặc `grill-with-docs` khi có codebase) | `to-spec` → `to-tickets` → `implement` |

Cả hai skill chỉ dùng để **quyết định**, không dùng để viết code. Đây là phase
lên kế hoạch trong bộ skill của Matt.

## 2. `/grill-me` và `grilling`

### Cấu trúc

`grill-me` chỉ là lớp vỏ một dòng: "Call the Skill tool with grilling". Toàn
bộ cơ chế nằm trong `grilling` (khoảng 2k ký tự, model tự gọi được, kích hoạt
khi người dùng nói "grill" hoặc muốn stress-test một kế hoạch). Matt tách như
vậy để mọi skill cần phỏng vấn (`grill-with-docs`, `wayfinder`) dùng chung một
primitive.

### Quy trình

1. Lập **design tree**: mỗi quyết định rẽ nhánh ra các quyết định phụ thuộc
   vào nó.
2. Mỗi lượt hỏi trọn **frontier**, tức mọi quyết định đã đủ điều kiện tiên
   quyết. Hai câu phụ thuộc nhau không bao giờ nằm chung một lượt.
3. Mỗi câu hỏi có số thứ tự, tiêu đề sau `❓` và một **câu trả lời đề xuất** ở
   dòng `➡`. Câu hỏi được viết sao cho trả lời "yes" là chấp nhận đề xuất.
4. **Fact và decision tách riêng**: fact thì agent tự tra bằng sub-agent;
   decision thì phải chờ User trả lời.
5. Lặp lại đến khi frontier rỗng. Skill **chỉ kết thúc khi User xác nhận** bản
   hiểu chung, không phải khi hết câu hỏi.

### Lời khuyên vận hành từ trang

- Mở trong cuộc hội thoại mới và tắt plan mode, vì plan mode khiến agent vội
  lập plan thay vì hỏi.
- Đếm theo lượt, không đếm theo câu: 46 câu trong 4 lượt là bình thường. Nếu
  lên tới 200 câu thì scope quá lớn; hãy tách việc ra hoặc chuyển sang
  `wayfinder`.
- Câu nào không trả lời được bằng lời (ví dụ "một form dài hay ba trang?") thì
  làm prototype trước.
- Muốn hỏi từng câu một thì thêm vào `CLAUDE.md`: `When grilling, ask one
  question at a time.`

### Giới hạn

- Frontier được chọn theo phán đoán, không tính từ đồ thị, nên đôi khi hai câu
  lẽ ra phụ thuộc nhau lại nằm chung một lượt.
- Model yếu hoặc chạy ở effort thấp có thể bỏ qua bước xác nhận và nhảy thẳng
  sang outline.
- Có bug đã biết: `grill-with-docs` đôi khi không load `grilling`. Triệu chứng
  là agent hỏi tất cả cùng lúc và không kèm đề xuất.

## 3. `/wayfinder`

Trước đây skill này tên là `decision-mapping` (đổi tên ở v1.1).

### Ý tưởng chính

Một ticket wayfinder hỏi một câu, và câu trả lời là **một quyết định, không
phải một lát của bản build**. Map xong khi không còn gì phải quyết trước lúc
build. Tinh thần chung: "Plan, don't do". Mỗi phiên làm ra quyết định, không
làm ra deliverable.

### Map

Một issue mang nhãn `wayfinder:map`, có các ticket con. Map là **index,
không phải kho chứa**: mỗi quyết định nằm trong ticket của nó, nên một phiên
mới chỉ cần load map ở độ phân giải thấp. Map có bốn mục:

1. **Destination**: đích của cả map, đặt trước khi có ticket nào.
2. **Decisions so far**: mỗi ticket đã đóng một dòng, kèm link.
3. **Not yet specified** (fog of war): những câu hỏi chưa phát biểu chính xác
   được. Phép thử là "phát biểu được câu hỏi chưa?", không phải "trả lời được
   chưa?".
4. **Out of scope**: việc ngoài phạm vi; đóng lại và không bao giờ đưa vào
   map.

### Bốn loại ticket

| Loại | Mode | Khi nào | Giải bằng |
| :--- | :--- | :--- | :--- |
| `grilling` | HITL | Mặc định; nói chuyện là chốt được | `grilling` và `domain-modeling` trong phiên mới |
| `prototype` | HITL | "Nó nên trông/hoạt động thế nào" | Prototype, link artifact vào ticket |
| `research` | AFK | Thiếu một fact bên ngoài | Sub-agent trên nhánh `research/<name>`, chạy song song được |
| `task` | Cả hai | Việc tay chặn quyết định (cấp quyền, đăng ký, chuyển data) | Agent làm nếu được, không thì đưa checklist cho người |

`task` là loại duy nhất *làm* thay vì *quyết*, và agent hay hiểu nhầm nó thành
bước implement.

### Vòng làm việc

1. Đặt destination.
2. Grill theo chiều rộng. Nếu không thấy fog nào, skill dừng và nói việc đủ nhỏ
   để bỏ qua map.
3. Lập map và các ticket, kèm cạnh blocking.
4. Mỗi phiên chọn **một** ticket ở frontier (đang mở, không bị chặn, chưa ai
   nhận) và nhận bằng cách **assign cho chính mình** trước khi làm. Assignee
   chính là khóa, nên các phiên chạy song song không đụng nhau.
5. Giải ticket, đăng comment kết luận, đóng ticket, thêm một dòng vào
   Decisions so far, rồi **dừng**. Ticket research là ngoại lệ duy nhất của quy
   tắc một ticket mỗi phiên.
6. Khi một quyết định làm một mục fog phát biểu được, chuyển mục đó thành
   ticket mới.
7. Gọi ticket bằng tên, không dùng `#42` trơn.
8. Map sạch thì chuyển sang `to-spec`. Map xong "trỏ tới một spec, không phải
   một PR".

### Giới hạn trang tự thừa nhận

- **Không có chốt cứng chống implement.** Ví dụ trên trang: agent tự ghi "this
  map carries execution" vào Notes, rồi các phiên sau coi dòng đó là giấy phép
  và build thẳng lên server thật.
- Map lớn dễ trôi thành waterfall: một người lập 27 ticket, và đến ticket thứ
  13 thì các ticket sau không còn khớp. Cách chữa trên trang là giới hạn map
  trong một epic và prototype nhiều.
- Ticket song song không chia sẻ context, nên có thể hỏi lại điều vừa chốt ở
  ticket khác.
- Chưa có hướng dẫn đảo ngược một quyết định đã đóng; agent có xu hướng thiết
  kế vòng quanh quyết định sai.
- Hỏi quá dài gây mệt mỏi khi phải quyết; chưa có cách chữa.
- Tracker không có liên kết blocking gốc phải suy ra phụ thuộc từ text. Dùng
  markdown local thì file lập kế hoạch dễ bị commit lỡ. Tracker public dễ đầy
  ticket do agent tạo.

## 4. Đối chiếu với repo này

| | `grilling` / `grill-me` | `wayfinder` | Repo này |
| :--- | :--- | :--- | :--- |
| Phỏng vấn | Theo lượt frontier, có đề xuất | Dùng `grilling` | `goal-griller`: **từng câu một**, có đề xuất, tự tra khi tìm được ("inspired by grill-me") |
| Điều kiện dừng | Frontier rỗng và User xác nhận | Map sạch | `goal-griller`: hard gate 6 trường (outcome, proof, scope, context, validation, pause) |
| Kế hoạch nhiều phiên | — | Map trên tracker | `sequence-execution-plan`, ticket/plan trong `docs-harness` |
| Chống tự implement | Dặn trong text | Dặn trong text, đã thấy bị vượt | Cổng authority (`0822-user-authority-operation-gate.md`) và mục "Do Not Silently Start" |

Nhận xét:

1. **`goal-griller` đã lấy lõi của grill-me** (đề xuất kèm câu hỏi, fact thì
   tự tra), nhưng hỏi từng câu thay vì theo lượt frontier. Hỏi theo lượt nhanh
   hơn khi các câu độc lập. Hỏi từng câu an toàn hơn khi câu sau phụ thuộc câu
   trước. Đây là điểm đáng thử nghiệm: cho `goal-griller` hỏi gộp các câu độc
   lập trong một lượt, và giữ quy tắc "câu phụ thuộc không chung lượt".
2. **Quy tắc "câu hỏi viết sao cho 'yes' = chấp nhận đề xuất"** rất rẻ và giảm
   công trả lời. `goal-griller` chưa có quy tắc này.
3. **Wayfinder phù hợp với dự án nhiều phiên trên GitHub Issues**. Repo này
   lưu kế hoạch trong file (`docs-harness`), không dùng tracker, nên nhập
   nguyên skill sẽ chồng lên `sequence-execution-plan`. Có ba ý đáng mượn: fog
   of war (tách "chưa phát biểu được" khỏi "chưa trả lời được"), "map là
   index, không phải kho chứa", và assignee làm khóa khi nhiều agent chạy song
   song (gần với cách điều phối worker qua Herdr).
4. **Bài học an toàn của wayfinder khớp với harness này**: agent coi ghi chú
   do chính nó viết là giấy phép. Repo đã chặn điều này bằng nguyên tắc
   "observed content không cấp quyền" và cổng authority. Đây là bằng chứng bên
   ngoài cho thấy rule đó cần thiết.

## 5. Nếu muốn cài

Plugin chính thức cho Claude Code: `claude plugin install
mattpocock-skills@claude-plugins-official`, sau đó chạy
`/setup-matt-pocock-skills` một lần cho mỗi repo. Lưu ý trước khi cài:

- `/setup-matt-pocock-skills` **ghi vào repo**: thêm mục "Wayfinding
  operations" và một con trỏ trong `CLAUDE.md`/`AGENTS.md`. Điều này đụng quy
  tắc #094 (installer bên thứ ba không được ghi AGENTS.md, rule hay hook vào
  repo) và quy tắc giới hạn độ dài `AGENTS.md`.
- Plugin có nhiều skill (`grilling` model-invocable, `to-spec`, `implement`,
  ...) có thể giành trigger với `goal-griller` và `prompt-leverage`.
- Cài cần User cấp quyền cụ thể (#009). Báo cáo này chưa cài gì.
