# Cẩm Nang Toàn Diện Về Tools, CLI, MCP & Skills Của Orca ADE

> **Tài liệu tham khảo kỹ thuật cho nhóm phát triển (Team-Facing Documentation)**  
> *Vị trí lưu trữ*: `docs/tools/orca-ade/README.md`  
> *Mục đích*: Tổng hợp chi tiết toàn bộ các công cụ dòng lệnh (Built-in CLI Commands), hệ thống tự động hóa trình duyệt (Browser Automation), quản lý Git Worktrees, Terminal Multiplexing, cấu hình MCP/Plugins/Hooks và mô hình tích hợp điều phối tác tử với **Herdr** của nền tảng **Orca ADE (Agent Development Environment)**.

---

## 1. Tổng Quan Kiến Trúc Orca ADE

**Orca ADE** (phát triển bởi Stably AI) là một **Agent Development Environment (Môi trường Phát triển dành riêng cho Tác tử AI)** mã nguồn mở (MIT License). Trong khi IDE truyền thống tập trung vào trải nghiệm gõ mã của con người, Orca được thiết kế như một **Trạm chỉ huy (Control Plane)** để vận hành, điều phối và giám sát một "phi đội" các AI coding agents (như Claude Code, Codex, Antigravity `agy`, OpenCode) chạy song song trên cùng một kho lưu trữ mã nguồn.

### 1.1 Sơ Đồ Kiến Trúc Phân Lớp

```text
+-----------------------------------------------------------------------------------+
|                               Orca ADE Control Plane                              |
+-----------------------------------------------------------------------------------+
|  [Git Worktree Layer]  |  [Browser Engine]      |  [Terminal Multiplexer]        |
|  - Isolated checkouts  |  - Chromium host       |  - Split-pane terminals         |
|  - Branch/PR sandboxes |  - Page snapshots (e#) |  - PTY process streaming        |
|  - Hooks & Archive     |  - JS eval & clicks    |  - Prompt delivery & waiting   |
+-----------------------------------------------------------------------------------+
|                        [Agent & Project Management Layer]                         |
|  - Project Setup & Host Provisioning            - Skills & Plugins Engine         |
|  - AI Vault & Local Credential Store            - Issue Tracker (GitHub/Linear)   |
+-----------------------------------------------------------------------------------+
|                 [Multi-Agent Coordination & Herdr Integration]                   |
|  - Dispatch Herdr workers (Codex, OpenCode, AGY) into isolated Orca worktrees     |
|  - Live terminal monitoring without terminal blocking                             |
|  - In-browser visual verification of generated artifacts & web UIs                |
+-----------------------------------------------------------------------------------+
```

---

## 2. Danh Mục Built-in CLI Commands (Công Cụ Cốt Lõi)

Orca cung cấp công cụ dòng lệnh `orca.exe` (trên Windows đặt tại `AppData\Local\Programs\orca\resources\bin\orca.exe`). Mọi thao tác điều khiển môi trường đều có thể thực hiện thông qua CLI kèm cờ `--json` để trả kết quả chuẩn hóa cho AI Agent.

### 2.1 Quản Lý Git Worktree Cách Ly (`orca worktree`)

Orca tự động quản lý các Git worktree giúp mỗi tác vụ của AI agent diễn ra trên một nhánh và thư mục riêng biệt, tránh xung đột branch và không làm bẩn working directory chính.

| Lệnh CLI | Chức Năng Chi Tiết | Trường Hợp Sử Dụng (Use Cases) |
| :--- | :--- | :--- |
| `orca worktree create` | Tạo một worktree độc lập mới từ nhánh base, có thể gắn liền với việc khởi chạy agent hoặc liên kết issue GitHub/Linear (`--name`, `--agent`, `--issue`, `--prompt`). | Tạo workspace độc lập cho worker thử nghiệm giải pháp phức tạp. |
| `orca worktree list` | Liệt kê toàn bộ worktree hiện có trong project kèm trạng thái, đường dẫn và nhánh. | Khảo sát danh sách tác vụ đang chạy dở dang. |
| `orca worktree show` | Xem thông tin chi tiết của một worktree theo selector (`--worktree <selector>`). | Kiểm tra metadata, issue liên kết, commit cha của workspace. |
| `orca worktree current` | Hiển thị worktree hiện tại mà phiên làm việc đang trỏ tới. | Xác định ngữ cảnh thực thi hiện tại của agent. |
| `orca worktree set` | Cập nhật metadata, comment, trạng thái workspace hoặc liên kết Linear/GitHub issue. | Đổi trạng thái nhiệm vụ ("waiting on review", "in progress"). |
| `orca worktree rm` | Xóa worktree an toàn (hỗ trợ cờ `--force`, `--run-hooks`). | Dọn dẹp không gian đĩa sau khi hoàn thành hoặc hủy bỏ tác vụ. |
| `orca worktree ps` | Kiểm tra tiến trình hệ thống và trạng thái hoạt động của các worktree. | Giám sát tài nguyên CPU/Memory tiêu thụ trên từng workspace. |

---

### 2.2 Tự Động Hóa Trình Duyệt (`orca tab` & Browser Automation)

Orca nhúng sẵn một Chromium host hoàn chỉnh, cho phép AI Agent tương tác trực tiếp với giao diện web, ứng dụng nội bộ hoặc các trang SPA:

| Lệnh CLI | Chức Năng Chi Tiết | Trường Hợp Sử Dụng (Use Cases) |
| :--- | :--- | :--- |
| `orca tab create` | Mở một tab trình duyệt mới với URL chỉ định (`--url <url>`) trong profile mong muốn (`--profile <id>`). | Mở trang tài liệu, dashboard quản trị, hoặc preview server cục bộ. |
| `orca tab list` | Liệt kê tất cả các tab trình duyệt đang mở kèm `browserPageId`, URL, tiêu đề và trạng thái tải. | Tìm ID trang để tương tác điều khiển song song. |
| `orca tab show` | Xem chi tiết thông tin và trạng thái mạng của một tab theo `--page <id>`. | Kiểm tra chứng chỉ SSL, trạng thái lỗi tải trang (`loadError`). |
| `orca snapshot` | Chụp cây Accessibility Tree của trang, sinh mã định danh phần tử dạng `@e1`, `@e2`, `@e3`... | Phân tích cấu trúc DOM để xác định nút bấm, trường nhập liệu cần click. |
| `orca click` | Click vào một phần tử cụ thể trên trang thông qua ref (`--element <ref>`). | Bấm nút Submit, chuyển tab, kích hoạt dropdown menu. |
| `orca fill` | Điền giá trị văn bản vào một trường input (`--element <ref> --value <text>`). | Điền form đăng nhập, nhập từ khóa tìm kiếm. |
| `orca keypress` | Gửi sự kiện phím bấm (`Enter`, `Tab`, `Escape`, `Control+a`, ...). | Xác nhận form hoặc kích hoạt phím tắt web. |
| `orca eval` | Thực thi một biểu thức JavaScript trực tiếp trong ngữ cảnh trang (`--expression <js>`). | Đọc thuộc tính DOM ẩn, đổi hash route, trích xuất dữ liệu JSON từ SPA. |
| `orca screenshot` | Chụp ảnh màn hình trang web (`--format png|jpeg`). | Thu thập bằng chứng hình ảnh (visual evidence) cho giao diện người dùng. |
| `orca tab profile ...` | Quản lý các profile phiên duyệt (`list`, `create`, `delete`, `set`, `clone`). | Duy trì phiên đăng nhập lâu dài (`persist:orca-browser`) tách biệt môi trường test. |

---

### 2.3 Quản Lý Terminal & Điều Khiển Đa Tiến Trình (`orca terminal`)

Hệ thống multiplexing terminal của Orca cho phép AI Agent khởi chạy, giám sát và gửi lệnh vào các tiến trình dòng lệnh mà không sợ bị chặn luồng (blocking):

| Lệnh CLI | Chức Năng Chi Tiết | Trường Hợp Sử Dụng (Use Cases) |
| :--- | :--- | :--- |
| `orca terminal create` | Mở một terminal mới trong worktree chỉ định, chạy lệnh khởi tạo (`--command <cmd>`, `--title <name>`, `--shell <shell>`). | Khởi chạy dev server, linter ngầm hoặc một worker agent độc lập. |
| `orca terminal list` | Liệt kê danh sách terminal kèm handle (`term_xxx`), topology tab/pane và worktree sở hữu. | Thu thập handle để gửi input hoặc kiểm tra log. |
| `orca terminal read` | Đọc dữ liệu đầu ra từ buffer terminal (`--cursor <n> --limit <n>`). | Thu thập log đầu ra, kiểm tra lỗi runtime mà không làm gián đoạn tiến trình. |
| `orca terminal send` | Gửi chuỗi văn bản hoặc tín hiệu ngắt vào terminal (`--text <str>`, `--enter`, `--interrupt`). | Tương tác với CLI tương tác (như xác nhận `y/N`, gửi prompt cho agent). |
| `orca terminal wait` | Chờ terminal đạt trạng thái mong muốn (`--for exit` hoặc `--for tui-idle`). | Đồng bộ hóa khi cần đợi một build script chạy xong. |
| `orca terminal split` | Chia đôi màn hình terminal theo chiều ngang (`horizontal`) hoặc dọc (`vertical`). | Sắp xếp giao diện trực quan cho lập trình viên theo dõi song song. |
| `orca terminal close` | Đóng terminal tab hoặc đóng toàn bộ terminal thuộc một worktree. | Giải phóng tài nguyên sau khi xong việc. |

---

### 2.4 Quản Lý Dự Án & Tệp Tin (`orca project`, `orca repo`, `orca file`)

| Lệnh CLI | Chức Năng Chi Tiết | Trường Hợp Sử Dụng (Use Cases) |
| :--- | :--- | :--- |
| `orca repo list/add/show` | Quản lý danh mục Git repository đăng ký trong Orca, cấu hình base ref (`--ref main`). | Khai báo và cấu hình repository làm việc. |
| `orca project ...` | Thiết lập dự án (`setup-existing-folder`, `setup-clone`, `setup-create`, `setups`). | Cấu hình môi trường dev, base path của worktree cho dự án. |
| `orca file open` | Mở tệp tin trong trình soạn thảo Monaco tích hợp của Orca (`orca file open src/App.tsx`). | Điều hướng màn hình xem file cho lập trình viên. |
| `orca file diff` | Mở giao diện xem diff so sánh thay đổi của file so với commit gốc. | Kiểm tra các thay đổi vừa thực hiện trước khi commit. |
| `orca file open-changed` | Mở toàn bộ các file vừa thay đổi ở chế độ `edit`, `diff` hoặc `both`. | Đánh giá tổng thể diff của một đợt refactoring. |

---

## 3. Hệ Thống Model Context Protocol (MCP), Plugins & Hooks

Orca ADE tích hợp sâu với kiến trúc mở rộng hiện đại:
1. **Model Context Protocol (MCP)**:
   - Orca đóng vai trò là MCP Host lẫn MCP Client: có thể expose các năng lực quản lý worktree, terminal, browser cho AI Agent dưới dạng MCP Tools.
   - Quản lý danh sách MCP Server cấu hình trong runtime (`automation.list-host-scope.v1`, `skills.install-providers.v1`).
2. **AI Vault & Quản Lý Định Danh (Credentials)**:
   - Lưu trữ an toàn các token/API keys trên máy cục bộ (`accounts.import-host-credentials.v1`).
   - Hỗ trợ mô hình BYOK (Bring Your Own Key), không chuyển tiếp dữ liệu qua server trung gian.
3. **Worktree Lifecycle Hooks**:
   - Tự động chạy các script khởi tạo (`setup hooks`) khi tạo worktree (ví dụ: `npm install`, cấu hình file `.env`).
   - Chạy các script dọn dẹp hoặc sao lưu (`archive hooks`) khi gỡ bỏ worktree (`orca worktree rm --run-hooks`).

---

## 4. Tích Hợp Điều Phối Tác Tử Với Herdr (Herdr & Orca Integration)

Trong kiến trúc Harness, **Herdr** là cơ chế điều phối worker session của BALE. Khi kết hợp với Orca ADE, sự phối hợp đạt hiệu quả tối ưu:

```text
+---------------------------------------------------------------------------------+
|                       BALE (Herdr Coordinator Session)                         |
+---------------------------------------------------------------------------------+
                                      |
              +-----------------------+-----------------------+
              | Dispatch Task                                 | Dispatch Task
              v                                               v
+-------------------------------+             +-------------------------------+
|  Orca Worktree: worker-1      |             |  Orca Worktree: worker-2      |
|  (Branch: feature/auth-refactor) |             |  (Branch: feature/api-cache)  |
|                               |             |                               |
|  Terminal: OpenCode Go Worker |             |  Terminal: Codex YOLO Worker  |
|  - Process-scoped sandbox     |             |  - Process-scoped sandbox     |
|  - Independent Git commit log |             |  - Independent Git commit log |
+-------------------------------+             +-------------------------------+
              |                                               |
              +-----------------------+-----------------------+
                                      v
+---------------------------------------------------------------------------------+
|                     Visual Review & Validation via Orca                         |
|  - orca file open-changed --mode diff : Review mã nguồn song song 2 worker     |
|  - orca tab create --url http://localhost:3000 : Kiểm thử giao diện web live    |
|  - orca worktree rm : Giải phóng workspace an toàn khi hoàn thành               |
+---------------------------------------------------------------------------------+
```

### Lợi Ích Của Việc Kết Hợp Herdr + Orca ADE:
1. **Cách ly hoàn toàn không gian làm việc (Worktree Isolation)**:
   - Thay vì chạy thẳng trong working tree chính của coordinator, BALE có thể yêu cầu tạo một Orca worktree riêng (`orca worktree create --name herdr-worker-1`). Worker thoải mái thay đổi file mà không làm bẩn repo gốc.
2. **Theo dõi song song không nghẽn lệnh (Terminal Multiplexing)**:
   - Thay vì dùng lệnh nền hệ điều hành phức tạp, BALE có thể mở một pane terminal (`orca terminal create --command "herdr launch ..."`) và theo dõi tiến độ qua `orca terminal read`.
3. **Kiểm toán chất lượng & Trực quan hóa Diff (Visual Review Gate)**:
   - Áp dụng cổng Bale Code Review: Dùng `orca file diff` để kiểm tra trực quan diff của worker trước khi chấp thuận.
   - Dùng `orca snapshot` và `orca eval` để kiểm tra kết quả ứng dụng web mà worker vừa xây dựng.

---

## 5. Quy Chuẩn Sử Dụng Trong Phiên Làm Việc (Best Practices)

- **Ưu tiên `--json`**: Luôn truyền cờ `--json` khi AI Agent thực thi lệnh Orca CLI để nhận kết quả có cấu trúc máy đọc được.
- **Tái sử dụng Page ID**: Với tác vụ web, lấy `browserPageId` từ `orca tab list` hoặc `orca tab create` và truyền cờ `--page <id>` vào các lệnh `snapshot`, `click`, `eval` tiếp theo.
- **Dọn dẹp tài nguyên**: Luôn chủ động đóng tab (`orca tab close`) và xóa worktree tạm (`orca worktree rm --worktree <selector>`) khi tác vụ hoàn thành để tránh lãng phí RAM và ổ cứng.
