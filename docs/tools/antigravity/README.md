# Cẩm Nang Toàn Diện Về Tools, MCP & Skills Của Google Antigravity

> **Tài liệu tham khảo kỹ thuật cho nhóm phát triển (Team-Facing Documentation)**  
> *Vị trí lưu trữ*: `docs/tools/antigravity/README.md`  
> *Mục đích*: Tổng hợp chi tiết toàn bộ các công cụ tích hợp sẵn (Built-in Core Tools), hệ thống Model Context Protocol (MCP), Plugins, Skills và Slash Commands của nền tảng AI Agent **Google Antigravity (AGY)**.

---

## 1. Tổng Quan Kiến Trúc Antigravity

**Google Antigravity (AGY)** là một nền tảng lập trình cặp (Pair-Programming) và điều phối AI Agent tự trị thế hệ mới được phát triển bởi Google DeepMind. Nền tảng này kết hợp sức mạnh mô hình ngôn ngữ lớn (LLM) với một bộ công cụ phong phú cho phép:

- Thao tác trực tiếp trên cây thư mục, tệp mã nguồn và hệ điều hành của lập trình viên.
- Chạy các tác vụ nền, hẹn giờ đánh thức (Reactive Wakeup / Schedule) không cần vòng lặp thăm dò (polling).
- Khởi tạo và điều phối hệ thống đa đặc vụ song song (Multi-Agent Workspaces).
- Tương tác với trình duyệt Chrome qua giao thức Chrome DevTools Protocol (CDP) thông qua MCP.
- Tự động hóa tạo Artifacts, hình ảnh UI mockup, và giao tiếp tương tác với người dùng qua Modal trắc nghiệm.

```text
+-----------------------------------------------------------------------------------+
|                            Google Antigravity Runtime                            |
+-----------------------------------------------------------------------------------+
|  [Core Tools]       [MCP Plugins]             [Skills]         [Slash Commands]   |
|  - Filesystem       - Chrome DevTools MCP     - goal-griller   - /goal            |
|  - Execution (OS)   - Modern Web Guidance     - onboarding     - /plan            |
|  - Multi-Agent      - Antigravity SDK         - improve-harness- /grill-me        |
|  - Web & Image                                - xia, ...       - /learn           |
+-----------------------------------------------------------------------------------+
```

---

## 2. Danh Mục Built-in Core Tools (Công Cụ Cốt Lõi)

Hệ thống cung cấp sẵn 13 công cụ nền tảng được phân chia thành 5 nhóm chức năng chính:

### 2.1 Thao Tác Tệp & Mã Nguồn (Filesystem & Code Manipulation)

| Tên Tool | Chức Năng Chi Tiết | Trường Hợp Sử Dụng (Use Cases) |
| :--- | :--- | :--- |
| **`view_file`** | Đọc nội dung tệp tin từ ổ đĩa cục bộ. Hỗ trợ xem text (kèm chỉ số dòng `StartLine`, `EndLine`, phân trang tối đa 800 dòng/lần) và xem file nhị phân (Ảnh, PDF, Video, Audio). | Khảo sát mã nguồn, kiểm tra cấu hình, đọc tài liệu, kiểm tra ảnh UI đã sinh. |
| **`write_to_file`** | Tạo tệp tin mới hoặc ghi đè toàn bộ nội dung tệp tin. Tự động tạo thư mục cha nếu chưa tồn tại. Hỗ trợ metadata cho các User Artifacts. | Tạo module mới, khởi tạo file cấu hình, xuất tài liệu kế hoạch/báo cáo Walkthrough. |
| **`replace_file_content`** | Chỉnh sửa một khối mã nguồn liên tục (chunk replacement) trong file hiện có một cách chính xác dựa trên đoạn `TargetContent` và `ReplacementContent`. | Refactor code, thêm import, sửa lỗi cú pháp, chỉnh sửa tài liệu mà không cần viết lại cả file lớn. |
| **`list_dir`** | Liệt kê danh sách các tệp và thư mục con cấp 1 (kèm kích thước dung lượng và trạng thái tệp). | Khám phá cấu trúc dự án, kiểm tra danh mục tệp tin trước khi tìm kiếm sâu. |
| **`grep_search`** | Tìm kiếm chuỗi hoặc biểu thức chính quy (Regex) theo từng dòng trên toàn bộ thư mục bằng ripgrep. | Tìm định nghĩa hàm, tìm nơi import module, tra cứu chuỗi cấu hình trên toàn repo. |

---

### 2.2 Thực Thi Hệ Thống & Quản Lý Tiến Trình (Terminal & OS Execution)

| Tên Tool | Chức Năng Chi Tiết | Trường Hợp Sử Dụng (Use Cases) |
| :--- | :--- | :--- |
| **`run_command`** | Thực thi các lệnh PowerShell / Shell trực tiếp trên hệ thống của người dùng. Hỗ trợ cả chạy đồng bộ chờ kết quả và đẩy xuống nền chạy bất đồng bộ (Background Task). | Chạy test suite, build project, chạy linter, kiểm tra git status, khởi động dev server. |
| **`manage_task`** | Quản lý các tiến trình đang chạy ngầm (`list`, `status`, `send_input`, `kill`). | Kiểm tra tiến trình dev server, gửi tín hiệu ngắt (Ctrl+C), tương tác với lệnh CLI yêu cầu input. |
| **`schedule`** | Đặt lịch hẹn giờ một lần (Timer) hoặc định kỳ (Cron expression) để tự động đánh thức Agent gửi thông báo trong tương lai. | Hẹn giờ kiểm tra deploy sau 5 phút, kiểm tra health-check định kỳ, tránh dùng lệnh `sleep` làm kẹt luồng. |

---

### 2.3 Hệ Thống Đa Đặc Vụ (Multi-Agent & Subagent Orchestration)

| Tên Tool | Chức Năng Chi Tiết | Trường Hợp Sử Dụng (Use Cases) |
| :--- | :--- | :--- |
| **`define_subagent`** | Định nghĩa một loại subagent chuyên biệt mới (gồm Tên, Mô tả, System Prompt riêng, và quyền kích hoạt công cụ: Write, MCP, Subagent). | Tạo agent chuyên gia đọc code chỉ đọc (Read-only researcher), tạo agent chuyên viết test. |
| **`invoke_subagent`** | Khởi chạy một hoặc nhiều Subagent song song trong nền với các chế độ workspace: `inherit` (dùng chung), `branch` (tách nhánh riêng biệt), `share` (dùng chung ổ đĩa). | Ủy thác việc khảo sát tài liệu dài mà không làm ô nhiễm context chính; chạy tác vụ nghiên cứu song song. |
| **`manage_subagents`** | Quản lý danh sách các Subagent đang hoạt động (`list`, `kill`, `kill_all`). | Kiểm tra trạng thái làm việc của subagent, hủy subagent bị treo. |
| **`send_message`** | Gửi tin nhắn và hướng dẫn tiếp theo cho Subagent thông qua Conversation ID. | Phối hợp làm việc giữa Parent Agent và Subagents. |

---

### 2.4 Tra Cứu Trực Tuyến & Sinh Hình Ảnh (Web & Visual Generation)

| Tên Tool | Chức Năng Chi Tiết | Trường Hợp Sử Dụng (Use Cases) |
| :--- | :--- | :--- |
| **`search_web`** | Tìm kiếm thông tin trên Internet thời gian thực kèm theo trích dẫn nguồn (URL citations). | Tra cứu tài liệu thư viện mới nhất, tìm cách fix lỗi runtime chưa từng gặp, tra cứu spec chuẩn web. |
| **`read_url_content`** | Gửi HTTP request ngầm để đọc và chuyển đổi HTML của trang web thành định dạng Markdown gọn gàng. | Đọc tài liệu API chính thức, đọc bài viết hướng dẫn trên GitHub/Blog kỹ thuật. |
| **`generate_image`** | Sử dụng mô hình sinh ảnh AI của Google để tạo mới hoặc chỉnh sửa hình ảnh UI mockups, diagrams, và visual assets. | Thiết kế giao diện demo UI/UX, tạo logo/icon placeholder thực tế, trực quan hóa ý tưởng thiết kế. |

---

### 2.5 Giao Tiếp Người Dùng Tương Tác (Interactive UI)

| Tên Tool | Chức Năng Chi Tiết | Trường Hợp Sử Dụng (Use Cases) |
| :--- | :--- | :--- |
| **`ask_question`** | Hiển thị một Modal tương tác trực quan ngay trên giao diện chat của người dùng với các lựa chọn trắc nghiệm (Single/Multi-select) và ô nhập tùy ý. | Xin ý kiến xác nhận của User khi có nhiều phương án kiến trúc, làm rõ yêu cầu mơ hồ trước khi viết code. |

---

## 3. Hệ Thống Model Context Protocol (MCP) & Plugins

Antigravity hỗ trợ chuẩn **Model Context Protocol (MCP)**, tích hợp sẵn 3 plugins mạnh mẽ:

### 3.1 `chrome-devtools-plugin` (Chrome DevTools MCP Server)
Cung cấp khả năng kết nối trực tiếp với trình duyệt Chrome thông qua Chrome DevTools Protocol (CDP):
- **Tự động hóa trình duyệt (Browser Automation)**: Mở tab mới, điều hướng trang web, click phần tử, nhập dữ liệu biểu mẫu, chụp ảnh toàn trang (Full-page screenshot).
- **Phân tích hiệu năng (Core Web Vitals)**: Đo lường và gỡ lỗi các chỉ số **LCP (Largest Contentful Paint)**, **INP (Interaction to Next Paint)**, **CLS (Cumulative Layout Shift)**.
- **Phát hiện rò rỉ bộ nhớ (Memory Leaks)**: Chụp và phân tích Heap Snapshots, tìm kiếm đối tượng JS không được Garbage Collector thu hồi.
- **Kiểm toán tiếp cận (Accessibility - a11y)**: Đo lường độ tương phản màu sắc, cấu trúc cây Accessibility Tree, hỗ trợ ARIA labels.

### 3.2 `modern-web-guidance-plugin`
Plugin cung cấp cơ sở tri thức hiện đại cho lập trình Web Frontend:
- **Chrome Extensions Development (Manifest V3)**: Kiến trúc Content Scripts, Background Service Workers, Action Popups, Side Panels, `declarativeNetRequest`.
- **Modern CSS & JS**: View Transitions API, CSS Anchor Positioning, `:has()` selector, Subgrid, Web Workers, Scroll-driven animations.

### 3.3 `google-antigravity-sdk`
Bộ công cụ SDK cho phép thiết kế, cấu hình và lập trình đa đặc vụ AI Agent tự trị trong hệ sinh thái Antigravity.

---

## 4. Danh Mục Kỹ Năng & Phân Bổ Theo Plugin (Skills & Plugins Mapping)

Các kỹ năng (Skills) được phân bổ theo Plugin gốc và các Kỹ năng quản trị cục bộ trong repository:

### 4.1 Nhóm Skills Cung Cấp Bởi `chrome-devtools-plugin`
Plugin này cung cấp kết nối MCP tới Chrome DevTools và bao gồm 5 skills chuyên sâu:
- **`chrome-devtools-plugin:chrome-devtools`**: Điều khiển trình duyệt, click, nhập liệu, chụp ảnh màn hình và tự động hóa thao tác người dùng.
- **`chrome-devtools-plugin:debug-optimize-lcp`**: Chẩn đoán và tối ưu hóa thời gian tải / hiển thị nội dung chính (Largest Contentful Paint).
- **`chrome-devtools-plugin:memory-leak-debugging`**: Phân tích heap snapshot, tìm và sửa lỗi tràn bộ nhớ / rò rỉ bộ nhớ JS và Node.js.
- **`chrome-devtools-plugin:a11y-debugging`**: Kiểm tra và sửa lỗi chuẩn tiếp cận (Web Accessibility, ARIA labels, contrast ratio).
- **`chrome-devtools-plugin:troubleshooting`**: Khắc phục sự cố kết nối MCP server và target browser khi gặp lỗi.

### 4.2 Nhóm Skills Cung Cấp Bởi `modern-web-guidance-plugin`
- **`modern-web-guidance-plugin:chrome-extensions`**: Hướng dẫn xây dựng và phát hành tiện ích mở rộng Chrome Manifest V3 (Service Workers, Content Scripts, DeclarativeNetRequest).
- **`modern-web-guidance-plugin:modern-web-guidance`**: Tra cứu và áp dụng best practices cho HTML5/CSS hiện đại, View Transitions API, Web APIs.

### 4.3 Nhóm Skills Tích Hợp Sẵn Của Antigravity Core (`builtin`)
- **`builtin:antigravity-guide`**: Cẩm nang tra cứu toàn diện về Antigravity CLI, Antigravity 2.0, slash commands, keybindings, SDK.
- **`builtin:agy-customizations`**: Hướng dẫn tùy biến Rules, Plugins, Hooks, MCP servers và Custom Skills.
- **`google-antigravity-sdk:google-antigravity-sdk`**: Thiết kế, triển khai và điều phối multi-agent systems bằng Antigravity SDK.

### 4.4 Nhóm Skills Quản Trị Quy Trình & Kiến Trúc Dự Án (Repository Local Skills)
Nằm trong thư mục `.agents/skills/`:
- **`utilizing-tools-agy`**: Tự động chọn lọc và triển khai bộ công cụ AGY / MCPs tối ưu cho mọi bài toán kèm bảng khai báo bắt buộc.
- **`goal-griller`**: Phỏng vấn làm rõ mục tiêu (`/goal`) trước khi bắt đầu tự trị.
- **`prompt-leverage`**: Chuẩn hóa prompt thô thành chỉ thị thực thi có bằng chứng kiểm tra.
- **`sequence-execution-plan`**: Xây dựng kế hoạch thực thi phụ thuộc nhiều giai đoạn.
- **`improve-harness`**: Thử nghiệm và nâng cấp các quy tắc của Harness repo (`$improve-harness`).
- **`writing-for-agents`**: Chuẩn mực soạn thảo tài liệu và chỉ dẫn cho AI Agents.
- **`onboarding`**: Khảo sát và phân tách luồng dữ liệu cho dự án brownfield thành từng thư mục độc lập (`docs-harness/onboarding/<flow-name>/`).
- **`onboard-repository`**: Khảo sát mã nguồn dự án lớn và xuất evidence capsule.
- **`audit-onboarding-proposal`**: Độc lập kiểm toán đề xuất onboarding trước khi áp dụng.
- **`xia`**: Nghiên cứu kỹ thuật, tìm kiếm các mẫu thiết kế và tài liệu trước khi code.

---

## 5. Slash Commands & Hệ Thống Tùy Biến (Customizations)

### 5.1 Slash Commands Có Thể Dùng Trong Chat UI
- **`/goal`** hoặc **`/goal-griller`**: Bắt đầu phiên phỏng vấn định hình mục tiêu thực thi tự trị.
- **`/plan`**: Kích hoạt chế độ lập kế hoạch từng bước trước khi viết mã.
- **`/grill-me`**: Phỏng vấn đối đáp 1-1 với AI Agent để làm rõ các quyết định kiến trúc khó.
- **`/learn`**: Ra lệnh cho Agent ghi nhớ bài học / kinh nghiệm sửa lỗi vào bộ nhớ dài hạn.

### 5.2 Khả Năng Mở Rộng Của Antigravity
1. **Rules (`.agentrules` / `AGENTS.md`)**: Thiết lập luật cấm, quy chuẩn code, và hành vi bắt buộc cho Agent.
2. **Custom Skills (`.agents/skills/<skill-name>/SKILL.md`)**: Thêm các kỹ năng tự động hóa chuyên biệt cho dự án.
3. **Custom MCP Servers**: Thêm kết nối tới Database (PostgreSQL, MySQL), Cloud (AWS, GCP), hoặc dịch vụ nội bộ qua giao thức MCP.
4. **Lifecycle Hooks**: Đăng ký các hook can thiệp trước/sau khi gọi tool (`PreToolUse`, `PostToolUse`).
