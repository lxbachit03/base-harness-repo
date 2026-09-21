# Cẩm Nang Tools, MCP, Plugins, Skills & Agents Của Claude Code

> **Tài liệu tham khảo kỹ thuật cho nhóm phát triển (Team-Facing Documentation)**
> *Vị trí lưu trữ*: `docs/tools/claude/README.md`
> *Phạm vi*: capability surface của Claude Code, đối chiếu runtime cục bộ
> `2.1.278` với bằng chứng session ngày 2026-09-21.

Tài liệu này là bản tương ứng cho Claude Code của [cẩm nang OpenCode](../opencode/README.md),
[cẩm nang Codex](../codex/README.md) và [cẩm nang Antigravity](../antigravity/README.md).
Nó giúp team chọn đúng built-in tool, deferred tool, MCP connector, plugin,
skill và subagent cho từng loại công việc.

> [!IMPORTANT]
> Runtime/session hiện tại là source of truth. Danh sách tool, MCP, plugin,
> skill, agent và trạng thái kết nối thay đổi theo phiên, theo bản phát hành,
> theo account và theo bộ plugin đã cài. Một capability được tài liệu mô tả
> hoặc có mặt trong marketplace **không** chứng minh rằng nó đã được cài, kết
> nối, xác thực hoặc được phép dùng trong phiên của bạn.

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
| - Read/Write/Edit  | - WebFetch/Search  | - mcp__srv__tool  | - marketplace       |
| - Bash/PowerShell  | - Monitor/Cron*    | - .mcp.json       | - <plugin>:<skill>  |
| - Grep/Glob        | - Plan/Worktree    | - account OAuth   | - .claude/skills/   |
| - Skill/ToolSearch | - NotebookEdit     | - plugin .mcp.json| - .agents/skills/   |
| - Agent/Workflow   | - SendMessage      |                   |                     |
| - Artifact         | - TaskStop         | Subagents: claude / Explore / Plan / ...  |
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

Phiên tham chiếu `2.1.278` expose sẵn 18 tool sau.

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
tích hợp với permission UI và file link.

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
| **`ListAgents`** | Liệt kê agent/phiên có thể gửi message. | Tìm địa chỉ trước khi dùng `SendMessage`. |
| **`Workflow`** | Chạy script điều phối nhiều subagent. | Chỉ khi User opt-in rõ ràng vào multi-agent orchestration. |
| **`AskUserQuestion`** | Hỏi User bằng lựa chọn có cấu trúc, hỗ trợ `preview`. | Quyết định thuộc về User, không suy ra được từ code. |
| **`ScheduleWakeup`** | Hẹn lượt tiếp theo trong `/loop` dynamic mode. | Tự điều nhịp vòng lặp; `delaySeconds` bị kẹp `[60, 3600]`. |

### 2.4 Xuất bản và phản hồi

| Tên tool | Chức năng | Use cases |
| :--- | :--- | :--- |
| **`Artifact`** | Publish/read/list/delete trang HTML host trên claude.ai. | Dashboard, deck, tài liệu chia sẻ; xem mục 6. |
| **`ReportFindings`** | Trả kết quả code review dạng danh sách có kiểu. | Chỉ khi hướng dẫn review đang chạy yêu cầu. |
| **`SendFeedback`** | Soạn feedback về Claude Code (queue cục bộ). | Lỗi tái lập được hoặc sai hành vi model; không tự gửi. |
| **`ShareOnboardingGuide`** | Upload `ONBOARDING.md` và trả link chia sẻ. | Sau khi User duyệt nội dung cuối. |

---

## 3. Deferred Tools & `ToolSearch`

Đây là cơ chế **đặc thù của Claude Code** và là nguồn lỗi phổ biến nhất.

Deferred tool chỉ được nêu **tên** trong `<system-reminder>`; schema chưa nạp
nên gọi thẳng sẽ fail với `InputValidationError`. Phải nạp trước:

```text
ToolSearch(query: "select:WebFetch,WebSearch", max_results: 5)   # chọn đích danh
ToolSearch(query: "notebook jupyter", max_results: 5)            # tìm theo keyword
ToolSearch(query: "+slack send", max_results: 5)                 # bắt buộc chứa "slack"
```

Schema trả về nằm trong khối `<functions>`; sau đó tool gọi được như tool
thường. Danh sách deferred trong phiên tham chiếu:

| Nhóm | Tool | Chức năng |
| :--- | :--- | :--- |
| Web | `WebFetch`, `WebSearch` | Lấy nội dung URL đã biết; tìm kiếm web real-time. |
| Kế hoạch | `EnterPlanMode`, `ExitPlanMode` | Vào chế độ lập kế hoạch; trình plan xin duyệt. |
| Git isolation | `EnterWorktree`, `ExitWorktree` | Làm việc trên worktree tách biệt. |
| Theo dõi | `Monitor`, `TaskStop` | Chờ điều kiện; dừng task nền. |
| Lịch | `CronCreate`, `CronList`, `CronDelete` | Agent chạy theo cron. |
| Liên lạc | `SendMessage`, `PushNotification`, `RemoteTrigger` | Gửi tin cho agent/phiên khác; thông báo đẩy. |
| Artifact | `ArtifactComments`, `ArtifactData` | Comment thread; database chia sẻ của artifact. |
| Khác | `NotebookEdit`, `DesignSync`, `EndConversation` | Sửa cell notebook; đồng bộ design; kết thúc hội thoại. |

> [!NOTE]
> `EndConversation` chỉ dùng khi User lạm dụng kéo dài hoặc yêu cầu demo trực
> tiếp; phải nạp hướng dẫn đầy đủ qua `ToolSearch("select:EndConversation")`.

---

## 4. MCP Servers & Connectors

### 4.1 Ba nguồn MCP

| Nguồn | Khai báo tại | Ghi chú |
| :--- | :--- | :--- |
| Project | `.mcp.json` trong repo | Theo dự án, commit được. |
| Plugin | `.mcp.json` bên trong plugin | Cài plugin là kéo theo cả bộ server. |
| Account connector | Kết nối trên claude.ai | Dùng chung giữa các phiên của account. |

Tool MCP mang tên đầy đủ `mcp__<server>__<tool>`, ví dụ
`mcp__claude_ai_Claude_Docs__batch`. Phần lớn tool MCP cũng là **deferred** —
vẫn phải `ToolSearch` trước khi gọi.

### 4.2 Trạng thái cục bộ (`claude mcp list`, 2026-09-21)

Lệnh `claude mcp list` health-check từng server và là **nguồn xác thực** về
trạng thái kết nối. Máy tham chiếu có **25 server** thuộc hai nguồn.

**Connector claude.ai — 16 server** (3 kết nối, 13 chưa xác thực):

| Server | Endpoint | Trạng thái |
| :--- | :--- | :--- |
| Claude Docs | `api.anthropic.com/v1/pages/mcp` | ✔ Connected |
| Google Drive | `drivemcp.googleapis.com/mcp/v1` | ✔ Connected |
| Gmail | `gmailmcp.googleapis.com/mcp/v1` | ✔ Connected |
| Tactiq | `mcp.tactiq.io` | ! Needs authentication |
| Vercel | `mcp.vercel.com` | ! Needs authentication |
| AI Signal | `api.tradingcentral.com/mcp/v1` | ! Needs authentication |
| Adobe for creativity | `adobe-creativity.adobe.io/mcp` | ! Needs authentication |
| Ahrefs | `api.ahrefs.com/mcp/mcp` | ! Needs authentication |
| Figma | `mcp.figma.com/mcp` | ! Needs authentication |
| Eraser | `app.eraser.io/api/mcp` | ! Needs authentication |
| Postman | `mcp.postman.com/minimal` | ! Needs authentication |
| Supermetrics Marketing Analytics | `mcp.supermetrics.com/mcp` | ! Needs authentication |
| Notion | `mcp.notion.com/mcp` | ! Needs authentication |
| Canva | `mcp.canva.com/mcp` | ! Needs authentication |
| HubSpot | `mcp.hubspot.com/anthropic` | ! Needs authentication |
| Microsoft 365 | `microsoft365.mcp.claude.com/mcp` | ! Needs authentication |

**Server do plugin `productivity` cung cấp — 9 server** (6 chưa xác thực,
1 lỗi, 2 chưa cấu hình):

| Server | Endpoint | Trạng thái |
| :--- | :--- | :--- |
| `plugin:productivity:slack` | `mcp.slack.com/mcp` | ! Needs authentication |
| `plugin:productivity:notion` | `mcp.notion.com/mcp` | ! Needs authentication |
| `plugin:productivity:linear` | `mcp.linear.app/mcp` | ! Needs authentication |
| `plugin:productivity:atlassian` | `mcp.atlassian.com/v1/mcp` | ! Needs authentication |
| `plugin:productivity:monday` | `mcp.monday.com/mcp` | ! Needs authentication |
| `plugin:productivity:clickup` | `mcp.clickup.com/mcp` | ! Needs authentication |
| `plugin:productivity:asana` | `mcp.asana.com/v2/mcp` | ✘ **Failed to connect** — `Incompatible auth server: does not support dynamic client registration` |
| `plugin:productivity:google calendar` | — | - Not configured |
| `plugin:productivity:gmail` | — | - Not configured |

Riêng `Claude Docs` có tool nạp sẵn trong phiên (`batch`, `guide`, `update`);
`create`, `delete`, `export`, `query`, `read` là deferred.

> [!WARNING]
> **Bề mặt tool của phiên ≠ trạng thái kết nối của CLI.** Trong phiên tham chiếu,
> Gmail và Google Drive chỉ expose cặp `authenticate`/`complete_authentication`
> dù `claude mcp list` báo `✔ Connected`. Khi cần biết server có kết nối thật
> hay không, hãy chạy `claude mcp list` chứ đừng suy ra từ danh sách tool.

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
| Plugin đã cài | `~/.claude/plugins/synced/<id>/<tên-plugin>/` |
| Manifest plugin đã cài | `~/.claude/plugins/synced/<id>/manifest.json` |

Một plugin đóng gói: `.claude-plugin/plugin.json`, `skills/`, `.mcp.json`,
`README.md`, `CONNECTORS.md`.

### 5.2 Trạng thái cục bộ (2026-09-21)

`claude plugin marketplace list` → marketplace duy nhất: **`claude-plugins-official`**
(GitHub `anthropics/claude-plugins-official`), **310 plugin trong catalog**.

`claude plugin list` → plugin duy nhất đã cài: **`productivity@synced` v1.3.1**,
trạng thái `✔ loaded`. (`manifest.json` ghi `version: "0039"` — đó là số build
nội bộ, không phải version hiển thị.)

`claude plugin details productivity` → component inventory và chi phí token:

| Thành phần | Số lượng | Chi tiết |
| :--- | :--- | :--- |
| Skills | 4 | `memory-management`, `start`, `task-management`, `update` |
| MCP servers | 9 | slack, notion, asana, linear, atlassian, monday, clickup, google calendar, gmail |
| Agents | 0 | — |
| Hooks | 0 | — |
| LSP servers | 0 | — |

Chi phí token (ước lượng): **always-on ~352 tok** cộng vào mọi phiên; on-invoke
`memory-management` ~3.4k, `start` ~1.9k, `update` ~1.9k, `task-management` ~950.

> [!TIP]
> `claude plugin details <name>` là cách rẻ nhất để biết một plugin **thực sự**
> đóng góp gì và tốn bao nhiêu context trước khi quyết định bật/tắt.

> [!IMPORTANT]
> 310 plugin trong catalog là **chưa cài**. Có trong marketplace ≠ đã cài;
> đã cài ≠ đã xác thực. Đừng khai báo plugin chưa cài trong bảng capability.

---

## 6. Artifacts

`Artifact` publish một trang HTML lên claude.ai, mặc định private, và trả về
link chia sẻ được. Đây là **hành động ra ngoài session**, không phải ghi file
thường — chịu ranh giới authority của `AGENTS.md`.

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

| Phạm vi | Đường dẫn |
| :--- | :--- |
| Project (Claude-native) | `.claude/skills/<name>/SKILL.md` |
| Project (agent-compatible) | `.agents/skills/<name>/SKILL.md` |
| User-level | `~/.claude/skills/` |
| Plugin | `<plugin>/skills/<name>/SKILL.md`, gọi là `<plugin>:<skill>` |
| Built-in | Đi kèm bản phát hành Claude Code |

Repo Harness này giữ bản gốc ở `.agents/skills/` và **mirror sang
`.claude/skills/`**. Khi sửa skill phải đồng bộ cả hai; hai cây hiện chỉ khác
line-ending ở một số file, nên khi so sánh hãy bỏ CR trước:
`diff <(tr -d '\r' < a) <(tr -d '\r' < b)`.

### 7.2 Frontmatter và chế độ gọi

```yaml
---
name: <trùng tên thư mục, lowercase-kebab-case>
description: <mô tả hướng model, chứa các nhánh trigger>
disable-model-invocation: true   # tùy chọn
---
```

| Chế độ | Cách đặt | Hệ quả |
| :--- | :--- | :--- |
| **Model-invoked** | Bỏ `disable-model-invocation` | Agent tự gọi được; skill khác gọi được; `description` luôn chiếm context. |
| **User-invoked** | `disable-model-invocation: true` | Chỉ User gõ `/<tên>` mới gọi; **không** xuất hiện trong danh sách available-skills; context load bằng 0. |

Trong repo này `domain-audit` và `ticket-solving` là user-invoked, nên **không**
hiện trong danh sách skill tự động — đó là thiết kế, không phải lỗi.

### 7.3 Skill có sẵn theo nhóm (phiên tham chiếu)

**Skill của repo Harness** (`.claude/skills/` + `.agents/skills/`):
`goal-griller`, `herdr-coordinate-agents`, `improve-harness`, `onboarding`,
`prompt-leverage`, `sequence-execution-plan`, `utilizing-tools-agy`,
`utilizing-tools-claude`, `utilizing-tools-codex`, `utilizing-tools-opencode`,
`writing-for-agents`, `xia`; user-invoked: `domain-audit`, `ticket-solving`.

**Plugin `productivity`**: `productivity:memory-management`,
`productivity:start`, `productivity:task-management`, `productivity:update`.

**Built-in của Claude Code**:

| Nhóm | Skill |
| :--- | :--- |
| Artifact & visual | `artifact-design`, `artifact-capabilities`, `artifact-diagramming`, `dataviz` |
| Code quality | `code-review`, `simplify`, `security-review` |
| Cấu hình harness | `update-config`, `keybindings-help`, `fewer-permission-prompts`, `init` |
| Tự động hóa | `loop`, `schedule`, `workflow-authoring` |
| Tham chiếu | `claude-api`, `run` |

**Plugin `anthropic-skills`**: `docs`, `docx`, `pdf`, `pptx`, `xlsx`,
`skill-creator`, `import-memory`, `morning`.

> [!NOTE]
> `claude-api` có trigger bắt buộc: phải đọc **trước** khi trả lời bất kỳ câu
> hỏi nào về model/pricing/limit của Claude, thay vì trả lời từ trí nhớ.

---

## 8. Subagents & Delegation

| Agent type | Vai trò | Tool |
| :--- | :--- | :--- |
| `claude` | Catch-all, mặc định khi không nêu tên agent. | `*` |
| `general-purpose` | Nghiên cứu phức tạp, tìm kiếm nhiều bước. | `*` |
| `Explore` | Read-only, fan-out search rộng; trả kết luận không dump file. | Trừ ghi/Agent |
| `Plan` | Thiết kế kế hoạch triển khai, trade-off kiến trúc. | Trừ ghi/Agent |
| `claude-code-guide` | Hỏi đáp về Claude Code, Agent SDK, Claude API, Claude Tag. | Glob, Grep, Read, WebFetch, WebSearch |
| `statusline-setup` | Cấu hình status line. | Read, Edit |

`subagent_type: "fork"` kế thừa toàn bộ context của phiên cha và luôn chạy trên
model của cha. `isolation: "worktree"` cấp git worktree riêng. Subagent chạy nền
và báo kết quả sau; báo cáo cuối của nó **không** hiển thị cho User — phải thuật
lại phần quan trọng.

> [!IMPORTANT]
> **Ràng buộc của repo này**: `AGENTS.md` quy định phiên chính là Bale, xử lý
> việc nhỏ trực tiếp. Ủy thác đi qua
> `.agents/skills/herdr-coordinate-agents/SKILL.md`, không gọi thẳng `Agent`.
> Tool `Agent`/`Workflow` chỉ dùng khi User, `CLAUDE.md` hoặc một skill yêu cầu.
> Phiên worker đã được giao việc **không** được spawn tiếp agent.

---

## 9. CLI Surface (`claude`)

Phần này là bề mặt dòng lệnh, đã chạy thật trên máy tham chiếu `2.1.278`.

### 9.1 Subcommands (18)

| Nhóm | Lệnh | Chức năng |
| :--- | :--- | :--- |
| Phiên nền | `agents` | Quản lý background agents. |
| | `attach <id>` | Mở một phiên nền trong terminal hiện tại. |
| | `logs <id>` | In output gần đây của một phiên nền. |
| | `stop\|kill <id>` | Dừng phiên nền; hội thoại vẫn giữ để `attach` lại. |
| | `rm <id>` | Xóa phiên nền (và worktree của nó khi an toàn). |
| | `respawn [id]` | Khởi động lại phiên nền theo bản Claude Code hiện tại. |
| MCP & plugin | `mcp` | Cấu hình và quản lý MCP servers — xem 9.2. |
| | `plugin\|plugins` | Quản lý plugin — xem 9.3. |
| Cài đặt & tài khoản | `auth` | Quản lý xác thực. |
| | `setup-token` | Tạo token dài hạn (cần Claude subscription). |
| | `install [target]` | Cài native build (`stable`, `latest`, hoặc version cụ thể). |
| | `update\|upgrade` | Kiểm tra và cài bản cập nhật. |
| Chẩn đoán & cấu hình | `doctor` | Kiểm tra sức khỏe cài đặt; `/doctor` trong phiên còn sửa được lỗi. |
| | `project` | Quản lý project state. |
| | `auto-mode` | Xem hoặc reset cấu hình auto mode classifier. |
| | `import [source]` | Nhập cấu hình từ một AI coding agent khác. |
| Khác | `ultrareview [target]` | Multi-agent code review chạy trên cloud cho branch/PR. |
| | `gateway` | Chạy enterprise auth/telemetry gateway. |

### 9.2 `claude mcp` (11 subcommand)

| Lệnh | Loại | Ghi chú |
| :--- | :--- | :--- |
| `list` | **Read-only** | Health-check và in trạng thái từng server. Đây là nguồn xác thực về kết nối. |
| `get <name>` | **Read-only** | Chi tiết một server; server `.mcp.json` chưa duyệt hiện `⏸ Pending approval`. |
| `add <name> <commandOrUrl>` | Mutation | Thêm server; `--transport http`, `--header`, `-e KEY=val`. |
| `add-json <name> <json>` | Mutation | Thêm server bằng chuỗi JSON (stdio, SSE, HTTP, WebSocket). |
| `add-from-claude-desktop` | Mutation | Nhập server từ Claude Desktop (chỉ Mac và WSL). |
| `login <name>` | Mutation credential | Xác thực với server HTTP/SSE hoặc connector claude.ai. |
| `logout <name>` | Mutation credential | Xóa OAuth credential đã lưu. |
| `remove <name>` | Mutation | Gỡ server. |
| `reset-project-choices` | Mutation | Reset toàn bộ lựa chọn duyệt/từ chối server `.mcp.json` của project. |
| `serve` | Mở server | Chạy chính Claude Code như một MCP server. |

### 9.3 `claude plugin` (14 subcommand)

| Lệnh | Loại | Ghi chú |
| :--- | :--- | :--- |
| `list` | **Read-only** | Plugin đã cài, version, path, trạng thái load. |
| `details <name>` | **Read-only** | Component inventory + chi phí token dự kiến. |
| `marketplace` | Hỗn hợp | Quản lý marketplace; `marketplace list` là read-only. |
| `validate <path>` | **Read-only** | Kiểm tra manifest plugin/marketplace, hoặc skills/agents/commands trong một thư mục. |
| `install\|i <plugin>` | Mutation | Cài từ marketplace; `plugin@marketplace` để chỉ định nguồn. |
| `uninstall\|remove <plugin>` | Mutation | Gỡ plugin. |
| `update <plugin>` | Mutation | Cập nhật plugin (phải restart mới áp dụng). |
| `enable` / `disable` | Mutation | Bật/tắt plugin đã cài. |
| `prune\|autoremove` | Mutation | Gỡ dependency tự cài không còn cần. |
| `init\|new <name>` | Mutation | Scaffold plugin mới tại `~/.claude/skills/<name>/`. |
| `tag [path]` | Mutation git | Tạo tag `{name}--v{version}`, kiểm tra `plugin.json` khớp marketplace. |
| `eval [target]` | **Thực thi** | Chạy eval suite của plugin **trên máy bạn, với quyền của bạn**. |

> [!WARNING]
> `claude plugin eval` nạp plugin và chạy eval suite của nó bằng quyền của bạn.
> Sandbox giới hạn chứ không đảm bảo an toàn, và việc suite chạy pass **không**
> phải là một cuộc thẩm định bảo mật. Chỉ eval plugin bạn tin tưởng.

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
| `--cloud` / `--environment <id>` | Tạo hoặc attach phiên cloud. |
| `--fallback-model <model>` | Tự chuyển model khi model chính quá tải. |
| `--max-budget-usd <amount>` | Trần chi phí API (chỉ với `--print`). |
| `--output-format` / `--json-schema` | Định dạng output; schema cho structured output. |
| `--settings <file-or-json>` / `--setting-sources` | Nạp settings từ file/JSON; chọn nguồn `user,project,local`. |

### 9.5 Slash commands

Trong Claude Code, **slash command chính là skill** — flag
`--disable-slash-commands` được mô tả đúng nguyên văn là *"Disable all skills"*.
Vì vậy danh sách ở mục 7.3 cũng là danh sách slash command gọi được bằng
`/<tên-skill>`.

Ngoài ra còn các lệnh dựng sẵn của CLI, không phải skill. Các lệnh đã quan sát
trực tiếp trong phiên tham chiếu: `/help`, `/clear`, `/config`, `/doctor`,
`/artifacts`, `/skills`, `/resume`, `/remember`, `/fast`, `/loop`, `/workflows`,
`/skill-doctor`.

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
`disable`, `update`, `remove`, `init`, `tag`, `eval`) đều có side effect lên
cấu hình, credential hoặc hệ thống — cần authority đúng target. **Không dùng
lệnh cài đặt/xác thực làm phép dò capability.**

---

## 10. Cấu Hình & Permission

### 9.1 Layout cấu hình

| Phạm vi | Đường dẫn |
| :--- | :--- |
| Project settings | `.claude/settings.json`, `.claude/settings.local.json` |
| Project skills | `.claude/skills/` |
| User settings | `~/.claude/settings.json` |
| Keybindings | `~/.claude/keybindings.json` |
| Memory | `~/.claude/projects/<project-slug>/memory/` + `MEMORY.md` |
| Session/scratch | `~/.claude/sessions/`, `~/.claude/projects/` |

Máy tham chiếu: repo `.claude/` **chỉ có `skills/`**, chưa có settings project.
`~/.claude/settings.json` có các key: `model`, `statusLine`, `effortLevel`,
`modelSettings`, `autoUpdatesChannel`, `skipDangerousModePermissionPrompt`,
`theme`.

### 9.2 Permission và hooks

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
| Build/test/git/shell | `Bash` hoặc `PowerShell`, trong phạm vi authority |
| Fact/version/spec hiện tại | `WebFetch` (URL đã biết), `WebSearch` (discovery) — deferred |
| Quyết định thuộc về User | `AskUserQuestion` |
| Lập kế hoạch trước khi làm | `EnterPlanMode` / `ExitPlanMode` — deferred |
| Chờ điều kiện dài | `Monitor` — deferred; hoặc `Bash` `run_in_background` |
| Việc lặp theo lịch | `CronCreate` / `CronList` / `CronDelete` — deferred |
| Quy trình chuyên biệt | `Skill` |
| Trang chia sẻ cho người khác | `Artifact` (+ `artifact-design`) |
| Dịch vụ ngoài | `mcp__<server>__<tool>` đã kết nối và xác thực |
| Khảo sát độc lập, bounded | `Agent` — qua `herdr-coordinate-agents` trong repo này |

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

- **User Authority**: theo `AGENTS.md`; read-only là mặc định cho điều tra.
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
  ủy thác trong repo này đi qua `herdr-coordinate-agents`.
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
| `claude --version` = `2.1.278`; layout `~/.claude/`; key của `settings.json` | Output lệnh cục bộ 2026-09-21 | [LOCAL] đã kiểm chứng |
| Toàn bộ mục 9 (18 subcommand, 11 `mcp`, 14 `plugin`, flag) | `claude --help`, `claude mcp --help`, `claude plugin --help` | [LOCAL] đã kiểm chứng |
| Trạng thái 25 MCP server ở mục 4.2 | `claude mcp list` | [LOCAL] đã kiểm chứng |
| Marketplace, `productivity` v1.3.1, component inventory, chi phí token | `claude plugin marketplace list`, `claude plugin list`, `claude plugin details productivity` | [LOCAL] đã kiểm chứng |
| Danh sách built-in tool, deferred tool, agent type, skill | Khai báo của session tham chiếu 2026-09-21 | [SESSION] quan sát trực tiếp |
| Danh sách lệnh dựng sẵn ở 9.5 | Quan sát trong phiên; **chưa chắc đầy đủ** | [SESSION] chưa liệt kê vét cạn |
| `plugin:productivity:asana` lỗi `Incompatible auth server` | `claude mcp list` và thông báo của session | [LOCAL] nguyên nhân gốc chưa xác minh |
| Gmail/Google Drive `✔ Connected` trong CLI nhưng session chỉ expose tool `authenticate` | Đối chiếu CLI với session | [UNKNOWN] lý do chưa xác minh |
| Ràng buộc delegation qua Herdr, ranh giới authority | `AGENTS.md`, `docs-harness/INDEX.md` | [POLICY] của repo này |
| Cách viết skill, chế độ invocation, context load | `.agents/skills/writing-for-agents/` | [POLICY] của repo này |

Bề mặt capability của Claude Code thay đổi theo bản phát hành, account và bộ
plugin. Khi tài liệu này và session mâu thuẫn ở mức làm thay đổi thiết kế task,
dừng lại báo User thay vì tự chọn một phía. Đây là cẩm nang team-facing; quyền
hạn thực tế, tool schema và trạng thái kết nối của từng phiên phải được kiểm tra
tại runtime trước khi thực thi.
