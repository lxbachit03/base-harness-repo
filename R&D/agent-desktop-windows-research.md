# Nghiên cứu và thử nghiệm `agent-desktop` trên Windows 11 & Antigravity

- **Công cụ:** `agent-desktop` `v1.3.1` (`vercel-labs/agent-desktop`)
- **Tài liệu tham chiếu:**
  - Tổng quan: <https://agent-browser.dev/desktop>
  - Nền tảng Windows: <https://agent-browser.dev/desktop/platforms/windows>
  - Antigravity Terminal Sandbox: <https://antigravity.google/docs/sandbox.md>
- **Ngày thử nghiệm:** 2026-11-22
- **Môi trường kiểm chứng:** Windows 11 (`NT 10.0.26200.0`), PowerShell `5.1`, Node/npm (`nvm4w`), Antigravity App 2.0

---

## 1. Tổng quan `agent-desktop`

`agent-desktop` là công cụ companion của `agent-browser`, giúp AI agent quan sát và thao tác trực tiếp trên **ứng dụng desktop gốc** thông qua **accessibility tree của hệ điều hành** (Windows UI Automation / UIA, macOS AX API, Linux AT-SPI) thay vì dựa vào chụp ảnh màn hình và tọa độ pixel.

- **Phân biệt với `agent-browser`:** `agent-browser` phục vụ trình duyệt/web; `agent-desktop` phục vụ ứng dụng desktop gốc (Win32, UWP/WinUI, WPF, Electron, shell surfaces như Taskbar, Start Menu, Action Center).
- **Vòng lặp vận hành (`observe → act → verify`):**
  1. `snapshot` đọc UIA tree và cấp ref gắn kèm snapshot ID dạng `@<snapshot_id>:eN` (ref trần `@eN` bị từ chối; khi UI đổi, `STALE_REF` hoặc `AMBIGUOUS_TARGET` yêu cầu chụp snapshot mới thay vì đoán).
  2. Thực thi hành động qua ref (`click`, `set-value`, `type`, `select`, `toggle`, `expand`, `scroll`, v.v.).
  3. Đọc lại (`snapshot`, `get`, hoặc `wait`) để xác nhận trạng thái sau thao tác.
- **Định dạng phản hồi chuẩn:** Mọi lệnh trả về JSON envelope gồm `version`, `ok`, `command`, `data`/`error`, kèm `disposition.delivery` (`delivered_verified`, `delivered_unverified`, `not_delivered`) và `disposition.retry` (`safe`, `unsafe`).
- **Ba tầng tích hợp:**
  - **CLI:** Binary Rust biên dịch sẵn, tích hợp tài liệu skill đúng theo phiên bản binary (`agent-desktop skills get desktop`, `agent-desktop skills get platform`).
  - **MCP Server:** `agent-desktop mcp` cung cấp toàn bộ 75 lệnh dưới dạng MCP tools qua `stdio`.
  - **C FFI Library:** Nhúng trực tiếp vào framework tùy biến.

---

## 2. Đặc thù nền tảng Windows

Từ tài liệu Windows chính thức và tài liệu tích hợp trong binary (`agent-desktop skills get agent-desktop-windows`):

- **Yêu cầu hệ điều hành & phiên:** Windows 10 (1809+) hoặc Windows Server 2019+ (x64/ARM64), chạy qua UI Automation (UIA). **Bắt buộc chạy trong interactive desktop session (`WinSta0\Default`) của user đang đăng nhập**; không hỗ trợ Session 0 (service/SYSTEM), Server Core, secure desktop (UAC/màn hình khóa), hoặc desktop cô lập.
- **Quyền & UIPI (Elevation):** Windows không có hộp thoại cấp quyền Accessibility (`permissions` trả `accessibility: granted`, `automation: not_required`). Kiểm soát truy cập nằm ở **integrity level (UIPI)**: terminal mức `Medium` đọc được app Administrator nhưng bị chặn thao tác (`PERM_DENIED` / `E_ACCESSDENIED`). Phiên thường và phiên elevated không được dùng chung `state_root` — phiên elevated cần tách biến môi trường `AGENT_DESKTOP_HOME`.
- **Chế độ strict headless mặc định vs `--headed`:**
  - Mặc định mọi thao tác ref chạy **semantic UIA headless** (không cướp focus hay di chuyển chuột thật; vẫn điều khiển được cửa sổ nằm phía sau, **trừ cửa sổ đang bị minimize** vì mọi phần tử thành `offscreen` → cần `restore` trước).
  - Các lệnh cần input vật lý hoặc chiếm focus (`type`, `right-click`, `double-click`, `triple-click`, `focus`, `hover`, `drag`, `mouse-*`, `open-system-surface`, `list-notifications` khi Action Center đang đóng) **bắt buộc bật `--headed`**, nếu không sẽ từ chối với `POLICY_DENIED`.
- **9 surface hỗ trợ trên Windows:** `window`, `focused`, `sheet`, `menu`, `start-menu`, `taskbar`, `system-tray`, `system-tray-overflow`, `action-center` (không có `menubar`; `quick-settings` trả `INVALID_ARGS` và trỏ sang `action-center`).
- **Các lưu ý thực hành quan trọng:**
  - **PowerShell ref quoting:** Bắt buộc bọc nháy đơn `'@<snapshot_id>:eN'` vì `@token` trần là toán tử splatting của PowerShell.
  - **`launch`:** Chỉ nhận đường dẫn tuyệt đối hoặc tên `.exe` trong `System32`/Windows (như `notepad`, `calc`), không nhận display name (như `Calculator`).
  - **Phím tắt bị chặn mặc định** (nếu không truyền `--force`): `alt+f4`, `win+l`, `win+d`, `alt+tab`, `win+r`, `win+x`, `win+e`, `ctrl+shift+esc`; `cmd`/`meta` trên Windows ánh xạ sang phím `Windows` (dùng `ctrl+c`, không dùng `cmd+c`).
  - **App Chromium/Electron:** Cây UIA lần đầu có thể mỏng nếu renderer chưa settle → tăng `--timeout-ms` (ví dụ `30000`).
  - **Binary chưa ký số & sandbox:** Gói npm kèm sẵn binary nên không dính Mark-of-the-Web (không hiện prompt SmartScreen như file tải qua trình duyệt), nhưng vẫn có thể bị antivirus hoặc Smart App Control (Windows 11 cài sạch) chặn. Tính năng `agent-desktop sandbox` chưa hỗ trợ trên Windows.

---

## 3. Thiết lập trên Windows & chẩn đoán với Antigravity

### 3.1 Cài đặt CLI global & chẩn đoán cơ bản
- Cài đặt: `npm install -g agent-desktop` (`v1.3.1`).
  - Ghi nhận cảnh báo `npm warn allow-scripts`: npm bỏ qua `scripts/postinstall.js`, nhưng gói npm đã đóng gói sẵn `agent-desktop-win32-x64.exe` nên CLI chạy ngay qua `agent-desktop.ps1`; `postinstall.js` chủ yếu dùng cho bước `linkBinEntry` tối ưu bỏ Node wrapper và in hướng dẫn cài skill.
- Kiểm tra:
  - `agent-desktop --version` → `agent-desktop 1.3.1`
  - `agent-desktop status` → `ok: true`, `platform: "windows"`, `accessibility: "granted"`, `automation: "not_required"`, `screen_recording: "not_required"`, đủ 9 `supported_surfaces`.
  - `agent-desktop permissions` → `ok: true`, khớp trạng thái trên.
  - `agent-desktop list-displays` → `ok: true`, nhận diện đủ 3 màn hình (`2560x1440`, `2560x1440`, `1080x1920`).

### 3.2 Điểm nghẽn `WinSta0\exebox-*` khi gọi CLI từ shell của Antigravity
- Khi chạy từ `run_command` (và terminal tích hợp thừa hưởng cùng môi trường) trong Antigravity trên Windows:
  - `agent-desktop list-windows`, `list-apps`, `launch calc --activate` đều trả `INTERNAL: EnumWindows failed to enumerate top-level windows`.
  - `agent-desktop snapshot --surface taskbar` trả `WINDOW_NOT_FOUND: The 'taskbar' shell surface is not open on this desktop`.
- **Chẩn đoán Win32:** Tiến trình shell trong Antigravity chạy tại `SessionId=1`, `Medium Mandatory Level`, `WindowStation=WinSta0`, nhưng gắn vào **Desktop cô lập `exebox-*`** (với `EnumWindowsOk=False`, `Count=0`, `LastError=203`) thay vì `WinSta0\Default`. Hiện tượng này vẫn giữ nguyên ngay cả khi thêm allow-rule `command(agent-desktop *)` hoặc chuyển cuộc hội thoại sang preset `Request Review`.
- **Đối chứng trên Windows Terminal độc lập (`Win + R` → `wt` trên `WinSta0\Default`):**
  - `agent-desktop list-windows` → `ok: true`, liệt kê chính xác 7 cửa sổ đang mở (gồm UWP `CalculatorApp.exe`).
  - `agent-desktop snapshot --surface taskbar` → `ok: true`, `complete: true`, trả về `19` refs.

### 3.3 Giải pháp kết nối Antigravity qua MCP Server
Cấu hình MCP server toàn cục tại `C:\Users\<USER>\.gemini\config\mcp_config.json`, trỏ trực tiếp tới native binary Windows thay vì wrapper PowerShell:

```json
{
  "mcpServers": {
    "agent-desktop": {
      "command": "C:\\nvm4w\\nodejs\\node_modules\\agent-desktop\\bin\\agent-desktop-win32-x64.exe",
      "args": ["mcp", "--headed"]
    }
  }
}
```

- **Lý do truyền `--headed` ở `args`:** Các MCP tool (`desktop_type`, `desktop_right_click`, `desktop_open_system_surface`, ...) dùng schema `additionalProperties: false` và không có cờ `headed` riêng từng lệnh; chế độ `--headed` được áp dụng ở cấp tiến trình `mcp`.
- **Lưu ý nạp cấu hình:** Antigravity App 2.0 hiển thị MCP server trong sidebar **Customizations → MCP Servers** (`75 tools enabled`) và không có nút Reload riêng; khi thay đổi `args` trong `mcp_config.json` cần khởi động lại Antigravity để tiến trình MCP respawn với tham số mới.
- **Kết quả:** Tiến trình MCP chạy trực tiếp trên `WinSta0\Default`, vượt qua hoàn toàn ranh giới `exebox-*` của `run_command` mà không cần tắt sandbox của terminal.

---

## 4. Kết quả thử nghiệm thực tế qua MCP

### 4.1 Chế độ strict headless (`args: ["mcp"]`)
- **Chính sách chặn:** `desktop_open_system_surface` (`surface: "start-menu"`) bị từ chối với `POLICY_DENIED` trước khi chạm vào desktop, đúng thiết kế strict headless.
- **Đọc cửa sổ & Taskbar:** `desktop_list_windows` trả `ok: true` (`7` cửa sổ); `desktop_snapshot` (`surface: "taskbar"`) trả `ok: true`, `complete: true`, `20` refs (`explorer.exe`).
- **Vòng lặp `observe → act → verify → close` trên `CalculatorApp.exe`:**
  - `desktop_snapshot` ban đầu: `"Display is 0"`.
  - Gọi `desktop_click` tuần tự các nút `7`, `+`, `5`, `=` qua `InvokePattern.Invoke` (`semantic_api`, hoàn toàn không cướp focus cửa sổ) → đều `ok: true`.
  - `desktop_snapshot` xác minh sau thao tác: `"Display is 12"`.
  - **Lưu ý đóng app UWP:** `desktop_close_app` với `"CalculatorApp.exe"` báo `APP_NOT_FOUND` vì `desktop_list_apps` quản lý tiến trình khung là `ApplicationFrameHost.exe`. Đóng an toàn riêng cửa sổ bằng `desktop_click` lên nút `"Close Calculator"`, kiểm tra lại `desktop_list_windows` (`app: "CalculatorApp.exe"`) trả `[]`.

### 4.2 Chế độ `--headed` (`args: ["mcp", "--headed"]`)
- **`open-system-surface` & phím vật lý:** `desktop_open_system_surface` (`surface: "start-menu"`) mở `StartMenuExperienceHost.exe` (`ok: true`); `desktop_snapshot` (`surface: "start-menu"`) thu được `114` refs; `desktop_press` (`combo: "escape"`) đóng menu thành công (`SendInput.press_key`, `physical_synthetic`).
- **Mở app & `right-click` trên Win11 Notepad (`Notepad.exe`):**
  - `desktop_launch` (`app: "notepad"`, `activate: true`) → `ok: true`. Mở thêm tab mới `"Untitled. Unmodified."` để cô lập môi trường test.
  - `desktop_right_click` lên `Text editor` → `ok: true` (`SendInput.click`, `physical_synthetic`).
  - `desktop_list_surfaces` phát hiện thêm `"PopupHost"`; gọi `desktop_snapshot` với `surface: "menu"` trả `WINDOW_NOT_FOUND` (đặc thù WinUI3/MSIX đã được tài liệu cảnh báo), nhưng gọi `desktop_snapshot` trực tiếp theo `window_id` của cửa sổ Notepad đọc được đầy đủ context menu (`Cut`, `Copy`, `Paste`, `Select all`, `Delete`, `Undo`, `Write`, `Rewrite`, ... — `44` refs). Đóng menu bằng `desktop_press` (`escape`).
- **So sánh các phương pháp nhập liệu trên Windows 11 Notepad (chuỗi mẫu `"agent-desktop headed test 123"`):**

| Phương pháp | Cơ chế | Kết quả đọc lại (`desktop_get` `value`) | `disposition.delivery` | Đánh giá |
| :--- | :--- | :--- | :--- | :--- |
| `desktop_type` *(mặc định, không `interval_ms`)* | `SendInput.type_text` (`physical_synthetic`) | `"agent-desktop 333333333333333"` | `delivered_unverified` (`postcondition_mismatch`) | Lỗi lặp ký tự cuối ở nửa sau chuỗi |
| `desktop_set_value` | `ValuePattern.SetValue` (`semantic_api`) | `"agent-desktop headed test 123"` | `delivered_verified` (`steps[0].verified: true`) | Nhanh nhất, chính xác tuyệt đối, không lệ thuộc IME/tốc độ gõ |
| `desktop_type` (`interval_ms: 20`) | `SendInput.type_text` (`physical_synthetic`, `29` keystrokes) | `"agent-desktop headed test 123"` | `delivered_verified` | Khắc phục hoàn toàn lỗi lặp ký tự khi cần gõ phím vật lý |

- **Dọn dẹp:** Xóa sạch nội dung tab test (`ctrl+a` → `delete`), đóng riêng tab `"Untitled"`, rồi đóng `Notepad.exe` bằng `desktop_close_app` (`method: "graceful"`, `delivered_verified`, `process_instance_exited`); `desktop_list_windows` (`app: "Notepad.exe"`) xác nhận `[]`.

---

## 5. Rủi ro, hạn chế và đề xuất vận hành

1. **Rủi ro hỏng chuỗi khi dùng `desktop_type` mặc định trên Windows 11 Notepad:**
   - **Hiện tượng:** `desktop_type` không có `interval_ms` có thể biến nửa sau chuỗi thành ký tự lặp mà vẫn trả `ok: true` (kèm `postcondition_mismatch`).
   - **Đề xuất:** Áp dụng thứ tự ưu tiên: **(1)** dùng `desktop_set_value` khi phần tử có `SetValue`, **(2)** dùng `desktop_type` kèm `interval_ms: 20` và luôn kiểm tra `post_state` hoặc `desktop_get` sau khi nhập.
2. **Menu ngữ cảnh WinUI3/MSIX không tách được qua `surface: "menu"`:**
   - **Hiện tượng:** `desktop_snapshot` với `surface: "menu"` trả `WINDOW_NOT_FOUND` dù `PopupHost` đang mở.
   - **Đề xuất:** Với app WinUI3/MSIX, sau `right-click` hãy chụp `desktop_snapshot` trực tiếp theo `window_id` của cửa sổ sở hữu.
3. **Đóng app UWP qua `desktop_close_app`:**
   - **Hiện tượng:** `CalculatorApp.exe` không khớp `desktop_close_app` vì tiến trình vỏ là `ApplicationFrameHost.exe`.
   - **Đề xuất:** Đóng từng cửa sổ UWP bằng `desktop_click` vào nút `Close` trên title bar thay vì tắt `ApplicationFrameHost.exe`.
4. **Quyền rộng của cấu hình MCP `--headed` toàn cục:**
   - **Hiện tượng:** `mcp_config.json` toàn cục cấp cho mọi phiên Antigravity quyền đọc toàn bộ cửa sổ và gửi chuột/phím vật lý lên desktop thật.
   - **Đề xuất:** Tắt/gỡ MCP server khỏi `mcp_config.json` hoặc chuyển về `["mcp"]` (strict headless) khi không sử dụng tác vụ desktop, và tránh thao tác bàn phím/chuột song song trong khi agent đang chạy lệnh `--headed`.
5. **Lệch quyền UIPI & binary chưa ký số:**
   - **Hiện tượng:** Chạy terminal Administrator lẫn với terminal thường trên cùng `state_root` mặc định dễ gây xung đột quyền sở hữu file nội bộ; app elevated chặn input từ tiến trình Medium (`E_ACCESSDENIED`).
   - **Đề xuất:** Tách `$env:AGENT_DESKTOP_HOME` riêng cho phiên Administrator, và đối chiếu SHA-256 từ release chính thức của `vercel-labs/agent-desktop` nếu antivirus gắn cờ binary chưa ký số.

---

## 6. Các phần chưa kiểm thử (Unattempted Proof)

- Phương án nhập liệu qua clipboard (`clipboard-set` + `press` `ctrl+v`) — cố ý bỏ qua để không ghi đè dữ liệu clipboard hiện có.
- Các thao tác chuột theo tọa độ hoặc nhiều lần nhấp trong `--headed` (`double-click`, `triple-click`, `hover`, `drag`, `mouse-move`, `mouse-click`, `mouse-wheel`).
- Điều khiển ứng dụng chạy quyền Administrator (UIPI / `AGENT_DESKTOP_HOME`).
- Ứng dụng Chromium/Electron thật (`--timeout-ms` settle) và tích hợp qua thư viện C FFI.
