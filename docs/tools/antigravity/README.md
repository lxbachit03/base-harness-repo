# Cẩm Nang Tools, MCP, Plugins & Skills Của Google Antigravity (agy)

> **Tài liệu tham khảo kỹ thuật cho nhóm phát triển (Team-Facing Documentation)**  
> *Vị trí lưu trữ*: `docs/tools/antigravity/README.md`  
> *Cập nhật*: 2026-11-21, theo Antigravity CLI `agy` **1.5.14** (mục changelog mới nhất: 1.5.13, phát hành 2026-11-20).  
> *Nguồn*: năm worker `agy` chạy qua ứng dụng Herdr (`gemini-4-hydrogen-high`, `gemini-4-neon-high`, `gemini-4-argon-high`, `gemini-pro-orchestrator-neon`, `gemini-pro-orchestrator-g1-pro`) cùng nhận một brief chỉ đọc, đối chiếu chéo với tài liệu chính thức `https://antigravity.google/docs/` và `agy changelog`. Menu `/` và `/help` được đọc thêm trực tiếp từ một worker. Mục nào chỉ một nguồn xác nhận được ghi rõ là *có điều kiện*. Bằng chứng nằm ở `docs-harness/harness-improvements/1121-agy-tools-skill-refresh.md`.  
> *Mục đích*: tổng hợp công cụ tích hợp sẵn (built-in tools), MCP, Plugins, Skills, Slash Commands và chế độ quyền của nền tảng AI Agent **Google Antigravity (AGY)**.

Danh sách thực tế phụ thuộc phiên bản, bề mặt (CLI, IDE, App) và chế độ chạy. Khi lệch với tài liệu này, schema tool của phiên đang chạy là nguồn quyết định.

---

## 1. Tổng Quan Kiến Trúc Antigravity

**Google Antigravity (AGY)** là nền tảng lập trình cặp và điều phối AI Agent tự trị do Google DeepMind phát triển. CLI `agy` là một binary độc lập dùng chung agent harness với Antigravity App 2.0 và IDE. Nền tảng cho phép:

- Đọc, ghi, sửa tệp và chạy lệnh PowerShell/Shell trên máy của lập trình viên, mặc định trong sandbox.
- Chạy tác vụ nền và hẹn giờ đánh thức (Reactive Wakeup), không cần polling.
- Khởi tạo subagent, chạy script điều phối nhiều agent bằng Python (`run_workflow`), hoặc mở swarm trên bảng chung (`/swarm`).
- Mở rộng bằng Plugins, MCP servers, Skills, Rules, Hooks và custom agents.

```text
+---------------------------------------------------------------------------------------+
|                              Antigravity CLI (agy 1.5.14)                            |
+---------------------------------------------------------------------------------------+
|  [14 Built-in Tools]   [3 Plugins]            [30 Skills]       [Slash Commands]      |
|  - File: read/write/   - chrome-devtools      - 5 builtin       - /goal /plan         |
|    edit                - modern-web-guidance  - 9 plugin        - /grill-me /learn    |
|  - run_command         - google-antigravity-  - 16 repository   - /compact /schedule  |
|  - Multi-agent           sdk                                    - /browser /teamwork  |
|  - search_web          (0 MCP tool trong các  (đếm trong phiên  - /boost /swarm       |
|  - ask_question         phiên đã kiểm tra)     của repo này)                          |
+---------------------------------------------------------------------------------------+
```

---

## 2. Built-in Tools (Công Cụ Cốt Lõi)

Cả năm phiên kiểm tra đều thấy đúng **14 tool** dưới đây (hai phiên Orchestrator thấy thêm `exit_plan_mode`, xem 2.6).

### 2.1 Thao Tác Tệp & Mã Nguồn

| Tool | Chức năng | Tham số / giới hạn chính |
| :--- | :--- | :--- |
| **`read_file`** | Đọc text, ảnh, PDF, video, audio theo đường dẫn tuyệt đối. | `Path`, `StartLine`, `EndLine`, `ByteOffset`; tối đa 800 dòng hoặc 46.080 bytes mỗi lần. |
| **`write_file`** | Tạo tệp mới, ghi đè hoặc nối cuối; tự tạo thư mục cha. | `Path`, `Content`, `Overwrite`, `Append` (không dùng chung `Overwrite=true`), `ArtifactMetadata`. Lỗi nếu tệp tồn tại mà không đặt `Overwrite` hoặc `Append`. |
| **`edit_file`** | Thay một khối liên tục trong tệp có sẵn, khớp chính xác kể cả khoảng trắng. | `Path`, `Target`, `Replacement`, `ArtifactMetadata`. Thay mọi vị trí khớp `Target`. |

Không có tool riêng để liệt kê thư mục hay tìm nội dung: dùng `run_command` (`Get-ChildItem`, `rg`, `Select-String`).

### 2.2 Thực Thi Hệ Thống & Tiến Trình

| Tool | Chức năng | Tham số / giới hạn chính |
| :--- | :--- | :--- |
| **`run_command`** | Chạy lệnh PowerShell trên Windows, mỗi lần là một phiên mới (không giữ `cwd` và biến môi trường). | `CommandLine`, `toolSummary`, `WaitMsBeforeAsync` (500–10.000 ms), `BypassSandbox` (mặc định `false`), `IsDaemon`. |
| **`manage_task`** | Quản lý tiến trình nền của hội thoại. | `Action` (`list`, `status`, `send_input`, `kill`), `TaskId`, `Input`. |
| **`schedule`** | Hẹn một lần (timer) hoặc định kỳ (cron 5 trường) để đánh thức agent. | `Prompt`, `DurationSeconds` hoặc `CronExpression`, `TimerCondition` (`never`, `any`, ID), `ExactTiming`, `IsDaemon`, `MaxIterations`. |

### 2.3 Đa Đặc Vụ (Multi-Agent)

| Tool | Chức năng | Tham số / giới hạn chính |
| :--- | :--- | :--- |
| **`invoke_subagent`** | Chạy subagent nền, tự báo lại khi xong. | `TypeName`, `Role`, `Prompt`, `Model` (`inherit`, `flash_lite`, `flash`, `pro`), `Workspace` (`inherit`, `branch`, `share`). |
| **`define_subagent`** | Định nghĩa loại subagent dùng lại trong hội thoại. | `Name`, `Description`, `SystemPrompt`, `EnableWriteTools`, `EnableMCPTools`, `EnableSubagentTools`. |
| **`manage_subagents`** | Liệt kê hoặc dừng subagent. | `Action` (`list`, `kill`, `kill_all`), `ConversationIds`. `kill` xóa cả subagent con và workspace `branch`. |
| **`send_message`** | Gửi tin cho subagent hoặc peer qua Conversation ID (không gửi cho User). | `Recipient`, `Message`. |
| **`run_workflow`** | Chạy script Python điều phối nhiều agent và tool (`agent`, `parallel`, `pipeline`, `phase`, `trajectory`, `call_tool`). Phát hành rộng rãi từ 1.5.9. | `Script` hoặc `ScriptPath`, `Args`, `Cwd`, `Description`, `WaitMsBeforeAsync` (≤ 10.000 ms). Skill `run-workflow` hướng dẫn cách viết. |
| **`swarm`** | Điều phối nhóm agent trên bảng chung. Chỉ gọi khi User dùng `/swarm`, skill yêu cầu hoặc swarm đang mở (từ 1.5.13, agent không tự mở swarm). | `action` (`status`, `models`, `add`, `model`, `kill`, `title`), `name`, `brief`, `model`, `workspace`, `fork`, `n`, `tasks`, `all`, `title`. |

**Loại subagent có sẵn**: `self` (kế thừa cấu hình, tool, model của agent cha), `research` (chỉ đọc, sandbox không mạng), `image-generator` (tạo và sửa ảnh, trả đường dẫn tệp). Ba chế độ workspace: `inherit` (dùng chung workspace cha), `branch` (bản sao hoặc nhánh cô lập), `share` (working copy riêng, chia sẻ kho gốc kiểu git worktree).

### 2.4 Tra Cứu Web

| Tool | Chức năng | Tham số |
| :--- | :--- | :--- |
| **`search_web`** | Tìm kiếm web, trả bản tóm tắt kèm URL trích dẫn. | `query`, `domain` (tùy chọn). |

Không có tool đọc URL riêng và không có tool sinh ảnh riêng: tạo ảnh qua `invoke_subagent` với loại `image-generator`.

### 2.5 Giao Tiếp Người Dùng

| Tool | Chức năng | Tham số |
| :--- | :--- | :--- |
| **`ask_question`** | Hiện câu hỏi trắc nghiệm (một hoặc nhiều lựa chọn) và chờ trả lời; giao diện tự thêm mục *Other*. | `questions` (mảng `question`, `options`, `is_multi_select`). |

### 2.6 Chỉ Có Trong Một Số Phiên (có điều kiện)

- **`exit_plan_mode`** (`plan`): tắt Plan Mode và bàn giao kế hoạch cho model thực thi. Hai phiên Orchestrator (Neon, Argon) thấy tool này và cho biết đang chạy giao thức hai pha; ba phiên Gemini 4 không thấy.
- Subagent `browser`: changelog (1.5.1) nói chỉ chạy như một subagent, nhưng không phiên nào liệt kê nó trong danh sách subagent.

### 2.7 Tên Tool Cũ Và Trạng Thái

Tài liệu cũ và bề mặt IDE còn dùng các tên sau. Không phiên `agy` 1.5.14 nào thấy chúng:

| Tên cũ | Thay bằng |
| :--- | :--- |
| `view_file` | `read_file` |
| `write_to_file` | `write_file` |
| `replace_file_content` (`TargetContent`, `ReplacementContent`) | `edit_file` (`Target`, `Replacement`) |
| `list_dir`, `grep_search`, `find_by_name` | `run_command`. Changelog 1.2.7 gỡ chúng khỏi bộ mặc định; chỉ custom agent khai báo rõ mới còn dùng. |
| `read_url_content` | không có tool tương đương (dùng `search_web`) |
| `generate_image` | subagent `image-generator` (từ 1.2.16) |

---

## 3. Model Context Protocol (MCP) & Plugins

### 3.1 Cấu Hình MCP

- Tệp cấu hình: `~/.gemini/config/mcp_config.json` (toàn cục), `.agents/mcp_config.json` (workspace), `plugins/<tên>/mcp_config.json` (plugin).
- Hỗ trợ **Stdio** (`command`, `args`, `env`) và **Streamable HTTP** (`url`, còn nhận khóa cũ `serverUrl`, `headers`). Không hỗ trợ HTTP+SSE cũ (spec 2024-11-05); dùng cầu nối như `mcp-remote`.
- Quản lý: `agy mcp add|remove|list|enable|disable` hoặc `/mcp`. MCP server của plugin tự có tiền tố `<plugin>_<server>`.
- Trong các phiên đã kiểm tra, **không có tool MCP nào** được nạp. Hai phiên đọc được `~/.gemini/config/mcp_config.json` thấy tệp rỗng (0 byte); ba phiên còn lại bị sandbox chặn đọc.

### 3.2 Ba Plugin Đang Bật

Cả ba hiện `enabled` trong `agy plugin list --json` và đều **không** cấp tool MCP trong phiên; chúng chỉ cấp skill.

| Plugin | Phiên bản | Cung cấp |
| :--- | :--- | :--- |
| `chrome-devtools-plugin` | 1.10.1 | 6 skill điều khiển trình duyệt qua Chrome DevTools (xem 4.2). Cần MCP Chrome DevTools hoạt động mới chạy thật (skill ghi rõ không áp dụng với `--slim`). |
| `modern-web-guidance-plugin` | 1.0.0 | 2 skill hướng dẫn web hiện đại. Chạy `npx -y modern-web-guidance@latest`. |
| `google-antigravity-sdk` | 0.0.9 | 1 skill về Antigravity SDK. |

### 3.3 Cấu Trúc Và Quản Lý Plugin

- Một plugin gồm `plugin.json` (hoặc `.antigravity-plugin/plugin.json`), `skills/`, `rules/` (khuyến nghị `AGENTS.md`), `agents.json`, `mcp_config.json`, `hooks.json` (với plugin native bắt buộc nằm ở gốc plugin).
- Lệnh: `agy plugin list|import|install|uninstall|enable|disable|validate|link` và `/plugin`. Trạng thái bật/tắt lưu trong `config.json`. `validate` nhận `.zip`, URL, link GitHub `/tree/<nhánh>/<đường dẫn>` (từ 1.5.11).
- Admin có `pluginControls` (`pluginsDisabled`, `marketplaceDisabled`, từ 1.5.9).

---

## 4. Skills

Phiên của repo này thấy **30 skill**: 5 builtin, 9 plugin, 16 repository. Trong danh sách skill mà model nhận (`<skills>`) tên hiển thị **trần**, không có tiền tố `<plugin>:`; trong menu `/` skill plugin hiện kèm tiền tố (xem 5.1). Tài liệu chính thức ghi tiền tố dùng để tránh trùng tên.

### 4.1 Skill Builtin Của `agy` (5)

- **`agy-customizations`**: tùy biến Skills, Rules, Plugins, Hooks, MCP.
- **`antigravity-guide`**: sitemap và cẩm nang CLI, App 2.0, IDE, SDK, slash commands.
- **`run-workflow`**: viết và chạy workflow Python với tool `run_workflow`.
- **`swarm_monitor`**: chỉ cho worker giám sát phát hiện swarm bị kẹt.
- **`swarm_pane`**: chỉ cho coordinator cập nhật giao diện Swarm trong `/swarm`.

### 4.2 Skill Của Plugin (9)

- `chrome-devtools-plugin`: **`chrome-devtools`** (điều khiển và gỡ lỗi trình duyệt), **`debug-optimize-lcp`**, **`memory-leak-debugging`**, **`a11y-debugging`**, **`cookie-debugging`** (cookie, session, 401/403, SameSite), **`troubleshooting`** (lỗi kết nối MCP và trang đích).
- `modern-web-guidance-plugin`: **`modern-web-guidance`** (tra cứu trước khi viết UI web), **`chrome-extensions`** (Manifest V3).
- `google-antigravity-sdk`: **`google-antigravity-sdk`**.

### 4.3 Skill Của Repository (`.agents/skills/`)

Danh sách đầy đủ và mới nhất nằm trong thư mục `.agents/skills/`; bảng dưới chỉ nêu nhóm đang có ngày 2026-11-21.

| Nhóm | Skill |
| :--- | :--- |
| Quy trình Harness | `goal-griller`, `improve-harness`, `prompt-leverage`, `sequence-execution-plan`, `writing-for-agents`, `xia`, `onboarding`, `prd-research` |
| Chọn công cụ theo nền tảng | `utilizing-tools-agy`, `utilizing-tools-claude`, `utilizing-tools-codex`, `utilizing-tools-opencode`, `utilizing-tools-orca-ade` |
| Thiết kế và AI có kiểu | `asset-design-systems`, `asset-design-systems-hallmark`, `typesafe-ai` |
| Ẩn khỏi model (`disable-model-invocation: true`), chỉ chạy khi User gọi tên | `domain-audit`, `harness-check`, `init-harness-repo`, `ticket-solving` |

---

## 5. Slash Commands, Chế Độ Quyền & Sandbox

### 5.1 Slash Commands

Gõ `/` trong `agy` mở menu **80 mục** (đọc trực tiếp từ một phiên `agy` 1.5.14, `/help` liệt kê riêng nhóm lệnh built-in). Menu gồm bốn nhóm:

**a) 38 lệnh built-in của CLI** (bí danh trong ngoặc): `/add-dir`, `/agents`, `/artifact`, `/btw`, `/changelog`, `/clear` (`/new`), `/codesearch` (`/cs`, `/search`), `/config` (`/settings`), `/context`, `/copy`, `/credits`, `/diff`, `/effort`, `/exit` (`/quit`), `/feedback`, `/fork` (`/branch`), `/help`, `/hooks`, `/keybindings`, `/logout`, `/mcp`, `/model`, `/open`, `/permissions`, `/plugin`, `/projects`, `/record`, `/remote-control`, `/rename`, `/resume` (`/switch`, `/conversation`), `/rewind` (`/undo`), `/skills`, `/statusline`, `/tasks`, `/thinking`, `/title`, `/usage` (`/quota`), `/voice`.

**b) 9 lệnh mức prompt** (cũng nằm trong prompt hệ thống của phiên; agent không tự gọi):

| Lệnh | Mô tả |
| :--- | :--- |
| `/goal` | Chạy tới khi mục tiêu hoàn tất. |
| `/compact` | Nén lịch sử hội thoại để giải phóng context. |
| `/schedule` | Chạy chỉ thị theo lịch hoặc hẹn một lần. |
| `/browser` | Gọi browser agent cho tác vụ web. |
| `/plan` | Lập kế hoạch kỹ trước khi thực thi. |
| `/grill-me` | Phỏng vấn để thống nhất kế hoạch. |
| `/teamwork` | Gọi nhóm agent tự trị cho dự án lớn. |
| `/learn` | Rút bài học thành skill hoặc rule tái dùng. |
| `/boost` | Gọi bộ điều phối đa agent Boost cho tác vụ phức tạp. |

**c) `/swarm`**: chạy swarm nhiều agent song song trên một việc; menu ghi nhãn *Preview & Quota Heavy*. `/swarm board` mở bảng chung.

**d) Mỗi skill là một slash command** (`/<skill>`), gồm cả skill ẩn khỏi model như `/harness-check`, `/domain-audit`, `/init-harness-repo`, `/ticket-solving` (User gọi được dù model không tự chọn). Skill của plugin hiện **kèm tiền tố**: `/chrome-devtools-plugin:chrome-devtools`, `/modern-web-guidance-plugin:modern-web-guidance`, `/google-antigravity-sdk:google-antigravity-sdk`. Menu đọc được 78 mục (38 + 9 + `/swarm` + 30 skill); hai mục còn lại chưa hiện khi cuộn (có thể là hai skill repo như `/xia`, `/writing-for-agents`).

- Có thể xếp chuỗi nhiều slash command (`/plan /grill-me ...`, từ 1.1.5). Frontmatter `disable-slash-command: true` ẩn skill khỏi menu `/` nhưng model vẫn gọi được; cờ `--disable-slash-commands` dùng với `agy -p`.
- Phím tắt đáng nhớ trong `/help`: `Shift+Tab` đổi chế độ, `Ctrl+O` xem trajectory, `Alt+J` quản lý subagent, `Ctrl+K` duyệt nhanh subagent, `Ctrl+G` mở prompt trong `$EDITOR`, `Ctrl+R` xem artifact.

### 5.2 Cờ Và Lệnh Con CLI

- Cờ: `--model`, `--effort` (`low`, `medium`, `high`, `xhigh`, `max`), `--mode` (`accept-edits`, `auto`, `plan`), `--sandbox`, `--dangerously-skip-permissions`, `--agent`, `--add-dir`, `-p/--print`, `-c/--continue`, `--input-format`/`--output-format` (`stream-json`), `--json-schema`, `--remote-agent`, `--remote-control`.
- Lệnh con: `acp`, `agent(s)`, `changelog`, `install`, `mcp`, `mic-serve`, `models`, `plugin(s)`, `remote-control`, `update`.
- `-p/--print` chạy một lần không tương tác; `-i/--prompt-interactive` vào chế độ tương tác với prompt đầu.

### 5.3 Chế Độ Quyền Và Sandbox

- Chế độ thực thi: `default`, `accept-edits`, `auto`, `plan` (xoay bằng Shift+Tab). Preset quyền: Request Review, Default, Auto, Turbo. Luật ưu tiên `Deny > Ask > Allow`.
- Sandbox terminal (AppContainer trên Windows) mặc định: ghi trong workspace, thư mục `brain/` của agy và `/tmp`; **không mạng**; **không đọc tệp ngoài workspace**. Đọc tệp ngoài workspace hoặc `BypassSandbox: true` bật hộp thoại xin quyền mà chỉ User trả lời được. Trên Windows, `pnpm install|add|remove|update|dlx|create` buộc `BypassSandbox: true`.
- Từ 1.5.10 sandbox chặn mặc định `~/.config`, `AppData\Roaming`, `~/.git-credentials`; từ 1.4.6 chặn `~/.docker`, `~/.kube`, `~/_netrc`.
- `--dangerously-skip-permissions` vẫn chặn danh sách lệnh hệ thống (1.5.2).
- Phiên có Plan Mode bật (hai phiên Orchestrator) từ chối tool sửa tệp cho tới khi gọi `exit_plan_mode`.

### 5.4 Model

Danh sách theo tài khoản và bản phát hành, lấy bằng `agy models`: họ `gemini-4-hydrogen-*`, `gemini-4-neon-*`, `gemini-4-argon-*`, `gemini-pro-orchestrator-*`, `gemini-3.8-flash-*`, ngoài ra `claude-*` và `gpt-oss-120b-medium`. Hydrogen/Carbon từ 1.5.8, Orchestrator từ 1.5.10, Neon từ 1.5.12.

---

## 6. Khả Năng Mở Rộng Và Tùy Biến

1. **Rules**: `GEMINI.md`, `AGENTS.md`, `.agents/rules/*.md`, `.agents/rules.json` (không còn dùng `.agentrules`). Mỗi tệp tối đa 24 KB; toàn bộ rule luôn bật có ngân sách riêng 20.000 token.
2. **Custom Skills**: `.agents/skills/<tên>/SKILL.md`, nạp theo progressive disclosure; cũng quét `.agent/`, `_agents/`, `_agent/`, `skills.json`, `~/.gemini/config/` và skill builtin. `SKILL.md` thiếu `name` thì lấy tên thư mục (1.5.10).
3. **Custom agents**: Markdown `agent.md` có YAML frontmatter; gọi trực tiếp bằng `@<subagent> <tin nhắn>`.
4. **MCP và Plugins**: xem mục 3.
5. **Hooks (`hooks.json`)**: 6 sự kiện `SessionStart`, `PreToolUse` (trả `allow`, `deny`, `ask`, `force_ask`), `PostToolUse`, `PreInvocation`, `PostInvocation`, `Stop`; chỉ hỗ trợ `type: "command"` đồng bộ.
6. **Thứ tự nạp customization (cao xuống thấp)**: workspace (`.agents/` và các biến thể) → cấu hình khai báo (`skills.json`, `plugins.json`) → `~/.gemini/config/` → customization builtin.

---

## 7. Mốc Thay Đổi Quan Trọng Và Giới Hạn Kiểm Chứng

| Phiên bản | Thay đổi |
| :--- | :--- |
| 1.2.7 | Gỡ `find_by_name`, `grep_search`, `list_dir` khỏi bộ tool mặc định |
| 1.2.16 | Sinh ảnh chuyển sang subagent `image-generator` |
| 1.5.5 | Thêm `/swarm`; worktree giữ thay đổi chưa commit |
| 1.5.9 | `run_workflow` phát hành rộng rãi (Python nhúng sẵn) |
| 1.5.10 | Thêm model Orchestrator; sandbox chặn đọc `~/.config`, `AppData\Roaming` |
| 1.5.13 | Gộp đọc/tìm/sửa độc lập chạy song song; gỡ skill `swarm` khỏi gợi ý tự động |

Chưa kiểm chứng: nội dung thô các trang `antigravity.google/docs/*.md` (phiên sandbox không đọc được URL; nguồn dựa trên `search_web` và changelog nhúng trong binary), danh sách custom agent (`agy agents` bị sandbox chặn), kết nối thật của MCP Chrome DevTools, và liệu bộ tool khác nhau ở bề mặt IDE/App 2.0. Menu `/` đã đọc từ một phiên (hydrogen), chưa so với bề mặt IDE/App và còn hai mục cuối chưa thấy.
