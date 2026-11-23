# Cẩm Nang Tools, MCP, Plugins, Skills & Agents Của Claude Code

> **Tài liệu tham khảo kỹ thuật cho nhóm phát triển (Team-Facing Documentation)**
> *Vị trí lưu trữ*: `docs/tools/claude/README.md`
> *Phạm vi*: capability surface của Claude Code, đối chiếu runtime cục bộ
> `2.1.330` (bản app Claude Desktop) và `2.1.304` (CLI ở PATH) với bằng chứng
> ngày 2026-11-23 (các bảng cũ hơn ghi rõ ngày); mục 14 phân loại độ tin cậy của
> từng nhóm claim.
> *Bản thiết kế*: [Cẩm nang Claude Code trên claude.ai](https://claude.ai/artifact/UKqfEULkmr5YGwfQuAKg5x) (mở được khi chủ sở hữu đã chia sẻ artifact).

Tài liệu này là bản tương ứng cho Claude Code của [cẩm nang OpenCode](../opencode/README.md),
[cẩm nang Codex](../codex/README.md), [cẩm nang Antigravity](../antigravity/README.md)
và [cẩm nang Orca ADE](../orca-ade/README.md).
Nó giúp team chọn đúng built-in tool, deferred tool, MCP connector, plugin,
skill và subagent cho từng loại công việc.

> [!IMPORTANT]
> Runtime/session hiện tại là source of truth. Danh sách tool, MCP, plugin,
> skill, agent và trạng thái kết nối thay đổi theo phiên, theo bản phát hành,
> theo account và theo bộ plugin đã cài. Một capability được tài liệu mô tả
> hoặc có mặt trong marketplace **không** chứng minh rằng nó đã được cài, kết
> nối, xác thực hoặc được phép dùng trong phiên của bạn.

> [!NOTE]
> Máy tham chiếu có **hai binary `claude`** cho kết quả khác nhau: bản app
> (`%LOCALAPPDATA%\Claude-Data\claude_*\claude-code\<version>\*\claude.exe`,
> `2.1.330`, chạy phiên Claude Desktop) và bản ở PATH (`~/.local/bin/claude.exe`,
> `2.1.304`). `claude --version` trả về bản ở PATH, có thể khác bản host đang chạy
> phiên của bạn; chạy `Get-Process claude | Select-Object Path` (PowerShell) và
> tìm dòng có `claude-code\<version>` để biết bản host. Host tự cập nhật: từ
> 2026-11-15 đến 2026-11-23 nó đi từ `2.1.325` qua `2.1.328` lên `2.1.330`, nên
> thư mục `claude-code\` có thể giữ nhiều bản. Mỗi bằng chứng bên dưới ghi rõ
> binary hoặc host đã đo. Ngày 2026-11-23, npm `latest` và `next` là `2.1.330`,
> `stable` là `2.1.323`.

---

## 1. Tổng Quan Kiến Trúc Claude Code

Claude Code phân tầng capability thành sáu lớp:

- **Built-in tools**: hàm native nạp sẵn ngay đầu session.
- **Deferred tools**: hàm native bị giữ lại để tiết kiệm context; chỉ có tên,
  phải nạp schema qua `ToolSearch` mới gọi được.
- **MCP servers/connectors**: dịch vụ ngoài expose tool dưới tiền tố
  `mcp__<server>__<tool>`.
- **Plugins**: gói phân phối qua marketplace, đóng gói skills + MCP servers +
  commands dưới namespace riêng.
- **Skills**: quy trình `SKILL.md` nạp theo nhu cầu qua tool `Skill`.
- **Subagents**: phiên agent cô lập, gọi qua tool `Agent`.

```text
+-----------------------------------------------------------------------------------+
|                              Claude Code Runtime                                  |
+-----------------------------------------------------------------------------------+
| Built-in tools     | Deferred tools     | MCP / Connectors  | Plugins & Skills    |
| - Read/Write/Edit  | - WebSearch        | - mcp__srv__tool  | - marketplace       |
| - Bash/PowerShell  | - Monitor/Cron*    | - .mcp.json       | - <plugin>:<skill>  |
| - Grep/Glob        | - Plan/Worktree    | - account OAuth   | - .claude/skills/   |
| - Skill/ToolSearch | - NotebookEdit     | - plugin .mcp.json| - .agents/skills/   |
| - Agent/Workflow   | - SendMessage      |                   |                     |
| - Artifact         | - TaskStop         | Subagents: claude / Explore / web-fetch |
+-----------------------------------------------------------------------------------+
```

### 1.1 Quy tắc phân biệt các lớp

| Khái niệm | Vai trò | Cách xác nhận |
| :--- | :--- | :--- |
| **Built-in tool** | Hàm native có schema ngay từ đầu phiên. | Schema xuất hiện trong danh sách tool đầu session. |
| **Deferred tool** | Hàm native chỉ được nêu tên trong `<system-reminder>`. | Sau `ToolSearch`, schema trả về trong khối `<functions>`. |
| **MCP server** | Tiến trình/dịch vụ cung cấp nhóm tool `mcp__<server>__*`. | Tool gọi được **và** account đã xác thực. |
| **Plugin** | Bundle skills + MCP + commands cài từ marketplace. | Skill/tool mang namespace của plugin xuất hiện trong phiên. |
| **Skill** | Quy trình `SKILL.md` nạp theo trigger hoặc do User gọi tên. | Có trong danh sách available-skills, hoặc User gõ `/<tên>`. |
| **Subagent** | Phiên agent cô lập với context riêng. | `subagent_type` nằm trong danh sách agent của phiên. |
| **Rule/instruction** | `AGENTS.md`, `CLAUDE.md`, memory, system-reminder. | Nội dung xuất hiện trong context của phiên. |

---

## 2. Built-in Tools (nạp sẵn)

Danh sách tool nạp sẵn **phụ thuộc host** (CLI hay Claude Desktop) và bản phát
hành. Ba phiên tham chiếu: CLI `2.1.278` (2026-09-21) nạp sẵn 18 tool; Claude
Desktop tab Code host `2.1.325` (2026-11-15) nạp sẵn 19 tool; Claude Desktop tab
Code host `2.1.330` (2026-11-23) nạp sẵn 21 tool, tức bộ của 2026-11-15 cộng
`Workflow` và `ShareOnboardingGuide`. `SendFeedback` vẫn chỉ thấy ở phiên CLI;
`SendUserFile`, `SearchPlugins`, `SuggestPluginInstall` và `SuggestSkills` chỉ
thấy ở phiên Desktop (mục 2.4 và 2.5). Bảng tool chính thức (đọc 2026-11-23, số
bản cao nhất nêu trong bảng là `2.1.327`) có 53 dòng: 52 tool đang dùng và
`TaskOutput` đã gỡ từ `2.1.277`, nên output file của task nền được đọc bằng
`Read`.

### 2.1 Filesystem và code

| Tên tool | Chức năng | Use cases |
| :--- | :--- | :--- |
| **`Read`** | Đọc file theo `offset`/`limit`; đọc được ảnh, PDF (`pages`), notebook. | Khảo sát file đã biết đường dẫn; chỉ đọc phần cần thiết với file lớn. |
| **`Write`** | Tạo file mới hoặc ghi đè toàn bộ. | File mới; ghi đè yêu cầu đã `Read` trước đó. |
| **`Edit`** | Thay thế chuỗi chính xác, có `replace_all`. | Cách sửa file chính; bắt buộc `Read` file trong phiên trước khi sửa. |
| **`Glob`** | Tìm file theo glob pattern, sort theo thời gian sửa. | Khám phá layout, tìm file theo tên/đuôi trước khi đọc sâu. |
| **`Grep`** | Tìm nội dung bằng ripgrep; `output_mode`, `-A/-B/-C`, `multiline`, `type`. | Tìm định nghĩa, import, chuỗi cấu hình toàn repo. |

Ghi chú: `Grep` là ripgrep chứ không phải grep — phải escape literal brace
(`interface\{\}`). Ưu tiên `Grep`/`Glob` hơn `grep`/`find` qua shell để kết quả
tích hợp với permission UI và file link. Theo tài liệu chính thức (đọc lại 2026-11-23),
`Glob` và `Grep` mặc định **không có** trên macOS, Linux và WSL (máy tham chiếu
là Windows nên có sẵn); khi vắng, tìm bằng `Bash`.

### 2.2 Shell và thực thi

| Tên tool | Chức năng | Use cases |
| :--- | :--- | :--- |
| **`Bash`** | Chạy Git Bash (POSIX sh) trên Windows. | Script POSIX, git, pipeline `grep`/`sed`/heredoc. |
| **`PowerShell`** | Chạy Windows PowerShell 5.1. | Cmdlet Windows, registry, `icacls`, tác vụ native Windows. |

Hai tool là **hai runtime khác nhau**, cú pháp không dùng lẫn được:

| Nhu cầu | `Bash` | `PowerShell` 5.1 |
| :--- | :--- | :--- |
| Chuỗi lệnh có điều kiện | `A && B` | `A; if ($?) { B }` — `&&`/`\|\|` gây parser error |
| Biến môi trường | `$VAR`, `VAR=x cmd` | `$env:VAR`, `$env:VAR='x'; cmd` |
| Null device | `/dev/null` | `2>$null` |
| Ternary / null-coalescing | n/a | **không có** trong 5.1 |
| Chuỗi nhiều dòng | heredoc | here-string `@'...'@`, `'@` phải ở cột 0 |

Cả hai hỗ trợ `run_in_background` (chạy detached, tự thông báo khi xong) và
`timeout` tối đa 600000 ms. Lệnh interactive (`git rebase -i`, `Read-Host`,
`Get-Credential`) không dùng được: stdin nối null device.

### 2.3 Điều phối, quy trình và tương tác

| Tên tool | Chức năng | Use cases |
| :--- | :--- | :--- |
| **`Skill`** | Nạp nội dung `SKILL.md` vào lượt hiện tại. | Kích hoạt quy trình chuyên biệt của repo hoặc built-in. |
| **`ToolSearch`** | Nạp schema của deferred tool. | Bắt buộc trước khi gọi bất kỳ deferred tool nào. |
| **`Agent`** | Khởi chạy subagent cô lập. | Ủy thác khảo sát độc lập; `subagent_type: "fork"` kế thừa context. |
| **`ListAgents`** | Liệt kê agent/phiên có thể gửi message (chỉ khi bật cross-session messaging); là nguồn của `/list-agents`. | Tìm địa chỉ trước khi dùng `SendMessage`. |
| **`Workflow`** | Chạy script điều phối nhiều subagent (thấy ở phiên CLI `2.1.278` và phiên Desktop `2.1.330`). | Chỉ khi User opt-in rõ ràng vào multi-agent orchestration. |
| **`AskUserQuestion`** | Hỏi User bằng lựa chọn có cấu trúc, hỗ trợ `preview`. | Quyết định thuộc về User, không suy ra được từ code. |
| **`ScheduleWakeup`** | Hẹn lượt tiếp theo trong `/loop` dynamic mode. | Tự điều nhịp vòng lặp; `delaySeconds` bị kẹp `[60, 3600]`. |

### 2.4 Xuất bản và phản hồi

| Tên tool | Chức năng | Use cases |
| :--- | :--- | :--- |
| **`Artifact`** | Publish/read/list/delete trang HTML host trên claude.ai. | Dashboard, deck, tài liệu chia sẻ; xem mục 6. |
| **`ReportFindings`** | Trả kết quả code review dạng danh sách có kiểu. | Chỉ khi hướng dẫn review đang chạy yêu cầu. |
| **`SendUserFile`** | Gửi file từ phiên tới thiết bị của User (`display`: `render` hoặc `attach`); chỉ thấy ở phiên Desktop. Tài liệu: cần client Remote Control đã kết nối hoặc phiên cloud. | Báo cáo, ảnh chụp, artifact mà User cần mở ngay. |
| **`SendFeedback`** | Soạn feedback về Claude Code (queue cục bộ); chỉ thấy ở phiên CLI. | Lỗi tái lập được hoặc sai hành vi model; không tự gửi. |
| **`ShareOnboardingGuide`** | Upload `ONBOARDING.md` và trả link chia sẻ; được gọi từ `/team-onboarding`, gói Team và Enterprise (tài liệu). Thấy ở phiên CLI `2.1.278` và phiên Desktop `2.1.330`. | Sau khi User duyệt nội dung cuối. |

### 2.5 Tool có điều kiện hoặc riêng host

Các tool dưới đây nằm trong tài liệu chính thức hoặc trong một phiên Desktop
tham chiếu, nhưng không thuộc bộ nạp sẵn của các phiên đó:

| Tool | Điều kiện | Chức năng |
| :--- | :--- | :--- |
| `WebFetch` | [DOCS] Vẫn có trong bảng tool, cần permission (`WebFetch(domain:...)`). Tắt bằng `CLAUDE_CODE_DISABLE_WEB_FETCH` (`2.1.285`); phiên Team và Enterprise giữ lại tới khi policy của tổ chức nạp xong. [SESSION] Hội thoại chính của phiên Desktop `2.1.330` (2026-11-23) **không có** `WebFetch`, kể cả trong danh sách deferred, và đọc URL qua subagent `web-fetch` (mục 8); subagent `general-purpose` của cùng phiên vẫn có `WebFetch` ở dạng deferred. | Lấy nội dung một URL đã biết; từ chối URL dài quá 2.000 ký tự (`2.1.327`); trang dài hơn 100.000 ký tự đọc tiếp bằng `offset` (`2.1.290`). |
| `EndConversation` | [DOCS] Trường hợp lạm dụng hiếm, hoặc khi được yêu cầu; thấy ở phiên CLI `2.1.278` | Kết thúc phiên. |
| `propose_skills` | [DOCS] Một số phiên cloud, như Cowork | Hiện skill đề xuất lưu lên claude.ai. |
| `TaskCreate`, `TaskGet`, `TaskList`, `TaskUpdate` | [DOCS] Mặc định chỉ trên một số model; model khác phải opt-in | Quản lý task list của phiên; thay `TodoWrite`. |
| `TodoWrite` | [DOCS] Tắt mặc định khi có bộ `Task*`; `CLAUDE_CODE_ENABLE_TASKS=0` bật lại | Checklist task kiểu cũ. |
| `LSP` | [DOCS] Cần language server | Nhảy tới định nghĩa, tìm reference, báo lỗi type và cảnh báo. |
| `WaitForMcpServers` | [DOCS] Chỉ khi tool search tắt | Chờ MCP server còn đang kết nối. |
| `SubagentHandback` | [DOCS] Chỉ ở auto mode, cho subagent chạy local không phải fork (`2.1.271` trở lên) | Trả báo cáo cuối của subagent cho phiên nhận kết quả. |
| `SearchPlugins`, `SuggestPluginInstall`, `SuggestSkills` | [SESSION] Nạp sẵn ở phiên Desktop; [DOCS] chỉ ở phiên cloud hoặc app Desktop, không có trên nhà cung cấp bên thứ ba | Tìm plugin trong catalog claude.ai của User; hiện thẻ gợi ý cài plugin hoặc skill. |
| `ReadNotifications` | [SESSION] Quan sát ở phiên Desktop, khi có thông báo xếp hàng | Đọc thông báo đã xếp hàng: hoạt động PR đang theo dõi, trigger lịch, tin từ phiên khác. |

---

## 3. Deferred Tools & `ToolSearch`

Đây là cơ chế **đặc thù của Claude Code** và là nguồn lỗi phổ biến nhất.

Deferred tool chỉ được nêu **tên** trong `<system-reminder>`; schema chưa nạp
nên gọi thẳng sẽ fail với `InputValidationError`. Phải nạp trước:

```text
ToolSearch(query: "select:WebSearch,Monitor", max_results: 5)    # chọn đích danh
ToolSearch(query: "notebook jupyter", max_results: 5)            # tìm theo keyword
ToolSearch(query: "+slack send", max_results: 5)                 # bắt buộc chứa "slack"
```

Schema trả về nằm trong khối `<functions>`; sau đó tool gọi được như tool
thường. Danh sách deferred trong phiên Desktop `2.1.330` (2026-11-23), 21 tool
không kể tool MCP:

| Nhóm | Tool | Chức năng |
| :--- | :--- | :--- |
| Web | `WebSearch` | Tìm kiếm web real-time. URL đã biết đọc qua subagent `web-fetch` (mục 2.5 và 8). |
| Kế hoạch | `EnterPlanMode`, `ExitPlanMode` | Vào chế độ lập kế hoạch; trình plan xin duyệt. |
| Git isolation | `EnterWorktree`, `ExitWorktree` | Làm việc trên worktree tách biệt; chỉ khi User yêu cầu rõ, không dùng để điều phối agent. |
| Theo dõi | `Monitor`, `TaskStop` | Chờ điều kiện; dừng task nền. |
| Lịch | `CronCreate`, `CronList`, `CronDelete` | Agent chạy theo cron. |
| Liên lạc | `SendMessage`, `PushNotification`, `RemoteTrigger` | Gửi tin cho agent/phiên khác; thông báo đẩy. |
| Artifact | `ArtifactComments`, `ArtifactData` | Comment thread; database chia sẻ của artifact. |
| Tài khoản claude.ai | `ListPlugins`, `ListSkills`, `SearchSkills` | Liệt kê plugin, skill đang bật trên tài khoản; tìm skill theo từ khóa. |
| Xuất bản plugin | `PublishPlugin` | Đưa một plugin hoặc mod lên thư viện của tổ chức trên claude.ai; hỏi User và liệt kê file trước khi gửi, ở mọi permission mode. Chưa có trong bảng tool công khai. |
| Khác | `NotebookEdit`, `DesignSync` | Sửa cell notebook; đồng bộ design. |

> [!NOTE]
> So với phiên Desktop `2.1.325` (2026-11-15), hội thoại chính của phiên `2.1.330`
> thêm `PublishPlugin` và không còn `WebFetch` (subagent vẫn có), `ListMcpResourcesTool`, `ReadMcpResourceTool`,
> `ReadMcpResourceDirTool`, `FetchInboxMessage`, `SendToProject`,
> `SendToProjectContext`. Tài liệu vẫn liệt kê hai tool đọc resource MCP; chúng chỉ
> xuất hiện khi có server expose resource, nên vắng chúng chưa chắc là đã gỡ. Phiên
> CLI `2.1.278` (2026-09-21) còn liệt kê `EndConversation` (mục 2.5).

---

## 4. MCP Servers & Connectors

### 4.1 Ba nguồn MCP

| Nguồn | Khai báo tại | Ghi chú |
| :--- | :--- | :--- |
| Project | `.mcp.json` trong repo | Theo dự án, commit được. |
| Plugin | `.mcp.json` bên trong plugin | Cài plugin là kéo theo cả bộ server. |
| Account connector | Kết nối trên claude.ai | Dùng chung giữa các phiên của account. |

Tool MCP mang tên đầy đủ `mcp__<server>__<tool>`. Phần `<server>` phụ thuộc host:
phiên CLI 2026-09-21 dùng tên đọc được (`mcp__claude_ai_Claude_Docs__batch`),
phiên Desktop (2026-11-15 và 2026-11-23) dùng mã định danh của connector
(`mcp__<uuid>__batch`).
Phần lớn tool MCP cũng là **deferred** — vẫn phải `ToolSearch` trước khi gọi.

### 4.2 Trạng thái cục bộ (`claude mcp list`, 2026-11-23)

Lệnh `claude mcp list` health-check từng server và là **nguồn xác thực** về
trạng thái kết nối của các server mà *CLI* quản lý (project, user, plugin,
connector claude.ai). Ngày 2026-11-23 cả bản app `2.1.330` lẫn CLI ở PATH
`2.1.304` đều trả về `No MCP servers configured`. Ngày 2026-11-15, bản PATH
`2.1.268` còn liệt kê `plugin:postman:postman` (chưa xác thực); plugin đó nay đã
gỡ (mục 5.2). Ảnh chụp 2026-09-21 (CLI `2.1.278`) liệt kê 25 server, gồm 16
connector claude.ai và 9 server của plugin `productivity`; CLI không còn liệt kê
chúng, nguyên nhân chưa được xác minh.

Phiên Desktop `2.1.330` (2026-11-23) vẫn nạp MCP server của host mà
`claude mcp list` không liệt kê:

| Nhóm | Server trong phiên |
| :--- | :--- |
| Connector claude.ai | `Claude Docs` (`batch`, `guide`, `update` nạp sẵn; `create`, `delete`, `export`, `query`, `read` deferred); một server certified queries (`certify_query`, `get_live_results`, `share_live_queries`...); `Claude Meetings` (`list_meetings`, `get_meeting`, `get_meeting_transcript`, `follow_meeting_transcript`, `get_meeting_action_items`). Hai server sau có tên `mcp__<uuid>__*`. |
| Host Desktop | `Claude_Browser` (browser pane), `claude-in-chrome`, `terminal`, `visualize`, `scheduled-tasks`, `mcp-registry`, nhóm `ccd_*`: `ccd_session`, `ccd_session_mgmt`, `ccd_turn` (task list và hộp next-step), `ccd_view`, `ccd_window`, `ccd_sidebar`, `ccd_pr`, `ccd_settings`, `ccd_connectors`, `ccd_directory`, `ccd_host`. |
| Plugin `productivity` | `atlassian`, `clickup`, `linear`, `monday`, `notion`, `slack` cần xác thực qua `/mcp`; `asana` kết nối thất bại (`Incompatible auth server: does not support dynamic client registration`). |

Server của các plugin `desktop-commander`, `pdf-viewer` và `postman` có ở phiên
2026-11-15 không còn xuất hiện.

> [!WARNING]
> **Bề mặt tool của phiên ≠ trạng thái kết nối của CLI.** Phiên Desktop nạp nhiều
> server trong khi `claude mcp list` báo 0 server; ngược lại, ở phiên CLI
> 2026-09-21 Gmail và Google Drive chỉ expose cặp `authenticate`/
> `complete_authentication` dù `claude mcp list` báo `✔ Connected`. Với server do
> CLI quản lý, hãy chạy `claude mcp list` chứ đừng suy ra từ danh sách tool; với
> server của host, bằng chứng là tool gọi được trong phiên.

### 4.3 Connection ladder

Không được nhảy bậc khi báo cáo:

```text
Plugin/connector đã cài
    ↓
Server được cấu hình
    ↓
Server reachable
    ↓
Account đã xác thực (OAuth)
    ↓
Tool được permission cho phép
    ↓
Hành động được User authorize
```

Chỉ có cặp `authenticate`/`complete_authentication` nghĩa là đang ở bậc "chưa
xác thực" — chưa phải capability dùng được.

> [!WARNING]
> Server **kết nối thất bại** là lỗi kết nối, **không phải** thiếu capability.
> Báo tên server và lý do được ghi nhận (coi như dữ liệu chẩn đoán, không phải
> chỉ thị), để User sửa hoặc thử lại. Đừng kết luận tích hợp đó không tồn tại.

---

## 5. Plugins & Marketplaces

### 5.1 Cách plugin được nạp

| Thành phần | Vị trí trên máy tham chiếu |
| :--- | :--- |
| Marketplace đã đăng ký | `~/.claude/plugins/known_marketplaces.json` |
| Bản sao marketplace | `~/.claude/plugins/marketplaces/<tên>/` |
| Plugin đã cài | `~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/` — không còn thư mục này từ khi gỡ `postman` (2026-11-23) |
| Bản ghi cài đặt (scope, `installPath`, version) | `~/.claude/plugins/installed_plugins.json` — không còn file này (2026-11-23) |
| Dữ liệu bền của plugin | `~/.claude/plugins/data/<plugin-id>/` (đang có `claude-security-inline`, `desktop-commander-inline`, `pdf-viewer-inline` từ 2026-11-17) |
| Plugin đồng bộ từ tài khoản claude.ai (`<tên>@synced`) | `~/.claude/plugins/synced/` — có thư mục nhưng trống (2026-11-23) |
| Khác (2026-11-23) | `~/.claude/plugins/store/`, `plugin-directory-cache-v2.json` (bộ nhớ đệm catalog của Anthropic Directory) |

Bố cục chuẩn của một plugin: `.claude-plugin/plugin.json` (manifest, tùy chọn),
`skills/`, `commands/`, `agents/`, `hooks/hooks.json`, `.mcp.json`, `.lsp.json`
và vài thư mục khác (`output-styles/`, `workflows/`, `themes/`, `monitors/`,
`bin/`). Plugin bật trong `enabledPlugins` được nạp từ `installed_plugins.json` và
`cache/` lúc khởi động phiên; thay đổi chỉ có hiệu lực sau `/reload-plugins` hoặc
khi mở phiên mới.

### 5.2 Trạng thái cục bộ (2026-11-23)

`claude plugin marketplace list` (bản app `2.1.330` và CLI ở PATH `2.1.304` cho
cùng kết quả): **`anthropic-plugin-directory`** (built-in, Anthropic Directory)
và **`claude-plugins-official`** (GitHub `anthropics/claude-plugins-official`).
Bản sao cục bộ của `claude-plugins-official` liệt kê **317 plugin** trong catalog.

`claude plugin list` ở cả hai binary: `No plugins installed`. Plugin
`postman@claude-plugins-official` v2.3.0 (19 skill, always-on ~2.1k tok) ghi ở
ảnh chụp 2026-11-15 đã không còn; `~/.claude/settings.json` cũng không còn key
`enabledPlugins`.

Plugin trong phiên Desktop (`anthropic-skills`, `productivity`; mục 7.3) do host
nạp, **không** đi qua `claude plugin list`. Nguồn nạp chính xác của chúng chưa
được xác minh.

> [!TIP]
> `claude plugin details <name>` là cách rẻ nhất để biết một plugin **thực sự**
> đóng góp gì và tốn bao nhiêu context trước khi quyết định bật/tắt.

> [!IMPORTANT]
> 317 plugin trong catalog là **chưa cài** qua CLI. Có trong marketplace ≠ đã cài;
> đã cài ≠ đã xác thực. Đừng khai báo plugin chưa cài trong bảng capability.

---

## 6. Artifacts

`Artifact` publish một trang HTML lên claude.ai, mặc định private, và trả về
link chia sẻ được. Đây là **hành động ra ngoài session**, không phải ghi file
thường — chịu ranh giới authority của `docs-harness/harness-constraints/0822-user-authority-operation-gate.md`. Tool cần gói
Pro, Max, Ultra, Team hoặc Enterprise và đăng nhập `/login` (tài liệu chính thức,
đọc lại 2026-11-23); từ `2.1.327` tool từ chối gọi khi Artifacts bị tắt.

| Action | Tác dụng |
| :--- | :--- |
| `publish` (mặc định) | Đăng trang; kèm `url` để cập nhật tại chỗ. |
| `read` | Đọc artifact đã publish (dùng cho link claude.ai, không dùng WebFetch). |
| `list` | Liệt kê artifact (`mine`, `shared`, `all`, `files`, `assets`, `types`). |
| `open` / `pin` / `unpin` | Hiển thị cho User; ghim vào sidebar. |
| `delete` | Xóa vĩnh viễn — chỉ khi User yêu cầu và xác nhận. |
| `quickstart` | Bước đầu tiên khi tạo deck/document/design mới. |

Skill hỗ trợ: `artifact-design` (bắt buộc đọc trước khi viết trang),
`artifact-capabilities` (runtime capability), `artifact-diagramming`, `dataviz`.

Ranh giới: không publish trang mạo danh người/tổ chức thật, hồ sơ giả, form thu
thập credential. Luôn đọc hết file trước khi publish file không do mình viết.

---

## 7. Skills

### 7.1 Vị trí nạp

Theo tài liệu chính thức (trang Skills, đọc lại 2026-11-23), Claude Code nạp skill
từ các nguồn dưới đây; khi trùng tên, Enterprise thắng User-level, User-level
thắng Project. File Markdown trong `.claude/commands/` (kiểu cũ) vẫn chạy:

| Phạm vi | Đường dẫn |
| :--- | :--- |
| Project | `.claude/skills/<name>/SKILL.md` |
| Project lồng nhau | `<subdir>/.claude/skills/<name>/SKILL.md`, nạp khi phiên ở trong `<subdir>` |
| Thư mục thêm (`--add-dir`) | `.claude/skills/` trong thư mục đó |
| User-level | `~/.claude/skills/<name>/SKILL.md` |
| Tài khoản claude.ai (đồng bộ) | `~/.claude/skills/synced/` |
| Enterprise | `.claude/skills/` trong thư mục managed settings |
| Plugin | `<plugin>/skills/<name>/SKILL.md`, gọi là `<plugin>:<skill>` |
| Built-in | Đi kèm bản phát hành Claude Code; tắt bằng setting `disableBundledSkills` |

`.agents/skills/` **không** nằm trong danh sách đó. Repo Harness này giữ bản gốc
ở `.agents/skills/` (nguồn dùng chung với các agent khác) và **mirror sang
`.claude/skills/`**, nơi Claude Code thực sự nạp. Khi sửa skill phải đồng bộ cả
hai; hai cây hiện giống hệt từng byte (21 skill, 73 file, 2026-11-23).
`harness-check` (mục `skill-mirror`) báo drift khi nội dung khác nhau và chỉ báo
`info` khi chỉ khác line-ending; khi tự so sánh, hãy bỏ CR trước:
`diff <(tr -d '\r' < a) <(tr -d '\r' < b)`.

### 7.2 Frontmatter và chế độ gọi

```yaml
---
name: <trùng tên thư mục, lowercase-kebab-case>
description: <mô tả hướng model, chứa các nhánh trigger>
disable-model-invocation: true   # tùy chọn
---
```

Theo tài liệu chính thức (đọc 2026-11-15), mọi field đều tùy chọn và `name` mặc định là
tên thư mục; việc đặt `name` trùng tên thư mục là quy ước của repo. Tài liệu còn
liệt kê field khác (`when_to_use`, `user-invocable`, `allowed-tools`, `paths`,
`hooks`, ...); skill của repo chủ yếu dùng ba field trên.

| Chế độ | Cách đặt | Hệ quả |
| :--- | :--- | :--- |
| **Model-invoked** | Bỏ `disable-model-invocation` | Agent tự gọi được; skill khác gọi được; `description` luôn chiếm context. |
| **User-invoked** | `disable-model-invocation: true` | Chỉ User gõ `/<tên>` mới gọi; **không** xuất hiện trong danh sách available-skills; context load bằng 0; không preload được vào subagent và không chạy được từ scheduled task theo phiên. |

Trong repo này `domain-audit`, `harness-check`, `init-harness-repo` và
`ticket-solving` là user-invoked, nên **không** hiện trong danh sách skill tự
động — đó là thiết kế, không phải lỗi.

Setting `skillOverrides` cũng gỡ skill khỏi danh sách: giá trị `"off"` hoặc
`"user-invocable-only"` loại skill ra, còn `"name-only"` chỉ giữ tên, bỏ mô tả
để tiết kiệm context. Repo này đặt `"off"` cho `utilizing-tools-agy`,
`utilizing-tools-codex`, `utilizing-tools-opencode` và `utilizing-tools-orca-ade`
trong `.claude/settings.local.json` (commit `14235a6`, 2026-11-20). Bốn skill đó
vẫn model-invoked trên đĩa nhưng không có trong danh sách skill của phiên
2026-11-23. Khi một skill có trên đĩa mà vắng khỏi danh sách, kiểm tra
frontmatter rồi đến `skillOverrides` và deny rule `Skill(...)`.

### 7.3 Skill có sẵn theo nhóm (phiên tham chiếu)

**Skill của repo Harness** (21; `.claude/skills/` + `.agents/skills/`),
model-invoked: `asset-design-systems`, `asset-design-systems-hallmark`,
`code-graph`, `goal-griller`, `improve-harness`, `onboarding`, `prd-research`,
`prompt-leverage`, `sequence-execution-plan`, `typesafe-ai`,
`utilizing-tools-agy`, `utilizing-tools-claude`, `utilizing-tools-codex`,
`utilizing-tools-opencode`, `utilizing-tools-orca-ade`, `writing-for-agents`,
`xia`; user-invoked: `domain-audit`, `harness-check`, `init-harness-repo`,
`ticket-solving`. Bốn skill `utilizing-tools-*` khác Claude bị `skillOverrides`
tắt trong phiên của repo này (mục 7.2).

**Skill cấp user** (`~/.claude/skills/`, 2026-11-23): `computer-use`,
`find-skills`, `orca-cli`, `orchestration` (symlink tới `~/.agents/skills/`) và
`taste-skill` (tên trong danh sách: `design-taste-frontend`).

**Built-in của Claude Code**:

| Nhóm | Skill |
| :--- | :--- |
| Artifact & visual | `artifact-design`, `artifact-capabilities`, `artifact-diagramming`, `dataviz` |
| Code quality | `code-review`, `simplify`, `security-review` |
| Cấu hình harness | `update-config`, `keybindings-help`, `fewer-permission-prompts`, `init`, `plugin-authoring` |
| Tự động hóa | `loop`, `schedule`, `workflow-authoring` (thấy ở phiên CLI `2.1.278` và phiên Desktop `2.1.330`) |
| Tham chiếu | `claude-api`, `run` |

**Plugin trong phiên Desktop `2.1.330`** (2026-11-23). `claude plugin list` không
liệt kê plugin nào; host tự nạp các plugin này:

| Plugin | Skill |
| :--- | :--- |
| `anthropic-skills` | `built-in-browser`, `chrome-browser`, `computer-use`, `consolidate-memory`, `deep-research`, `docs`, `docx`, `explain-usage`, `google-workspace`, `import-memory`, `morning`, `pdf`, `pptx`, `setup-claude`, `skill-creator`, `xlsx` |
| `productivity` | `memory-management`, `start`, `task-management`, `update` |

Phiên 2026-11-15 còn có `postman` (19 skill), `desktop-commander`, `pdf-viewer`,
`cowork-plugin-management`, `frontend-design` và `skill-creator`; phiên
2026-11-23 không còn plugin nào trong số đó. `productivity` (có ở ảnh chụp
2026-09-21) đã quay lại.

> [!NOTE]
> `claude-api` có trigger bắt buộc: phải đọc **trước** khi trả lời bất kỳ câu
> hỏi nào về model/pricing/limit của Claude, thay vì trả lời từ trí nhớ.

---

## 8. Subagents & Delegation

Agent type trong phiên Desktop `2.1.330` (2026-11-23); cột Model theo tài liệu
`sub-agents` đọc cùng ngày:

| Agent type | Vai trò | Tool | Model |
| :--- | :--- | :--- | :--- |
| `claude` | Catch-all, mặc định khi không nêu tên agent và cho phiên nền được dispatch. | `*` | Theo thứ tự model khi spawn |
| `general-purpose` | Nghiên cứu phức tạp, tìm kiếm nhiều bước. | `*` | Model của phiên cha |
| `Explore` | Read-only, fan-out search rộng; trả kết luận không dump file. Bắt đầu không có `CLAUDE.md` và git status. | Trừ ghi/Agent | Model của phiên cha |
| `Plan` | Thiết kế kế hoạch triển khai, trade-off kiến trúc. Bắt đầu không có `CLAUDE.md` và git status. | Trừ ghi/Agent | Model của phiên cha |
| `web-fetch` | Đọc một URL thay cho `WebFetch` khi hội thoại chính không có tool đó (mục 2.5): giao URL đầy đủ kèm câu hỏi, nó trả về câu trả lời chứ không phải nội dung trang. Hỏi tiếp bằng `SendMessage`; mỗi URL được cache 15 phút; không đọc được trang cần đăng nhập hoặc riêng tư (Google Docs, Confluence, Jira, GitHub private); với những trang đó dùng `gh`, MCP đã xác thực hoặc built-in browser. | `WebFetch` | Haiku, hoặc model của phiên cha khi không dùng được Haiku |
| `claude-code-guide` | Hỏi đáp về Claude Code, Agent SDK, Claude API, Claude Tag, `claude plugin eval` và `/skill-doctor`. | Glob, Grep, Read, WebFetch, WebSearch | Haiku |
| `statusline-setup` | Cấu hình status line (`/statusline`). | Read, Edit | Sonnet |
| Agent do plugin cung cấp | Theo mô tả của plugin; nhiều agent chỉ do workflow của plugin điều phối. Phiên 2026-11-15 có 8 agent `claude-security:*`; phiên 2026-11-23 không có agent plugin nào. | Theo từng agent | Theo từng agent |

`subagent_type: "fork"` kế thừa toàn bộ context của phiên cha và luôn chạy trên
model của cha; từ `2.1.302` fork bật mặc định ở app Desktop, VS Code, `claude -p`
và Agent SDK (tắt bằng `CLAUDE_CODE_FORK_SUBAGENT=0`), và một fork không spawn fork
khác. Tool `Agent` nhận tham số `effort` từ `2.1.292`. `isolation: "worktree"` cấp
git worktree riêng; `isolation: "remote"` chạy agent trong môi trường cloud (luôn
chạy nền, tùy tài khoản). Từ `2.1.302` app Desktop và VS Code luôn chạy subagent của
hội thoại chính ở nền; báo cáo cuối của subagent **không** hiển thị cho User — phải
thuật lại phần quan trọng.

> [!IMPORTANT]
> **Ràng buộc của repo này**: `docs-harness/harness-constraints/1120-session-role-and-judgment.md` (mục Role) quy
> định phiên chính là Bale, xử lý việc nhỏ trực tiếp; phiên worker đã được giao
> việc **không** được spawn tiếp agent. Skill `utilizing-tools-claude` quy định
> tool `Agent`/`Workflow` chỉ dùng khi User, `CLAUDE.md` hoặc một skill yêu cầu.

---

## 9. CLI Surface (`claude`)

Phần này là bề mặt dòng lệnh, đã chạy thật (`claude --help`, `claude mcp --help`,
`claude plugin --help`) ngày 2026-11-23 trên hai binary của máy tham chiếu: bản app
`2.1.330` (các bảng dưới) và CLI ở PATH `2.1.304`. Hai bản có cùng 18 subcommand,
cùng 11 lệnh `mcp` và cùng 66 flag; chỉ khác ở `claude plugin` (mục 9.3).

### 9.1 Subcommands (18)

| Nhóm | Lệnh | Chức năng |
| :--- | :--- | :--- |
| Phiên nền | `agents` | Quản lý background agents. |
| | `attach <id\|name>` | Mở một phiên nền trong terminal hiện tại; nhận id ngắn hoặc một phần tên phiên. |
| | `logs <id\|name>` | In output gần đây của một phiên nền; nhận id ngắn hoặc một phần tên phiên. |
| | `stop\|kill <id>` | Dừng phiên nền; hội thoại vẫn giữ để `attach` lại. |
| | `rm <id>` | Gỡ phiên nền khỏi danh sách và xóa worktree của nó khi an toàn; hội thoại vẫn giữ (`claude --resume` liệt kê). |
| | `respawn [id]` | Khởi động lại phiên nền theo bản Claude Code hiện tại; `--all` cho mọi phiên. |
| MCP & plugin | `mcp` | Cấu hình và quản lý MCP servers — xem 9.2. |
| | `plugin\|plugins` | Quản lý plugin — xem 9.3. |
| Cài đặt & tài khoản | `auth` | Quản lý xác thực. |
| | `setup-token` | Tạo token dài hạn (cần Claude subscription). |
| | `install [target]` | Cài native build (`stable`, `latest`, hoặc version cụ thể). |
| | `update\|upgrade` | Kiểm tra và cài bản cập nhật. |
| Chẩn đoán & cấu hình | `doctor` | Kiểm tra sức khỏe cài đặt; `/doctor` trong phiên còn sửa được lỗi. |
| | `purge [path]` | **Xóa dữ liệu project** (transcript, task, file history, entry trong `~/.claude.json`) khỏi máy này; có `--dry-run`. Đổi tên từ `claude project purge` ở `2.1.288` (tên cũ vẫn chạy kèm thông báo); `2.1.268` còn subcommand `project`. |
| | `auto-mode` | Xem hoặc reset cấu hình auto mode classifier. |
| | `import [source]` | Nhập cấu hình từ một AI coding agent khác. |
| Khác | `ultrareview [target]` | Multi-agent code review chạy trên cloud cho branch/PR. |
| | `gateway` | Chạy enterprise auth/telemetry gateway. |

### 9.2 `claude mcp` (11 subcommand gồm `help`; giống nhau ở cả hai bản)

| Lệnh | Loại | Ghi chú |
| :--- | :--- | :--- |
| `list` | **Read-only** | Health-check và in trạng thái từng server. Đây là nguồn xác thực về kết nối. |
| `get <name>` | **Read-only** | Chi tiết một server; server `.mcp.json` chưa duyệt hiện `⏸ Pending approval`. |
| `add <name> <commandOrUrl>` | Mutation | Thêm server; `--transport http`, `--header`, `-e KEY=val`. |
| `add-json <name> <json>` | Mutation | Thêm server bằng chuỗi JSON (stdio, SSE, HTTP, WebSocket); `-` thay `<json>` để đọc từ stdin (`2.1.327`). |
| `add-from-claude-desktop` | Mutation | Nhập server từ Claude Desktop (chỉ Mac và WSL). |
| `login <name>` | Mutation credential | Xác thực với server HTTP/SSE hoặc connector claude.ai. |
| `logout <name>` | Mutation credential | Xóa OAuth credential đã lưu. |
| `remove <name>` | Mutation | Gỡ server. |
| `reset-project-choices` | Mutation | Reset toàn bộ lựa chọn duyệt/từ chối server `.mcp.json` của project. |
| `serve` | Mở server | Chạy chính Claude Code như một MCP server. |

### 9.3 `claude plugin` (17 subcommand ở `2.1.330`, gồm `help`; 16 ở `2.1.304`; 14 ở `2.1.268`)

| Lệnh | Loại | Ghi chú |
| :--- | :--- | :--- |
| `list` | **Read-only** | Plugin đã cài, version, path, trạng thái load. |
| `details <name>` | **Read-only** | Component inventory + chi phí token dự kiến. |
| `marketplace` | Hỗn hợp | Quản lý marketplace; `marketplace list` là read-only. |
| `validate <path>` | **Read-only** | Kiểm tra manifest plugin/marketplace, hoặc skills/agents/commands trong một thư mục; `--strict` từ `2.1.323`. |
| `install\|i <plugin>` | Mutation | Cài từ marketplace; `plugin@marketplace` hoặc `--marketplace <source>` (`2.1.292`) để chỉ định nguồn. |
| `uninstall\|remove <plugin>` | Mutation | Gỡ plugin. |
| `update <plugin>` | Mutation | Cập nhật plugin (phải restart mới áp dụng). |
| `enable` / `disable` | Mutation | Bật/tắt plugin đã cài. |
| `prune\|autoremove` | Mutation | Gỡ dependency tự cài không còn cần. |
| `init\|new <name>` | Mutation | Scaffold plugin mới tại `~/.claude/skills/<name>/`; phiên sau tự nạp nó dưới tên `<name>@skills-dir`. |
| `tag [path]` | Mutation git | Tạo tag `{name}--v{version}`, kiểm tra `plugin.json` khớp marketplace. |
| `eval [target]` | **Thực thi** | Chạy eval suite của plugin **trên máy bạn, với quyền của bạn**. |
| `configure <plugin>` | Hỗn hợp | Hiện option của plugin và option chưa đặt; `--values-stdin` lưu giá trị từ stdin (mutation credential). Có từ `2.1.285`, không có ở `2.1.268`. |
| `restore-set-aside <plugin>` | Mutation | Trả lại option và secret đã bị set aside khi marketplace do tổ chức khai báo thay thế nguồn khác. Có ở `2.1.330`, chưa có ở `2.1.304`. |
| `test [dir]` | **Thực thi** | Chạy test của một mod. Có ở `2.1.304` và `2.1.330`, không có ở `2.1.268`. |

> [!WARNING]
> `claude plugin eval` nạp plugin và chạy eval suite của nó bằng quyền của bạn;
> `claude plugin test` cũng thực thi mã test của một mod trên máy bạn. Sandbox
> giới hạn chứ không đảm bảo an toàn, và việc suite chạy pass **không** phải là
> một cuộc thẩm định bảo mật. Chỉ chạy plugin bạn tin tưởng.

### 9.4 Flag đáng chú ý

| Flag | Tác dụng |
| :--- | :--- |
| `-p, --print` | Chạy không tương tác (dùng cho script/CI). |
| `--model <model>` | Alias (`opus`, `sonnet`, `fable`) hoặc tên đầy đủ. |
| `--effort <level>` | `low`, `medium`, `high`, `xhigh`, `max`. |
| `--agent <agent>` / `--agents <json>` | Chọn agent, hoặc định nghĩa custom agent inline. |
| `--allowedTools` / `--disallowedTools` | Allowlist/denylist tool, ví dụ `"Bash(git *)" Edit`. |
| `--dangerously-skip-permissions` | Bỏ qua mọi permission check — chỉ dùng trong sandbox không có internet. |
| `--permission-mode <mode>` | Đặt permission mode cho phiên. |
| `--add-dir <dirs...>` | Cho phép tool truy cập thêm thư mục ngoài cwd. |
| `--mcp-config <configs...>` / `--strict-mcp-config` | Nạp MCP từ file/chuỗi JSON; chỉ dùng đúng bộ đó. |
| `--plugin-dir <path>` | Nạp plugin từ thư mục chỉ định. |
| `--disable-slash-commands` | **Tắt toàn bộ skill** (xem 9.5). |
| `--bare` | Minimal mode: bỏ hooks, LSP, plugin sync, auto-memory, auto-discovery `CLAUDE.md`. |
| `--bg, --background` | Chạy nền và trả về id cho `attach`/`logs`/`stop`/`rm`. |
| `-c, --continue` / `--resume` / `--fork-session` | Tiếp tục, resume, hoặc fork phiên. |
| `--desktop` | Mở phiên trong app Claude Desktop thay vì terminal, kèm `--continue` hoặc `--resume <id>` (từ `2.1.285`; có ở `2.1.304` và `2.1.330`). |
| `--cloud` / `--environment <id>` | Tạo hoặc attach phiên cloud. |
| `--fallback-model <model>` | Tự chuyển model khi model chính quá tải. |
| `--max-budget-usd <amount>` | Trần chi phí API (chỉ với `--print`). |
| `--output-format` / `--json-schema` | Định dạng output; schema cho structured output. |
| `--settings <file-or-json>` / `--setting-sources` | Nạp settings từ file/JSON; chọn nguồn `user,project,local`. |

### 9.5 Slash commands

Trong Claude Code, **skill là slash command**: skill của repo, của user, của
plugin và bundled skill đều gọi được bằng `/<tên-skill>`. Flag
`--disable-slash-commands` được mô tả là *"Disable all skills"* ở `2.1.268` và
*"Disable all skills and commands"* từ `2.1.304` tới `2.1.330`. Danh sách ở mục 7.3 cũng là danh
sách slash command gọi được bằng `/<tên-skill>`.

Ngoài ra còn các lệnh dựng sẵn của CLI, không phải skill; bảng chính thức đầy đủ
được phân loại ở mục 9.7. Các lệnh đã quan sát trực tiếp trong phiên tham chiếu:
`/help`, `/clear`, `/config`, `/doctor`,
`/artifacts`, `/skills`, `/resume`, `/remember`, `/fast`, `/loop`, `/workflows`,
`/skill-doctor` (2026-09-21); `/list-agents`, `/model`, `/compact` (2026-11-15).

> [!NOTE]
> Danh sách lệnh dựng sẵn thay đổi theo bản phát hành. Nguồn xác thực là gõ `/`
> trong phiên hoặc chạy `/help`; đừng coi danh sách trên là đầy đủ.

### 9.6 Discovery an toàn vs mutation

| Mục đích | Lệnh read-only nên dùng |
| :--- | :--- |
| Phiên bản runtime | `claude --version` |
| Trạng thái MCP thật | `claude mcp list`, `claude mcp get <name>` |
| Plugin đã cài | `claude plugin list` |
| Plugin đóng góp gì, tốn bao nhiêu context | `claude plugin details <name>` |
| Marketplace đã đăng ký | `claude plugin marketplace list` |
| Sức khỏe cài đặt | `claude doctor` |

Mọi lệnh còn lại trong 9.2 và 9.3 (`add`, `login`, `install`, `enable`,
`disable`, `update`, `remove`, `init`, `tag`, `eval`, `test`,
`configure --values-stdin`, `restore-set-aside`) đều có side effect lên cấu hình,
credential hoặc hệ thống; ở 9.1, `purge` (xóa dữ liệu project), `rm`, `stop`,
`respawn`, `install` và `update` cũng thay đổi trạng thái — cần authority đúng
target. **Không dùng lệnh cài đặt/xác thực làm phép dò capability.**

### 9.7 Phân loại slash command (bảng chính thức, 2026-11-16)

Tab Code của Claude Desktop chạy cùng engine với CLI và **không có danh sách lệnh
riêng**. Bảng lệnh chính thức (`code.claude.com/docs/en/commands`) có 121 dòng: lệnh
dựng sẵn (mã hóa trong CLI), 20 bundled skill *(skill)*, 1 bundled workflow
*(workflow)*, 3 lệnh đã gỡ và vài alias. Lệnh nào hiện ra còn tùy nền tảng, gói và
môi trường; danh sách thật của một phiên là menu `/` (ở Desktop: nút **+** rồi
**Slash commands**), gồm cả skill của repo, của user và của plugin (mục 7.3). Cột
Công dụng là bản rút gọn từ phần đầu mô tả của từng lệnh.

Khác biệt ở Code tab Desktop (tài liệu Desktop và phiên tham chiếu 2026-11-16):

- Lệnh mở hộp thoại terminal hoạt động khác: theo tài liệu, `/permissions` không
  tham số trả lời `isn't available in this environment`; trong phiên tham chiếu nó
  chỉ mở bộ chọn permission mode. `/config` mở Settings > Code.
- `/btw` mở side chat và không lưu ra đĩa; `/code-review` hiện thẻ có nút
  **Walk through in diff** và **Apply fixes**; `/remote-control` hiện nút
  **Turn off** khi phiên đã bật Remote Control.
- `/resume` chỉ dùng ở phiên local (không dùng ở SSH, WSL, cloud). Desktop quản lý
  plugin bằng plugin manager UI, CLI dùng `/plugin`.
- `/desktop` là lệnh của CLI để chuyển phiên sang Desktop (macOS và Windows x64,
  cần gói subscription).
- Tab Code chạy bản Claude Code riêng, có thể khác `claude` ở terminal; `/status`
  cho biết bản đang chạy (khớp ghi chú hai binary ở đầu tài liệu).
- `/send-to-project` chỉ xuất hiện trong mô tả tool của phiên Desktop 2026-11-15,
  không có trong bảng tài liệu; phiên 2026-11-23 không còn các tool đi kèm nó.

Đối chiếu lại ngày 2026-11-23: 81 dòng đầu của bảng (từ `/add-dir` tới `/rename`)
đọc nguyên văn khớp với các nhóm dưới; phần còn lại chưa đọc lại nguyên văn.
Changelog từ `2.1.326` tới `2.1.330` thêm `/tui classic` (`2.1.327`) và
`/help <command>` (`2.1.326`), đã ghi vào các dòng tương ứng.

**Phiên và hội thoại (18)**

| Lệnh | Công dụng |
| :--- | :--- |
| `/clear [name]` | Hội thoại mới, context trống (alias `/new`) |
| `/compact [instructions]` | Tóm tắt để giải phóng context |
| `/autocompact [auto\|<tokens>]` | Đặt ngưỡng tự compact |
| `/context [all]` | Xem mức dùng context |
| `/resume [session]` | Mở lại hội thoại theo ID hoặc tên |
| `/rename [name]` | Đổi tên phiên |
| `/branch [name]` | Tạo nhánh hội thoại tại điểm này |
| `/fork [prompt]` | Sao chép hội thoại hiện tại |
| `/rewind` | Tua lại hội thoại hoặc code |
| `/recap` | Tóm tắt một dòng về phiên |
| `/export [filename]` | Xuất hội thoại ra văn bản |
| `/copy [N]` | Chép phản hồi gần nhất |
| `/btw [question]` | Hỏi câu phụ (side question) |
| `/cd <path>` | Chuyển thư mục làm việc, giữ hội thoại |
| `/add-dir <path>` | Thêm thư mục làm việc |
| `/focus` | Bật/tắt focus view |
| `/restart` | Khởi động lại và tiếp tục phiên |
| `/exit` | Thoát CLI |

**Model, chi phí, gói (12)**

| Lệnh | Công dụng |
| :--- | :--- |
| `/model [model]` | Đổi model, lưu làm mặc định |
| `/effort [level\|auto\|status\|ultracode [on\|off]]` | Đặt mức effort |
| `/fast [on\|off]` | Bật/tắt fast mode |
| `/advisor [model\|off]` | Bật/tắt advisor tool |
| `/usage`, `/cost`, `/stats` | Chi phí và hạn mức (`/cost`, `/stats` là alias; `/stats` mở tab Stats) |
| `/usage-credits` | Cấu hình hoặc xin usage credits |
| `/rate-limit-options` | Cách làm tiếp khi chạm hạn mức |
| `/upgrade` | Mở trang nâng gói (ẩn ở gói Enterprise) |
| `/privacy-settings` | Cài đặt riêng tư (chỉ Pro, Max, Ultra) |
| `/passes` | Tặng bạn bè một tuần dùng thử (nếu đủ điều kiện) |

**Cấu hình và quyền (21)**

| Lệnh | Công dụng |
| :--- | :--- |
| `/config [key=value]` | Mở Settings (Desktop: Settings > Code) |
| `/permissions` | Quản lý allow/ask/deny |
| `/hooks` | Xem cấu hình hook |
| `/sandbox` | Bật/tắt sandbox |
| `/auto-mode-setup` | Soạn mục `autoMode.environment` |
| `/update-config [request]` *(skill)* | Sửa settings bằng mô tả |
| `/fewer-permission-prompts` *(skill)* | Sinh allowlist từ transcript |
| `/doctor [prompt-audit [path]]` *(skill)* | Kiểm tra cài đặt, settings, `CLAUDE.md` (alias `/checkup`) |
| `/init` | Tạo `CLAUDE.md` |
| `/memory` | Sửa `CLAUDE.md`, auto memory |
| `/output-style [style]` | Đổi output style |
| `/theme`, `/color [color\|default]` | Giao diện; màu thanh prompt |
| `/statusline`, `/status` | Status line; tab Status |
| `/keybindings`, `/terminal-setup` | Phím tắt; Shift+Enter |
| `/tui [default\|classic\|fullscreen]`, `/scroll-speed` | Renderer (`classic` từ `2.1.327`); tốc độ cuộn |
| `/voice [hold\|tap\|off]` | Đọc chính tả |
| `/vim` | Đã gỡ (v2.1.92), dùng `/config` |

**Mở rộng và tác vụ nền (16)**

| Lệnh | Công dụng |
| :--- | :--- |
| `/mcp [...]` | Quản lý kết nối MCP và OAuth |
| `/plugin [subcommand]` | Quản lý plugin |
| `/plugin-authoring` | Nạp tài liệu viết mod |
| `/reload-plugins [--force]`, `/reload-skills` | Nạp lại plugin; quét lại skill |
| `/skills`, `/skill-doctor` | Liệt kê skill; chi phí context của skill |
| `/agents`, `/list-agents` | Nhắc tạo subagent; liệt kê agent và phiên khác |
| `/subtask <task>` | Tạo subagent fork |
| `/background [prompt]`, `/stop` | Tách phiên chạy nền; dừng phiên nền |
| `/tasks` | Xem việc nền |
| `/workflows`, `/workflow-authoring` *(skill)* | Xem tiến độ workflow; tài liệu viết workflow |
| `/import [codex\|gemini\|cursor]` | Nhập cấu hình từ công cụ khác |

**Plan, goal, lặp, lịch (5)**

| Lệnh | Công dụng |
| :--- | :--- |
| `/plan [description]` | Vào plan mode |
| `/goal [condition\|clear]` | Làm tiếp qua nhiều lượt tới khi đạt |
| `/loop [interval] [prompt]` *(skill)* | Lặp một prompt |
| `/schedule [description]` | Cloud scheduled tasks |
| `/ultraplan` | Đã gỡ, dùng plan mode |

**Review, kiểm thử, repo (14)**

| Lệnh | Công dụng |
| :--- | :--- |
| `/code-review [...]` *(skill)*, `/review` | Review diff, PR hoặc branch (`/review` là alias) |
| `/security-review` | Quét lỗ hổng trên branch |
| `/ultrareview [PR or branch]` | Review nhiều agent trên cloud |
| `/simplify [target]` *(skill)* | Dọn code đã đổi và sửa luôn |
| `/diff` | Xem thay đổi trong working tree |
| `/autofix-pr [prompt]` | Phiên cloud tự sửa PR |
| `/batch <instruction>` *(skill)* | Thay đổi lớn song song |
| `/debug [description]` *(skill)* | Bật debug log, chẩn đoán |
| `/verify`, `/run`, `/run-skill-generator` *(skill)* | Chạy app để xác nhận thay đổi |
| `/deep-research <question>` *(workflow)* | Nghiên cứu web có trích dẫn |
| `/pr-comments [PR]` | Đã gỡ (v2.1.91) |

**Artifact và thiết kế (9 dòng)**

| Lệnh | Công dụng |
| :--- | :--- |
| `/design [brief]` *(skill)* | Canvas thiết kế dạng artifact |
| `/design consent`, `/design revoke` | Cấp hoặc thu hồi quyền cho Claude Design |
| `/design-login` | Đăng nhập để dùng `/design-sync` |
| `/design-sync [hint]` *(skill)* | Đồng bộ design system React |
| `/slides [brief]` *(skill)* | Tạo bản trình chiếu |
| `/artifacts` | Liệt kê artifact của bạn |
| `/artifact-capabilities`, `/artifact-diagramming` *(skill)* | Nạp tài liệu tham chiếu |
| `/dataviz [request]` *(skill)* | Hướng dẫn thiết kế biểu đồ |

**Tích hợp và thiết bị (14)**

| Lệnh | Công dụng |
| :--- | :--- |
| `/ide` | Quản lý tích hợp IDE |
| `/chrome`, `/claude-in-chrome [task]` *(skill)* | Cấu hình Chrome; làm việc trong trình duyệt |
| `/desktop` (alias `/app`) | Chuyển phiên sang app Desktop |
| `/mobile` (alias `/ios`, `/android`) | Mã QR tải app di động |
| `/remote-control`, `/remote-env` | Remote Control; môi trường cloud mặc định |
| `/teleport`, `/web-setup` | Kéo phiên cloud về máy; nối GitHub cho cloud |
| `/install-github-app`, `/install-slack-app` | Cài app GitHub, Slack |
| `/setup-bedrock`, `/setup-vertex` | Cấu hình Bedrock, Vertex |
| `/claude-api [...]` *(skill)* | Nạp tài liệu Claude API, Managed Agents |

**Tài khoản, trợ giúp, khác (12)**

| Lệnh | Công dụng |
| :--- | :--- |
| `/login`, `/logout` | Đăng nhập, đăng xuất |
| `/help [command]` | Trợ giúp; trợ giúp của một lệnh từ `2.1.326` |
| `/bug [report]`, `/feedback [report]` | Báo lỗi, gửi phản hồi (cùng một hộp thoại) |
| `/release-notes` | Xem changelog |
| `/insights` | Báo cáo HTML về các phiên gần đây |
| `/team-onboarding` | Tạo hướng dẫn onboarding cho team |
| `/powerup` | Bài học tương tác về tính năng |
| `/heapdump` | Chẩn đoán bộ nhớ (ẩn khỏi menu) |
| `/radio`, `/stickers` | Phụ: radio lo-fi, sticker |

---

## 10. Cấu Hình & Permission

### 10.1 Layout cấu hình

| Phạm vi | Đường dẫn |
| :--- | :--- |
| Project settings | `.claude/settings.json`, `.claude/settings.local.json` |
| Project skills | `.claude/skills/` |
| User settings | `~/.claude/settings.json` |
| User skills | `~/.claude/skills/` |
| Plugin | `~/.claude/plugins/` (mục 5.1) |
| Keybindings | `~/.claude/keybindings.json` |
| Memory | `~/.claude/projects/<project-slug>/memory/` + `MEMORY.md` |
| Session/scratch | `~/.claude/sessions/`, `~/.claude/projects/` |

Máy tham chiếu (2026-11-23): repo `.claude/` có `skills/` và
`settings.local.json` (chỉ key `skillOverrides`, mục 7.2), chưa có
`.claude/settings.json`. `~/.claude/settings.json` có các key:
`agentPushNotifEnabled`, `autoCompactEnabled`, `autoUpdatesChannel`,
`effortLevel`, `hooks`, `model`, `modelSettings`,
`skipDangerousModePermissionPrompt`, `statusLine`, `switchModelsOnFlag`, `theme`.
So với 2026-11-15, `enabledPlugins` và `extraKnownMarketplaces` không còn; `model`,
`effortLevel`, `modelSettings` và `skipDangerousModePermissionPrompt` (có ở ảnh chụp
2026-09-21) đã quay lại; `autoCompactEnabled` và `switchModelsOnFlag` là mới.

### 10.2 Permission và hooks

- Tool call chạy qua permission mode do User chọn. Một call bị **từ chối** nghĩa
  là User không đồng ý — đổi cách tiếp cận, không gọi lại y nguyên.
- **Hooks** cấu hình trong `settings.json` có thể chặn tool call và trả feedback;
  feedback đó được coi như lời của User. Mọi yêu cầu kiểu "từ giờ mỗi khi X thì
  Y" phải hiện thực bằng hook, không phải bằng memory/preference.
- Skill hỗ trợ: `update-config` (sửa `settings.json`, permission, env, hooks),
  `fewer-permission-prompts` (quét transcript và sinh allowlist),
  `keybindings-help`.
- **Bypass permissions mode**: khi bật, ưu tiên làm việc qua `Bash` (đọc bằng
  `cat`/`sed`, sửa bằng `sed`/heredoc) thay vì `Read`/`Edit`/`Write`, chỉ quay
  lại tool chuyên dụng khi shell thực sự không làm được.

---

## 11. Workflow Chọn Capability Chuẩn

### Phase 1 — Phân loại task

| Loại task | Capability ưu tiên |
| :--- | :--- |
| Đọc file đã biết đường dẫn | `Read` (dùng `Glob` trước nếu chưa biết) |
| Tìm nội dung trên toàn repo | `Grep`; `Glob` cho tên/layout |
| Sửa/tạo file | `Edit` (thay chuỗi chính xác), `Write` (file mới/ghi đè) |
| Cell notebook | `NotebookEdit` — deferred |
| Build/test/git/shell | `Bash` hoặc `PowerShell`, trong phạm vi authority |
| Fact/version/spec hiện tại | URL đã biết: `WebFetch`, hoặc subagent `web-fetch` khi hội thoại chính không có `WebFetch` (phiên Desktop `2.1.330`; subagent khác vẫn có `WebFetch`); discovery: `WebSearch` — deferred. Trang cần đăng nhập hoặc JavaScript: built-in browser (Claude in Chrome khi User yêu cầu); repo hoặc dịch vụ riêng tư: `gh` hoặc MCP đã xác thực. Nghiên cứu nhiều nguồn có trích dẫn: skill `deep-research` |
| Quyết định thuộc về User | `AskUserQuestion` |
| Lập kế hoạch trước khi làm | `EnterPlanMode` / `ExitPlanMode` — deferred |
| Nhánh git tách biệt (chỉ khi User yêu cầu rõ, không dùng để điều phối agent) | `EnterWorktree` / `ExitWorktree` — deferred |
| Chờ điều kiện dài | `Monitor` — deferred; hoặc `Bash` `run_in_background` |
| Việc lặp theo lịch | `CronCreate` / `CronList` / `CronDelete` — deferred |
| Quy trình chuyên biệt | `Skill` |
| Trang chia sẻ cho người khác | `Artifact` (+ `artifact-design`) |
| Dịch vụ ngoài | `mcp__<server>__<tool>` đã kết nối và xác thực |
| Khảo sát độc lập, bounded | `Agent` — theo điều kiện ủy thác ở mục 8 |

### Phase 2 — Mandatory declaration

Khi `utilizing-tools-claude` được trigger, mở đầu response bằng bảng:

```markdown
### Selected Claude Code Capabilities
| Tool / MCP / Plugin / Skill / Agent | Purpose in this task | Target scope |
| :--- | :--- | :--- |
| `Grep` | Locate the existing skill pattern | `.agents/skills/` |
| `Write` | Persist the authorized documentation | Named repository paths only |
| `writing-for-agents` | Review skill structure and completion criteria | New `SKILL.md` |
```

Không liệt kê toàn bộ catalog nếu task chỉ cần một subset nhỏ.

### Phase 3 — Execute và verify

1. Kiểm tra target, connection, permission trước khi hành động.
2. Chỉ thực thi capability đã khai báo, trong phạm vi authority. Gọi các tool
   độc lập trong **cùng một message** để chạy song song.
3. Verify bằng proof quan sát được: tool response, diff, output lệnh, artifact.
4. Report changed paths, external side effect, kết quả validation và check chưa
   chạy.

---

## 12. Guardrails & Anti-Patterns

- **User Authority**: theo `docs-harness/harness-constraints/0822-user-authority-operation-gate.md` (Task authority); read-only
  là mặc định cho điều tra.
  Mutation file, cài plugin, xác thực connector, publish artifact, commit/push
  cần authority đúng target.
- **Không gọi deferred tool trước `ToolSearch`**: sẽ fail `InputValidationError`.
- **Không đoán capability**: không tự tạo tên tool, prefix MCP, trạng thái
  plugin/auth, opaque ID hay permission state.
- **Marketplace ≠ đã cài ≠ đã kết nối ≠ đã xác thực**: nêu đúng bậc còn thiếu.
- **Kết nối thất bại ≠ không có capability**: báo lỗi kết nối để User xử lý.
- **Không trộn cú pháp shell**: `Bash` là POSIX, `PowerShell` là 5.1; chọn một.
- **Ưu tiên tool chuyên dụng hơn shell** khi không ở bypass mode: `Grep`/`Glob`/
  `Read`/`Edit` tích hợp permission UI và file link.
- **Không spawn subagent thừa**: việc phiên hiện tại làm được thì làm trực tiếp;
  áp dụng điều kiện ủy thác ở mục 8.
- **Không claim completion sớm**: một tool call thành công chưa phải proof; phải
  đọc result và kiểm tra điều kiện hoàn thành.

---

## 13. Completion Contract

Một task dùng capability Claude Code chỉ được báo hoàn tất khi:

- capability được chọn phù hợp task và khai báo trước execution;
- mọi mục trong bảng khai báo có lý do và target scope rõ ràng;
- kết quả chính có proof quan sát được;
- file/path hoặc external state đã thay đổi được liệt kê;
- validation đã chạy được báo pass/fail, check chưa authorize báo `unattempted`;
- khoảng trống connection/auth hoặc quyết định còn thiếu được nêu kèm bước xử lý
  nhỏ nhất.

---

## 14. Nguồn & Ranh Giới Phiên Bản

Phân loại độ tin cậy của các claim trong tài liệu này:

| Hạng mục | Nguồn | Trạng thái |
| :--- | :--- | :--- |
| Bản app `2.1.330`, CLI ở PATH `2.1.304`; npm `latest`/`next` `2.1.330`, `stable` `2.1.323`; layout `~/.claude/`; key của `settings.json` và `.claude/settings.local.json` | `claude --version` của từng binary, đường dẫn tiến trình `claude.exe`, `registry.npmjs.org/-/package/@anthropic-ai/claude-code/dist-tags`, 2026-11-23 | [LOCAL] đã kiểm chứng |
| Toàn bộ mục 9.1–9.4 (18 subcommand, 11 `mcp`, 17 `plugin` ở `2.1.330` / 16 ở `2.1.304`, 66 flag giống nhau) | `claude --help`, `claude mcp --help`, `claude plugin --help` của cả hai binary, 2026-11-23; số liệu `2.1.268` từ 2026-11-15 | [LOCAL] đã kiểm chứng |
| Trạng thái MCP ở mục 4.2 | `claude mcp list` của cả hai binary, 2026-11-23 | [LOCAL] đã kiểm chứng |
| Marketplace, 317 plugin trong catalog, không plugin nào cài qua CLI | `claude plugin marketplace list`, `claude plugin list`, `marketplace.json` cục bộ, thư mục `~/.claude/plugins/`, 2026-11-23 | [LOCAL] đã kiểm chứng |
| Bảng tool chính thức (53 dòng), nơi nạp skill, agent built-in và model của chúng, field frontmatter, vị trí plugin trên đĩa | Tài liệu `code.claude.com/docs` (tools-reference, skills, sub-agents), 2026-11-23, đọc qua subagent `web-fetch`; plugins/loading từ 2026-11-15. Chi tiết `WebFetch` ở phần sau của tools-reference và phần listing budget của trang skills chỉ có bản tóm tắt, chưa dùng | [DOCS] đã đối chiếu |
| Thay đổi theo bản (`2.1.280`–`2.1.330`) nêu trong tài liệu này | Changelog `code.claude.com/docs/en/changelog`, 2026-11-23; nhiều mục `2.1.280`–`2.1.301` và `2.1.324`–`2.1.326` chỉ có bản tóm tắt; không thấy tiêu đề `2.1.279`, `2.1.297`, `2.1.298`, `2.1.313`, `2.1.315`, `2.1.320`, `2.1.324` | [DOCS] đối chiếu một phần |
| Bộ tool nạp sẵn, deferred tool, agent type, skill, MCP server của phiên | Khai báo của phiên Desktop `2.1.330` ngày 2026-11-23; số liệu cũ từ phiên Desktop 2026-11-15 và phiên CLI 2026-09-21 | [SESSION] quan sát trực tiếp |
| Bộ tool nạp sẵn của một phiên CLI `2.1.330` | Chưa có phiên CLI thuần để đếm lại | [UNKNOWN] chưa kiểm chứng |
| Khi nào host thay `WebFetch` bằng subagent `web-fetch` | Tài liệu nguyên văn chỉ nói agent dùng ở "a session that uses this subagent"; changelog không nhắc | [UNKNOWN] điều kiện chưa xác minh |
| Nguồn nạp plugin `anthropic-skills`, `productivity` trong phiên Desktop | Không có trong `claude plugin list` | [UNKNOWN] chưa xác minh |
| Danh sách lệnh dựng sẵn ở 9.5 | Quan sát trong phiên; **chưa chắc đầy đủ** | [SESSION] chưa liệt kê vét cạn |
| Bảng slash command ở 9.7 (121 dòng) | Tài liệu `code.claude.com/docs` (commands, desktop), 2026-11-16; cột Công dụng rút gọn từ phần đầu mô tả. Ngày 2026-11-23 đọc lại nguyên văn 81 dòng đầu, khớp | [DOCS] đã đối chiếu |
| 25 server của 2026-09-21 không còn trong `claude mcp list`; `postman` và các plugin Desktop của 2026-11-15 biến mất | `claude mcp list`, `claude plugin list`, khai báo phiên | [UNKNOWN] nguyên nhân chưa xác minh |
| Vai trò phiên và ranh giới authority | `docs-harness/harness-constraints/1120-session-role-and-judgment.md`, `docs-harness/harness-constraints/0822-user-authority-operation-gate.md`, `docs-harness/INDEX.md` (`AGENTS.md` là cổng vào) | [POLICY] của repo này |
| Cách viết skill, chế độ invocation, context load | `.agents/skills/writing-for-agents/` | [POLICY] của repo này |

Bề mặt capability của Claude Code thay đổi theo bản phát hành, account và bộ
plugin. Khi tài liệu này và session mâu thuẫn ở mức làm thay đổi thiết kế task,
dừng lại báo User thay vì tự chọn một phía. Đây là cẩm nang team-facing; quyền
hạn thực tế, tool schema và trạng thái kết nối của từng phiên phải được kiểm tra
tại runtime trước khi thực thi.
