# Cẩm Nang Tools, MCP, Plugins, Skills & Agents Của OpenCode

> **Tài liệu tham khảo kỹ thuật cho nhóm phát triển (Team-Facing Documentation)**
> *Vị trí lưu trữ*: `docs/tools/opencode/README.md`
> *Phạm vi*: capability surface của OpenCode, đối chiếu runtime cục bộ `1.18.30`
> với tài liệu chính thức.

Tài liệu này là bản tương ứng cho OpenCode của [cẩm nang Codex](../codex/README.md)
và [cẩm nang Antigravity](../antigravity/README.md). Nó giúp team chọn đúng
built-in tool, MCP server, plugin, skill và agent cho từng loại công việc.

> [!IMPORTANT]
> Runtime/session hiện tại là source of truth. Danh sách tool, MCP, plugin,
> agent và kết nối thay đổi theo phiên, workspace, cấu hình, permission và
> provider. Việc một capability được tài liệu mô tả hoặc được khai báo trong
> `opencode.json` không chứng minh rằng server/account đã được kết nối, xác
> thực hoặc được phép sử dụng.

---

## 1. Tổng Quan Kiến Trúc OpenCode

OpenCode kết hợp model reasoning với các lớp capability khác nhau:

- **Built-in tools**: đọc/ghi file, chạy lệnh, tìm kiếm, web, hỏi người dùng.
- **Custom tools**: hàm do config hoặc plugin định nghĩa, gọi chung namespace
  với built-in.
- **MCP servers (local/remote)**: tool của dịch vụ ngoài, expose dưới prefix
  `<server>_*`.
- **Plugins**: module JS/TS hook vào lifecycle event, thêm tool hoặc đổi hành
  vi mặc định.
- **Skills**: `SKILL.md` nạp theo nhu cầu qua `skill` tool.
- **Agents**: primary agent (`build`, `plan`) và subagent (`general`,
  `explore`, `scout`), cấu hình bằng JSON hoặc Markdown.
- **Rules và config**: `AGENTS.md`, `opencode.json`, permission, provider,
  instruction files.
- **CLI/TUI/Server**: `opencode`, `opencode run`, `opencode serve`,
  `opencode web`, `opencode mcp`, `opencode agent`.

```text
+-----------------------------------------------------------------------------------+
|                               OpenCode Runtime                                    |
+-----------------------------------------------------------------------------------+
| Built-in tools        | MCP servers          | Plugins & Skills   | Agents        |
| - bash / read         | - local / remote     | - hooks, custom    | - build/plan  |
| - edit / write        | - OAuth / headers    |   tools            | - general     |
| - grep / glob / lsp   | - <server>_* tools   | - plugin dirs /    | - explore     |
| - webfetch/websearch  | - tools{} gating     |   npm packages     | - scout       |
| - skill / task / ...  |                      | - SKILL.md routing | - custom      |
+-----------------------------------------------------------------------------------+
```

### 1.1 Quy tắc phân biệt các lớp

| Khái niệm | Vai trò | Cách xác nhận |
| :--- | :--- | :--- |
| **Built-in tool** | Một hàm cụ thể OpenCode cung cấp, ví dụ `bash` hoặc `edit`. | Tên và schema được expose trong session. |
| **Custom tool** | Hàm do config/plugin định nghĩa. | Tool definition trong config/plugin; tên trùng built-in thì custom thắng. |
| **MCP server** | Tiến trình local/remote cung cấp một nhóm tool dưới `<server>_*`. | `opencode mcp list` cộng với tool schema gọi được. |
| **Plugin** | Module hook event hoặc thêm tool. | Thư mục plugin, `plugin` config, npm package; hiệu ứng hook quan sát được. |
| **Skill** | Quy trình `SKILL.md` nạp theo trigger. | Entry trong `<available_skills>` và nội dung nạp qua `skill` tool. |
| **Agent** | Persona primary/subagent với model, prompt, permission riêng. | Agent hiển thị/chọn được trong session hoặc gọi qua `task`. |
| **Rule/instruction** | `AGENTS.md` và instruction file luôn hoặc chủ động nạp. | `instructions` config; nội dung xuất hiện trong context. |

---

## 2. Built-in Tools

Trang Tools chính thức liệt kê 13 built-in. Phiên worker OpenCode `1.18.30` đã
kiểm chứng expose: `bash`, `edit`, `write`, `read`, `grep`, `glob`, `task`,
`todowrite`, `webfetch`, `websearch`, `skill`, `question`. Hai tool có trong
tài liệu nhưng không xuất hiện trong phiên đó là `lsp` (experimental) và
`apply_patch`; nguyên nhân chưa xác minh. Session hiện tại vẫn là nguồn quyết
định cuối cùng về tool nào thực sự gọi được.

### 2.1 Filesystem, code và code intelligence

| Tên tool | Chức năng | Use cases |
| :--- | :--- | :--- |
| **`bash`** | Chạy lệnh shell trong môi trường project. | Build, test, lint, git, kiểm tra trạng thái trong phạm vi được authorize. |
| **`read`** | Đọc nội dung file, hỗ trợ đọc theo dải dòng. | Khảo sát code, config, tài liệu; tránh dump file lớn. |
| **`edit`** | Sửa file bằng thay thế chuỗi chính xác. | Cách chỉnh sửa chính của LLM; thay đổi nhỏ, có kiểm soát. |
| **`write`** | Tạo file mới hoặc ghi đè file. | Tạo module, tài liệu, file cấu hình; ghi đè cần cẩn trọng. |
| **`apply_patch`** | Áp patch/diff vào codebase. | Nhận patch từ nguồn ngoài; path nằm trong marker line của patch. |
| **`grep`** | Tìm nội dung bằng regex, có filter theo file pattern. | Tìm định nghĩa hàm, import, chuỗi cấu hình trên toàn repo. |
| **`glob`** | Tìm file theo glob pattern, sort theo thời gian sửa. | Khám phá layout, tìm file theo tên/đuôi trước khi đọc sâu. |
| **`lsp`** *(experimental)* | Code intelligence: definition, references, hover, symbols, call hierarchy. | Refactor và điều hướng code khi LSP project được cấu hình. |

Ghi chú: `grep`/`glob` dùng ripgrep và tôn trọng `.gitignore`; file `.ignore` ở
project root có thể re-include path bị ignore. `write`, `edit`, `apply_patch`
cùng chịu permission key `edit`. `lsp` chỉ khả dụng khi bật
`OPENCODE_EXPERIMENTAL_LSP_TOOL=true` (hoặc `OPENCODE_EXPERIMENTAL=true`).

### 2.2 Workflow, agent và tương tác người dùng

| Tên tool | Chức năng | Use cases |
| :--- | :--- | :--- |
| **`skill`** | Nạp nội dung `SKILL.md` vào hội thoại. | Kích hoạt quy trình chuyên biệt theo trigger của skill. |
| **`todowrite`** | Tạo/cập nhật todo list trong phiên. | Theo dõi task nhiều bước; mặc định tắt với subagent. |
| **`task`** | Gọi subagent cho một đơn vị công việc. | Ủy thác khảo sát độc lập, đọc tài liệu dài, write set không giao nhau. |
| **`question`** | Hỏi người dùng trong lúc thực thi. | Làm rõ yêu cầu mơ hồ, chọn phương án thiết kế, xác nhận quyết định. |

Ghi chú: `task` được mô tả qua trang Agents (Task tool) và permission key
`task`; trang Tools không liệt kê riêng. Permission key `list` cũng xuất hiện
trong tài liệu nhưng tool `list` không nằm trong catalog Tools — xác nhận ở
runtime trước khi dựa vào.

### 2.3 Web

| Tên tool | Chức năng | Use cases |
| :--- | :--- | :--- |
| **`webfetch`** | Tải nội dung một URL và chuyển thành markdown/text/html. | Đọc tài liệu chính thức, spec, bài viết khi đã biết URL. |
| **`websearch`** | Tìm kiếm web real-time qua backend hosted MCP. | Discovery thông tin mới; dùng `webfetch` khi cần retrieval. |

`websearch` là **provider-gated**: chỉ khả dụng khi dùng provider OpenCode hoặc
OpenCode Go, hoặc khi đặt `OPENCODE_ENABLE_EXA` / `OPENCODE_ENABLE_PARALLEL` thành
giá trị truthy. Phiên worker tham chiếu chạy provider OpenCode Go
(`opencode-go/deepseek-v4.1-flash`, effort `max`) và đã expose `websearch`.

---

## 3. Permission & Gating

Mặc định OpenCode cho phép mọi thao tác không cần approval. `permission` trong
`opencode.json` chỉnh điều đó với ba mức: `allow`, `ask`, `deny`.

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "edit": "deny",
    "bash": "ask",
    "webfetch": "allow",
    "mymcp_*": "ask"
  }
}
```

| Permission key | Gate tool |
| :--- | :--- |
| `read` | `read` |
| `edit` | `write`, `edit`, `apply_patch` |
| `glob` | `glob` |
| `grep` | `grep` |
| `list` | `list` (theo tài liệu permission) |
| `bash` | `bash`, hỗ trợ glob theo từng lệnh |
| `task` | `task` (subagent invocation) |
| `external_directory` | Mọi tool đọc/ghi ngoài project worktree |
| `todowrite` | `todowrite`, `todoread` |
| `webfetch` | `webfetch` |
| `websearch` | `websearch` |
| `lsp` | `lsp` |
| `skill` | `skill` |
| `question` | `question` |
| `doom_loop` | Recovery prompt khi agent có dấu hiệu bị kẹt |

`read`, `edit`, `glob`, `grep`, `list`, `bash`, `task`, `external_directory`,
`lsp`, `skill` nhận object pattern → action (fine-grained); các key còn lại chỉ
nhận shorthand. MCP server bị gate theo glob, ví dụ `"mymcp_*": "deny"` tắt cả
server, `"mymcp_search": "ask"` chỉ một tool.

```jsonc
{
  "agent": {
    "review": {
      "permission": {
        "edit": "deny",
        "bash": { "*": "ask", "git diff": "allow", "grep *": "allow" }
      }
    }
  }
}
```

---

## 4. MCP Servers

### 4.1 Cấu hình

Khai báo trong `opencode.json` dưới key `mcp`, mỗi server một tên duy nhất.
OpenCode hỗ trợ hai loại:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "my-local-mcp": {
      "type": "local",
      "command": ["npx", "-y", "my-mcp-command"],
      "cwd": ".",
      "environment": { "MY_ENV_VAR": "value" },
      "enabled": true,
      "timeout": 5000
    },
    "my-remote-mcp": {
      "type": "remote",
      "url": "https://my-mcp-server.com",
      "headers": { "Authorization": "Bearer {env:MY_API_KEY}" },
      "enabled": true
    }
  }
}
```

- **Local**: `command` (bắt buộc), `cwd`, `environment`, `enabled`, `timeout`
  (mặc định 5000 ms khi fetch tool).
- **Remote**: `url` (bắt buộc), `headers`, `oauth`, `enabled`, `timeout`.
- Có thể tạm tắt một server bằng `"enabled": false` mà không xóa config.
- Remote config của tổ chức (`.well-known/opencode`) có thể cung cấp default bị
  tắt; local config có thể bật lại với `enabled: true`.

MCP tool được đăng ký với prefix tên server, nên gọi tự nhiên trong prompt
(`use the mcp_everything tool ...`) hoặc tắt bằng `tools`:

```jsonc
{ "tools": { "my-mcp*": false } }
```

Với nhiều server, có thể tắt toàn cục rồi bật theo agent qua `agent.<name>.tools`.

### 4.2 OAuth và xác thực

Remote server yêu cầu auth sẽ trả 401; OpenCode tự chạy OAuth flow (hỗ trợ
Dynamic Client Registration RFC 7591) và lưu token tại
`~/.local/share/opencode/mcp-auth.json`. Có thể cấu hình client credentials
(`clientId`, `clientSecret`, `scope`) hoặc tắt auto-OAuth bằng `"oauth": false`
cho server dùng API key qua header.

### 4.3 Discovery và quản lý

Bề mặt CLI đã kiểm chứng trên `1.18.30`:

```text
opencode mcp add [name]     add an MCP server
opencode mcp list           list MCP servers and their status   (alias: ls)
opencode mcp auth [name]    authenticate with an OAuth-enabled MCP server
opencode mcp logout [name]  remove OAuth credentials for an MCP server
opencode mcp debug <name>   debug OAuth connection for an MCP server
```

Tài liệu mới hơn có nhắc `opencode mcp auth list` trong mục debugging; trên
`1.18.30` hãy dùng `opencode mcp list` để xem trạng thái và `opencode mcp auth
<name>` để xác thực. `mcp add`, `mcp auth`, `mcp logout` đều là mutation; chỉ
chạy khi có authority.

**Connection ladder** — không được nhảy bậc khi báo cáo:

```text
Server được cấu hình
    ↓
Server khởi động / reachable
    ↓
Account/server đã xác thực (OAuth hoặc header hợp lệ)
    ↓
Tool được permission cho phép
    ↓
Hành động được User authorize
```

Agent chỉ claim thành công ở mức cuối khi tool response chứng minh. Nếu thiếu
một tầng, báo rõ tầng thiếu và đề xuất bước nhỏ nhất (ví dụ `opencode mcp auth
<name>` hoặc bật `enabled: true`).

### 4.4 Trạng thái cục bộ

Phiên `1.18.30` đã chạy `opencode mcp list` và nhận `No MCP servers
configured` với gợi ý `opencode mcp add`. Đây là trạng thái của máy tham chiếu,
không phải giới hạn của OpenCode.

---

## 5. Plugins

### 5.1 Cách plugin được nạp

Plugin là module JS/TS export một hoặc nhiều plugin function, nhận context
(`project`, `directory`, `worktree`, `client`, `$`) và trả về object hooks.

| Nguồn | Vị trí | Ghi chú |
| :--- | :--- | :--- |
| Local project | `.opencode/plugins/` | Tự nạp lúc startup. |
| Local global | `~/.config/opencode/plugins/` | Tự nạp lúc startup. |
| npm package | Key `plugin` trong `opencode.json` | Cài tự động bằng Bun, cache tại `~/.cache/opencode/node_modules/`. |

Thứ tự load: global config → project config → global plugin dir → project
plugin dir. npm package trùng tên/phiên bản chỉ nạp một lần; local plugin và
npm plugin cùng tên vẫn nạp riêng.

Plugin local/custom tool cần package ngoài thì thêm `.opencode/package.json`;
OpenCode chạy `bun install` lúc startup.

### 5.2 Khả năng của plugin

- **Hooks**: `tool.execute.before/after`, `shell.env`, `file.edited`,
  `permission.asked/replied`, `session.*`, `message.*`, `todo.updated`,
  `tui.*`, `lsp.*`, và hook experimental `experimental.session.compacting`.
- **Custom tools**: định nghĩa tool mới qua helper `tool` với Zod schema; tool
  plugin trùng tên built-in sẽ **ghi đè** built-in.
- **Logging**: dùng `client.app.log()` cho structured log thay vì
  `console.log`.

### 5.3 Ranh giới CLI trên `1.18.30`

`opencode plugin --help` cục bộ chỉ expose một dạng lệnh:

```text
opencode plugin <module>    install plugin and update config
      -g, --global          install in global config
      -f, --force           replace existing plugin version
```

Đây là lệnh **mutation cấu hình**. Không có subcommand `list`, và trên
`1.18.30` chạy `opencode plugin list` sẽ khiến `list` bị hiểu là tên module để
cài. Discovery plugin phải đọc config/thư mục plugin, không dùng lệnh install
làm phép thử.

---

## 6. Skills

### 6.1 Vị trí nạp

Mỗi skill là một thư mục chứa `SKILL.md`:

| Phạm vi | Đường dẫn |
| :--- | :--- |
| Project config | `.opencode/skills/<name>/SKILL.md` |
| Project Claude-compatible | `.claude/skills/<name>/SKILL.md` |
| Project agent-compatible | `.agents/skills/<name>/SKILL.md` |
| Global config | `~/.config/opencode/skills/<name>/SKILL.md` |
| Global Claude-compatible | `~/.claude/skills/<name>/SKILL.md` |
| Global agent-compatible | `~/.agents/skills/<name>/SKILL.md` |

Repo Harness này đặt skill tại `.agents/skills/`, nằm trong nhóm
agent-compatible mà OpenCode quét. Với project-local path, OpenCode đi ngược từ
cwd lên tới git worktree và nạp mọi `skills/*/SKILL.md` khớp.

### 6.2 Frontmatter và validation

Chỉ các field sau được nhận: `name` (bắt buộc), `description` (bắt buộc),
`license`, `compatibility`, `metadata`; field lạ bị bỏ qua.

- `name`: 1–64 ký tự, lowercase alphanumeric với hyphen đơn, không bắt đầu/kết
  thúc bằng `-`, không có `--`, và phải khớp tên thư mục. Regex tương đương:
  `^[a-z0-9]+(-[a-z0-9]+)*$`.
- `description`: 1–1024 ký tự; phải đủ cụ thể để agent chọn đúng skill.

Skill được liệt kê trong mô tả của `skill` tool (`<available_skills>`); agent
nạp nội dung bằng `skill({ name: "<name>" })`.

### 6.3 Permission cho skill

```jsonc
{
  "permission": {
    "skill": { "*": "allow", "internal-*": "deny", "experimental-*": "ask" }
  }
}
```

Có thể override theo agent (frontmatter agent hoặc `agent.<name>.permission`) và
tắt hẳn `skill` tool cho một agent; khi tắt, mục `<available_skills>` biến mất.
Nếu skill không hiện: kiểm tra `SKILL.md` viết hoa đúng, frontmatter có đủ
`name`/`description`, tên không trùng giữa các location, và permission không
`deny`.

---

## 7. Agents & Subagents

### 7.1 Phân loại

| Nhóm | Agent | Vai trò |
| :--- | :--- | :--- |
| Primary | `build` | Mặc định, đầy đủ tool cho phát triển. |
| Primary | `plan` | Restricted: edit và bash mặc định `ask`; dùng để phân tích, lập kế hoạch. |
| Subagent | `general` | Task đa bước, full tool trừ todo; chạy song song được. |
| Subagent | `explore` | Read-only, khảo sát codebase nhanh. |
| Subagent | `scout` | Read-only, research docs/dependency ngoài. |
| Ẩn (system) | `compaction`, `title`, `summary` | Chạy tự động, không chọn trong UI. |

Chuyển primary agent bằng **Tab**; gọi subagent bằng **@ mention** (ví dụ
`@general ...`) hoặc để primary agent tự gọi qua Task tool. `subagent_depth`
mặc định `1` (subagent không gọi tiếp subagent); đặt `2` cho thêm một tầng,
`0` để cấm hoàn toàn.

### 7.2 Cấu hình

Agent định nghĩa bằng JSON trong `opencode.json` hoặc Markdown trong
`.opencode/agents/` / `~/.config/opencode/agents/` (tên file thành tên agent).

```markdown
---
description: Reviews code for quality and best practices
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
permission:
  edit: deny
  bash: deny
---
You are in code review mode...
```

Các option chính: `description` (bắt buộc), `mode`
(`primary|subagent|all`), `model`, `prompt`, `temperature`, `top_p`, `steps`
(`maxSteps` deprecated), `disable`, `hidden` (ẩn khỏi @ menu nhưng vẫn gọi được
qua Task), `permission`, `color`, và các option provider-specific truyền thẳng
xuống model. `opencode agent create` tạo agent qua wizard — đây là mutation,
cần authority.

`permission.task` giới hạn subagent mà một agent được gọi, dùng glob và rule
cuối cùng thắng:

```jsonc
{
  "agent": {
    "orchestrator": {
      "permission": {
        "task": { "*": "deny", "orchestrator-*": "allow", "code-reviewer": "ask" }
      }
    }
  }
}
```

User luôn có thể @ mention subagent trực tiếp kể cả khi `task` permission chặn.

---

## 8. CLI & Runtime Checks

### 8.1 Đã kiểm chứng cục bộ trên `1.18.30`

| Lệnh | Kết quả quan sát | Ý nghĩa |
| :--- | :--- | :--- |
| `opencode --version` | `1.18.30` | Phiên bản runtime tham chiếu. |
| `opencode mcp list` | `No MCP servers configured` | Không có MCP server nào được cấu hình trên máy này. |
| `opencode mcp --help` | `add`, `list`, `auth [name]`, `logout [name]`, `debug <name>` | Bề mặt quản lý MCP hiện có. |
| `opencode plugin --help` | Chỉ `plugin <module>` (+ `-g`, `-f`) | Không có subcommand `list`; install là mutation. |
| `opencode --help` | Command list gồm `run`, `serve`, `web`, `models`, `agent`, `debug`, `session`, ... | Bề mặt CLI chính. |

### 8.2 Tài liệu mô tả (chưa chạy trong task này)

| Lệnh | Loại | Ghi chú |
| :--- | :--- | :--- |
| `opencode models [provider]` | Read-only | Liệt kê model khả dụng. |
| `opencode debug config` | Read-only | Xem config đã resolve, gồm managed setting. |
| `opencode run [message..]` | Tùy prompt | Chạy không giao diện; side effect theo prompt. |
| `opencode serve` / `opencode web` | Mở server | Headless server / web UI. |
| `opencode mcp auth <name>` | Mutation credential | Chỉ chạy khi cần và có authority. |
| `opencode mcp add` | Mutation config | Thêm server; cần authority. |
| `opencode agent create` | Mutation config | Tạo agent file; cần authority. |
| `opencode plugin <module>` | Mutation config + cài đặt | Cài plugin; cần authority. |
| `opencode upgrade` | Mutation hệ thống | Không chạy trong task tài liệu. |

Đừng dùng lệnh cài đặt/cấu hình như phép dò capability. Discovery đọc config,
thư mục plugin, `<available_skills>` và `opencode mcp list`.

---

## 9. Workflow Chọn Capability Chuẩn

### Phase 1 — Phân loại task

| Loại task | Capability ưu tiên |
| :--- | :--- |
| Đọc/search/sửa file | `read`, `grep`, `glob`, `edit`, `write`, `apply_patch` (nếu expose) |
| Chạy lệnh/build/test/git | `bash` trong phạm vi được authorize |
| Code intelligence | `lsp` khi experimental được bật |
| Fact/version/spec hiện tại | `webfetch` (URL đã biết), `websearch` (discovery, provider-gated) |
| Task nhiều bước | `todowrite` |
| Ủy thác độc lập | `task` với write set và stop condition rõ ràng |
| Làm rõ yêu cầu | `question` |
| Quy trình chuyên biệt | `skill` |
| Dịch vụ ngoài | MCP tool từ server đã cấu hình và xác thực |
| Hook/tự động hóa | Plugin JS/TS |

### Phase 2 — Mandatory declaration

Khi `utilizing-tools-opencode` được trigger, mở đầu response bằng bảng:

```markdown
### Selected OpenCode Capabilities
| Tool / MCP / Plugin / Skill / Agent | Purpose in this task | Target scope |
| :--- | :--- | :--- |
| `read` | Inspect existing docs and skill patterns | `docs/tools/`, `.agents/skills/` |
| `write` | Persist the authorized documentation | Named repository paths only |
| `writing-for-agents` | Review skill structure and completion criteria | New `SKILL.md` |
```

Không liệt kê toàn bộ catalog nếu task chỉ cần một subset nhỏ.

### Phase 3 — Execute và verify

1. Kiểm tra target, connection, permission trước khi hành động.
2. Chỉ thực thi capability đã khai báo, trong phạm vi authority.
3. Verify bằng proof quan sát được: tool response, diff, output lệnh, artifact.
4. Report changed paths, external side effect, kết quả validation và check chưa
   chạy.

---

## 10. Guardrails & Anti-Patterns

- **User Authority**: theo `AGENTS.md`; read-only là mặc định cho điều tra.
  Mutation file, cài plugin, thêm MCP, đổi permission, build/test ngoài scope
  cần authority đúng target.
- **Không đoán capability**: không tự tạo tên tool, prefix MCP, trạng thái
  plugin/auth, opaque ID hay permission state.
- **Connection không phải availability**: server được cấu hình chưa chắc đã
  reachable, xác thực hoặc được phép.
- **Ưu tiên native tool**: chỉ dùng MCP/plugin khi nó tạo giá trị mà built-in
  không có.
- **Không dùng lệnh install làm discovery**: đặc biệt `opencode plugin list`
  trên `1.18.30` (bị hiểu là module) và mọi lệnh `plugin <module>`.
- **Không claim completion sớm**: một tool call thành công chưa phải proof;
  phải đọc result và kiểm tra điều kiện hoàn thành.
- **Không vượt scope external**: thay đổi config toàn cục, credentials,
  provider account là boundary riêng.

---

## 11. Completion Contract

Một task dùng capability OpenCode chỉ được báo hoàn tất khi:

- capability được chọn phù hợp task và khai báo trước execution;
- mọi mục trong bảng khai báo có lý do và target scope rõ ràng;
- kết quả chính có proof quan sát được;
- file/path hoặc external state đã thay đổi được liệt kê;
- validation đã chạy được báo pass/fail, check chưa authorize báo `unattempted`;
- khoảng trống connection/auth hoặc quyết định còn thiếu được nêu kèm bước xử
  lý nhỏ nhất.

---

## 12. Nguồn Chính Thức & Ranh Giới Phiên Bản

Tài liệu chính thức đã đối chiếu (truy cập 2026-09-13):

- [Tools](https://opencode.ai/docs/tools/)
- [MCP servers](https://opencode.ai/docs/mcp-servers/)
- [Plugins](https://opencode.ai/docs/plugins/)
- [Agent Skills](https://opencode.ai/docs/skills)
- [Agents](https://opencode.ai/docs/agents)
- [Config](https://opencode.ai/docs/config/)

Phân loại độ tin cậy của các claim trong tài liệu này:

| Hạng mục | Nguồn | Trạng thái |
| :--- | :--- | :--- |
| Version `1.18.30`, `mcp list` trống, `mcp` subcommands, `plugin --help` chỉ có `<module>` | Local CLI output | [LOCAL] đã kiểm chứng |
| Catalog built-in tool, permission key, MCP config/OAuth, plugin loading, skill discovery, agent types | Official docs (2026-09-13) | [DOCS] |
| `apply_patch` và `lsp` không xuất hiện trong phiên worker tham chiếu | Session tool list | [UNKNOWN] lý do chưa xác minh |
| Đề xuất dùng `opencode mcp list` thay `mcp auth list` trên `1.18.30` | Suy luận từ local help vs docs | [INFERENCE] |

Khi local CLI và tài liệu mới hơn xung đột ở mức làm thay đổi thiết kế task,
dừng lại báo User thay vì tự chọn một phía. Đây là cẩm nang team-facing; quyền
hạn thực tế, tool schema và trạng thái kết nối của từng phiên phải được kiểm
tra tại runtime trước khi thực thi.
