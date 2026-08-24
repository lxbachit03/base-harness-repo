# Cẩm Nang Tools, MCP, Plugins & Skills của Codex

> **Tài liệu tham khảo kỹ thuật cho nhóm phát triển (Team-Facing Documentation)**
> *Vị trí lưu trữ*: `docs/tools/codex/README.md`
> *Phạm vi*: capability surface của Codex được expose trong runtime hiện tại.

Tài liệu này là bản tương ứng cho Codex của [cẩm nang Antigravity](../antigravity/README.md).
Nó giúp team chọn đúng công cụ, MCP, plugin và skill cho từng loại công việc.

> [!IMPORTANT]
> Danh sách tool và kết nối có thể thay đổi theo phiên, workspace, tài khoản,
> permission và plugin release. Runtime/session hiện tại là source of truth.
> Việc một tool xuất hiện trong danh sách không chứng minh rằng account,
> document session, site project hoặc quyền ghi đã được kết nối.

---

## 1. Tổng Quan Kiến Trúc Codex

Codex kết hợp model reasoning với các lớp capability khác nhau:

- **Built-in tools**: đọc/ghi file, chạy lệnh, web, hình ảnh, JavaScript và
  điều phối subagent.
- **MCP servers và Codex Apps**: kết nối tới Sites, document sessions,
  plugin management và các app-specific operation.
- **Plugins**: gói skill, MCP/app connector và metadata/UI tùy chọn.
- **Skills**: hướng dẫn quy trình chuyên biệt được tải theo trigger.
- **Repository instructions**: `AGENTS.md`, `docs-harness/` và các skill trong
  `.agents/skills/` định nghĩa governance, routing và authority của repo.

```text
+-----------------------------------------------------------------------------------+
|                                Codex Runtime                                      |
+-----------------------------------------------------------------------------------+
| Built-in tools      | MCP / Codex Apps       | Plugins & Skills | Agent workflow   |
| - shell / patch     | - codex_apps           | - Browser        | - goal / plan    |
| - web / image       | - node_repl            | - Sites          | - subagents      |
| - local image       | - connected sessions  | - Documents      | - AGENTS.md      |
| - JavaScript        | - app permissions     | - PDF / Slides   | - Harness route  |
+-----------------------------------------------------------------------------------+
```

### 1.1 Quy tắc phân biệt các lớp

| Khái niệm | Vai trò | Cách xác nhận |
| :--- | :--- | :--- |
| **Tool** | Một hàm cụ thể có thể gọi trong phiên, ví dụ `shell_command`. | Tên và schema được expose trong runtime. |
| **MCP server** | Lớp giao thức cung cấp một nhóm tool/resource cho model. | Namespace MCP và kết quả introspection. |
| **Codex App** | Kết nối app/service phía sau một nhóm MCP tool. | Connection/session/permission state của app. |
| **Plugin** | Gói reusable skills, MCP/app connector và metadata tùy chọn. | Plugin manifest hoặc resource registry. |
| **Skill** | Hướng dẫn agent chọn và dùng capability theo một workflow. | `SKILL.md` và trigger của skill. |

---

## 2. Built-in Tools

Runtime snapshot hiện tại expose 56 nested tools. Bảng dưới nhóm theo mục đích
để chọn capability, không phải thứ tự gọi bắt buộc.

### 2.1 Filesystem, code và visual inspection

| Tên tool | Chức năng | Use cases |
| :--- | :--- | :--- |
| **`shell_command`** | Chạy PowerShell trong workspace/runtime. | Đọc tree, tìm file, kiểm tra trạng thái, chạy lệnh đã được User authorize. |
| **`apply_patch`** | Tạo hoặc chỉnh sửa file bằng patch có kiểm soát. | Sửa skill, docs, code hoặc cấu hình trong phạm vi được User cho phép. |
| **`view_image`** | Đọc và xem ảnh local. | QA screenshot, kiểm tra asset hoặc ảnh tham chiếu. |

### 2.2 Web và image generation

| Tên tool | Chức năng | Use cases |
| :--- | :--- | :--- |
| **`web__run`** | Search/open/fetch web, screenshot và các lookup được hỗ trợ. | Tài liệu/version/spec/current facts; ưu tiên nguồn chính thức khi phù hợp. |
| **`image_gen__imagegen`** | Tạo ảnh raster mới hoặc chỉnh sửa ảnh tham chiếu. | Mockup, illustration, texture, visual asset và biến thể ảnh. |

### 2.3 JavaScript runtime qua MCP

| Tên tool | Chức năng | Use cases |
| :--- | :--- | :--- |
| **`mcp__node_repl__js`** | Chạy JavaScript trong kernel persistent. | Phân tích dữ liệu, thử nghiệm API, xử lý artifact khi skill yêu cầu. |
| **`mcp__node_repl__js_add_node_module_dir`** | Thêm thư mục module vào kernel. | Nạp package do skill cung cấp trước khi import. |
| **`mcp__node_repl__js_reset`** | Reset kernel persistent. | Dọn state khi session bị nhiễm binding hoặc cần môi trường sạch. |

### 2.4 Multi-agent orchestration

| Tên tool | Chức năng | Use cases |
| :--- | :--- | :--- |
| **`multi_agent_v1__spawn_agent`** | Tạo subagent cho một task bounded. | Khảo sát độc lập, đọc tài liệu dài, xử lý các write set không giao nhau. |
| **`multi_agent_v1__wait_agent`** | Chờ kết quả subagent khi critical path cần nó. | Lấy evidence hoặc artifact cần cho bước tiếp theo. |
| **`multi_agent_v1__send_input`** | Gửi hướng dẫn bổ sung cho subagent. | Làm rõ scope, yêu cầu evidence hoặc recovery instruction. |
| **`multi_agent_v1__resume_agent`** | Tiếp tục subagent đã tạm dừng. | Khôi phục một nhánh công việc còn hợp lệ. |
| **`multi_agent_v1__close_agent`** | Đóng subagent. | Kết thúc nhánh đã xong hoặc không còn cần thiết. |

### 2.5 Goals, plans và MCP resource introspection

| Tên tool | Chức năng | Use cases |
| :--- | :--- | :--- |
| **`create_goal`** | Tạo autonomous goal state. | Chỉ dùng khi User yêu cầu rõ việc tạo/set goal. |
| **`get_goal`** | Đọc goal hiện tại, budget và trạng thái. | Kiểm tra situational awareness trước khi tiếp tục goal. |
| **`update_goal`** | Đánh dấu goal `complete` hoặc `blocked`. | Chỉ đóng goal khi proof đạt hoặc blocker lặp lại đúng điều kiện. |
| **`update_plan`** | Cập nhật ephemeral execution plan. | Theo dõi các bước phụ thuộc trong task nhiều giai đoạn. |
| **`list_mcp_resources`** | Liệt kê resources từ MCP servers. | Xác định resource/plugin bundle khả dụng. |
| **`list_mcp_resource_templates`** | Liệt kê resource templates. | Tìm resource có tham số do MCP cung cấp. |
| **`read_mcp_resource`** | Đọc resource đã được xác định. | Nạp metadata hoặc tài liệu MCP cụ thể. |

`functions.exec` là lớp điều phối để gọi nested tools; `functions.wait` dùng để
tiếp tục một execution đang yield. Đây là runtime envelope, không phải một
plugin riêng.

---

## 3. MCP Servers & Codex Apps

### 3.1 `codex_apps`

Namespace `mcp__codex_apps__*` hiện expose 36 tool, chia thành các nhóm sau.

#### Sites — 23 tools

Sites dùng cho việc build, save, deploy và inspect website. Các nhóm operation
hiện có:

- Tạo site và source repository.
- Save/deploy site version, gồm private deployment.
- Theo dõi deployment status và worker logs.
- Đọc site, site version và danh sách site/version.
- Quản lý custom domain và trạng thái domain.
- Đọc/cập nhật environment variables.
- Cập nhật site metadata và access control.
- Đọc database overview và rows của site.
- Tạo SIWC bypass token khi workflow hosting yêu cầu.

Tool family tương ứng bắt đầu bằng:

```text
mcp__codex_apps__sites_*
```

**Guardrail:** đọc `.openai/hosting.json` trước khi thao tác nếu file tồn tại;
giữ nguyên các opaque ID, project ID và commit SHA từ configuration/tool
response; deploy chỉ khi User đã authorize scope external state.

#### Document Control — 3 tools

Document Control làm việc với session Excel, PowerPoint hoặc Google Sheets đã
kết nối:

1. `mcp__codex_apps__codex_document_control_list_document_sessions`
2. `mcp__codex_apps__codex_document_control_get_docum_83c7f0565c0f`
3. `mcp__codex_apps__codex_document_control_execute_d_7437ad2e4ffa`

Luôn discovery session trước, lấy schema của tool kế tiếp sau, rồi mới execute
với `executor_session_id`, `tool_name`, arguments đúng schema và
`idempotency_key` ổn định.

#### Plugin Management — 4 tools

- `mcp__codex_apps__plugin_management_get_app_permissions`
- `mcp__codex_apps__plugin_management_get_plugin_dependencies`
- `mcp__codex_apps__plugin_management_uninstall_app`
- `mcp__codex_apps__plugin_management_update_app_permissions`

Chỉ inspect một plugin được User nêu rõ. Uninstall hoặc đổi permission là
mutation external và cần yêu cầu User rõ ràng, không suy diễn từ việc User hỏi
về danh sách plugin.

#### Safety settings — 5 tools

Nhóm `mcp__codex_apps__safety_settings_*` hỗ trợ đọc/chuẩn bị/cập nhật
parental controls và trusted contact. Đọc state trước; update chỉ tiếp tục khi
connector xác nhận đúng boundary và User đã approve thay đổi cụ thể.

#### Local hotline — 1 tool

`mcp__codex_apps__hotline_get_local_hotline` dùng để tra cứu hotline theo quốc
gia được suy ra từ hội thoại. Không tự đoán số hotline.

### 3.2 `node_repl`

`mcp__node_repl__*` là MCP-backed persistent JavaScript runtime. Nó phù hợp
cho xử lý dữ liệu hoặc script nhỏ, nhưng state persistent phải được quản lý
chủ động; dùng reset khi state cũ có thể ảnh hưởng proof.

### 3.3 Connection state không đồng nghĩa tool availability

Các trạng thái cần phân biệt:

```text
Tool exposed
    ↓
MCP/App connector available
    ↓
Account/session/project connected
    ↓
Permission phù hợp
    ↓
Operation được User authorize
```

Agent chỉ được claim thành công ở mức cuối khi tool response chứng minh điều
đó. Nếu thiếu một tầng, report rõ tầng còn thiếu và đề xuất bước nhỏ nhất để
User mở quyền hoặc kết nối.

---

## 4. Plugins & Skills Mapping

### 4.1 Plugin bundles hiện có

| Plugin | Capability chính |
| :--- | :--- |
| **Browser** | Điều khiển in-app browser cho local web target, navigation, inspection, interaction và screenshot. |
| **Sites** | Build, save, deploy và inspect website. |
| **Visualize** | Tạo interactive chart, map, diagram, simulation, 3D model và data explorer. |
| **Documents** | Tạo, sửa, render và verify document artifact. |
| **PDF** | Đọc, tạo, extract, render và verify PDF. |
| **Presentations** | Tạo, sửa, render và verify PowerPoint/slide deck. |
| **Spreadsheets** | Tạo, sửa, phân tích, visualize và export XLSX/CSV/TSV. |
| **Template Creator** | Tạo/cập nhật reusable template từ document, spreadsheet, presentation, image hoặc message. |
| **Plugin Management** | Tìm hiểu plugin, permission, dependency và connection state. |
| **OpenAI Templates** | Các template chuẩn cho document, presentation và spreadsheet. |

OpenAI Templates hiện có các template skill như:

- Analytics Dashboard, Financial Budget, Project Tracker, Sales Pipeline và
  Three-Statement Forecast.
- Business Review, Market Trends Report, Operating Review, Project Kickoff,
  Team Alignment, Simple Dark Mode và Simple Light Mode.
- Design Report, Experiment Analysis, Investment Committee Memo, Legal
  Memorandum, Minimal Letterhead, Strategy Memorandum và System Design.

Danh sách trên là capability mapping; skill/plugin registry của session vẫn là
nguồn quyết định việc một item có thể được invoke hay không.

### 4.2 Skill chuyên biệt theo plugin

- **`browser:control-in-app-browser`**: kiểm tra local web app hoặc in-app
  browser state.
- **`documents:documents`**, **`pdf:pdf`**, **`presentations:Presentations`**:
  tạo và QA artifact tương ứng.
- **`spreadsheets:Spreadsheets`**: làm việc với file spreadsheet độc lập;
  **`spreadsheets:excel-live-control`**: làm việc với workbook Excel đang mở
  qua connected session.
- **`sites:sites-building`**, **`sites:sites-hosting`**: local implementation
  và hosting/deployment workflow.
- **`visualize:visualize`**: tạo visual exploration hoặc interactive tool.
- **`template-creator:template-creator`**: tạo reusable artifact-template
  skill.
- **`plugin-management:plugin-management`**: route các quyết định về plugin
  và app connection.

### 4.3 Repository và system workflow skills

Các skill dưới đây cung cấp quy trình agent-level, không phải MCP server:

- **`goal-griller`**: làm rõ outcome, success condition, scope, context,
  validation và pause rules trước autonomous goal.
- **`writing-for-agents`**: thiết kế skill, `AGENTS.md`, `CLAUDE.md` và tài liệu
  agent-facing theo progressive disclosure và completion criteria.
- **`utilizing-tools-codex`**: chọn, khai báo và thực thi capability của Codex
  theo mandatory response contract.
- **`utilizing-tools-agy`**: route riêng cho Google Antigravity capability;
  không dùng để thay thế inventory Codex.
- **`prompt-leverage`**: nâng cấp raw prompt thành execution-ready contract.
- **`sequence-execution-plan`**: sắp xếp công việc có dependency, priority và
  recovery path.
- **`onboarding`**: khảo sát brownfield flow theo workspace riêng.
- **`ticket-solving`**: tổ chức và xử lý ticket trong `docs-harness/tickets/`.
- **`xia`**: nghiên cứu implementation chưa rõ, version-sensitive hoặc risky
  trước khi code.
- **`imagegen`**, **`openai-docs`**, **`plugin-creator`**,
  **`skill-creator`**, **`skill-installer`**: các workflow hệ thống tương ứng.

---

## 5. Workflow Chọn Tool Chuẩn

### Phase 1 — Phân loại task

| Loại task | Capability ưu tiên |
| :--- | :--- |
| Đọc/search/sửa file | `shell_command`, `apply_patch` |
| Fact/version/spec hiện tại | `web__run`, `openai-docs` nếu là sản phẩm OpenAI |
| Local frontend/UI QA | `browser:control-in-app-browser`, `view_image` |
| Ảnh raster | `imagegen`, `image_gen__imagegen`, `view_image` |
| DOCX/PDF/PPTX/XLSX | Plugin skill artifact tương ứng |
| Site hosting/deployment | `sites:sites-building`, `sites:sites-hosting`, `mcp__codex_apps__sites_*` |
| Connected Excel/Sheets/PowerPoint | Document Control discovery → schema → execute |
| Khảo sát độc lập | `multi_agent_v1__spawn_agent` với write set rõ ràng |
| Mục tiêu tự trị | `goal-griller`, sau đó chỉ dùng goal tool khi User yêu cầu |
| Tạo/chỉnh skill hoặc agent docs | `writing-for-agents` |

### Phase 2 — Mandatory declaration

Khi `utilizing-tools-codex` được trigger, mở đầu response bằng bảng:

```markdown
### Selected Codex Tools & MCPs
| Tool / MCP / Skill | Purpose in this task | Target scope |
| :--- | :--- | :--- |
| `shell_command` | Inspect relevant files and runtime state | `docs/tools/codex/`, `.agents/skills/` |
| `apply_patch` | Persist the authorized documentation changes | Named repository paths only |
| `writing-for-agents` | Review skill structure and completion criteria | New `SKILL.md` |
```

Không liệt kê toàn bộ catalog nếu task chỉ cần một subset nhỏ.

### Phase 3 — Execute và verify

1. Inspect target, connection và authority trước.
2. Thực thi đúng các capability đã khai báo.
3. Dùng proof phù hợp: tool response, file diff, static check, rendered artifact,
   screenshot, deployment status hoặc output có thể quan sát.
4. Report changed paths, external side effects, validation pass/fail và checks
   chưa chạy.

---

## 6. Guardrails & Anti-Patterns

- **User Authority**: read-only inspection là mặc định. File mutation,
  deploy, permission change, uninstall, build, test, lint, format, generation,
  installation, migration và package command cần User authority cho đúng scope.
- **Không đoán capability**: không tự tạo tên tool, plugin, server, session,
  account, opaque ID, cursor hoặc permission state.
- **Không nhầm connection**: tool exposed không có nghĩa account/app đã
  connected.
- **Không dùng plugin khi native tool đủ**: ưu tiên capability built-in; chỉ
  dùng external app khi nó tạo ra giá trị cần thiết.
- **Không deploy ngoài scope**: local implementation và production deployment
  là hai scope khác nhau; phải pause trước khi chuyển scope.
- **Không claim completion sớm**: một tool call thành công chưa phải proof;
  phải đọc result và kiểm tra điều kiện hoàn thành.
- **Không gọi subagent vô hạn**: mỗi subagent cần task, write set, output và
  stop condition rõ ràng.
- **Không chạy side-effecting validation ngầm**: nếu User chưa authorize
  build/test/lint/format/generation, report là `unattempted`.

---

## 7. Completion Contract

Một task dùng capability Codex chỉ được báo hoàn tất khi:

- capability được chọn phù hợp với task và được khai báo trước execution;
- mọi tool/MCP/skill được nêu trong bảng đều có lý do và target scope rõ ràng;
- kết quả chính đã có proof quan sát được;
- các file/path hoặc external state đã thay đổi được liệt kê;
- validation đã chạy được báo pass/fail, validation chưa được authorize được
  báo `unattempted`;
- blocker, connection gap hoặc User decision còn thiếu được nêu cùng đề xuất
  bước xử lý nhỏ nhất.

Đây là cẩm nang team-facing. Quyền hạn thực tế, tool schema và trạng thái kết
nối của từng phiên vẫn phải được kiểm tra tại runtime trước khi thực thi.
