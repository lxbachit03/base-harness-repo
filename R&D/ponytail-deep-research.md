# Nghiên cứu chuyên sâu (Deep Dive): `DietrichGebert/ponytail`

- **Đối tượng khảo sát:** <https://github.com/DietrichGebert/ponytail> (homepage: `ponytail.dev`)
- **Tác giả:** `DietrichGebert` (Dietrich Gebert)
- **Phiên bản phát hành mới nhất:** `v5.3.3` (phát hành `2026-10-29`, tag commit `7801d06`; tổng cộng 30 releases)
- **Commit mới nhất trên `main` tại thời điểm khảo sát:** `ebd8654` (`2026-11-22`) — `fix(hooks): decode stdin across UTF-8 chunk boundaries (#1495)` bởi `Afloat16`
- **Ngày thực hiện:** `2026-11-22`
- **Phương pháp & nguồn kiểm chứng:** Subagent `browser` (`Model: "flash"`, chế độ chỉ đọc) truy cập trực tiếp `https://github.com` và `https://raw.githubusercontent.com` (`blocked_origins: none`)

---

## 1. Metadata & Quy mô Repository

| Thuộc tính | Giá trị quan sát trực tiếp |
| :--- | :--- |
| **Mô tả** | *"Makes your AI agent think like the laziest senior dev in the room. The best code is the code you never wrote."* |
| **Topics** | `agent-skills`, `ai-agents`, `claude`, `claude-code`, `claude-code-plugin`, `cursor-rules`, `developer-tools`, `llm`, `prompt-engineering`, `yagni` |
| **Mức độ phổ biến** | `196.7k` stars · `11.1k` forks · `455` watching |
| **Hoạt động** | `145` open issues · `170` open pull requests · `129` contributors |
| **Ngôn ngữ** | JavaScript `49.5%`, Python `25.2%`, TypeScript `25.1%`, Other `0.2%` |
| **Giấy phép** | MIT (`LICENSE`) |
| **Package NPM** | `@dietrichgebert/ponytail` (`5.3.3`), **0 runtime dependencies** (`dependencies` không khai báo) |

Các commit gần nhất ghi nhận trên `main`:
- `ebd8654` (`2026-11-22`): `fix(hooks): decode stdin across UTF-8 chunk boundaries (#1495)`
- `affbac1`: `fix(band): keep readable subagent usage during partial imports (#1461)`
- `dec89d9`: `docs: add Braids to Already built with Ponytail (#1537)`

---

## 2. Triết lý & Chức năng chính (`README.md`)

**Ponytail 5** (viết lại hoàn toàn từ đầu) là bộ prompt/skill và hệ thống plugin đa nền tảng ép AI coding agent tuân thủ kỷ luật của một *"senior developer lười biếng"*.

Triết lý cốt lõi: **không** phải code-golf hay cố ép ít token nhất bằng mọi giá, mà là *"chỉ viết đúng phần code công việc thực sự cần, và không bao giờ cắt bỏ validation, xử lý lỗi, bảo mật hay accessibility. Code gọn vì đó là mức cần thiết, không phải vì bị nén chữ. Chi phí và độ trễ thấp hơn là hệ quả phụ."*

### 2.1 Mức độ cường độ (Levels)
- **3 mức hoạt động:** `lite`, `full` *(mặc định)*, `ultra`, cùng trạng thái `off`.
- **Điều khiển:** chuyển mức bằng `/ponytail [lite | full | ultra | off]`, đặt mặc định bằng `/ponytail default <mode>`, hoặc tắt nhanh bằng câu lệnh đơn lẻ `"stop ponytail"` / `"normal mode"`.

### 2.2 Bộ 6 skills / commands (`skills/`)
1. `/ponytail` — bộ quy tắc coding chính và cơ chế chuyển mức.
2. `/ponytail-review` — review diff/PR/branch theo thứ tự ưu tiên: *tính đúng đắn (correctness) → bảo mật (security) → tải (load) → thiếu test → tốc độ (speed) → code thừa (bloat)*.
3. `/ponytail-audit` — kiểm toán toàn bộ repository (lập bản đồ entry points và tải dự kiến trước khi xếp hạng phát hiện).
4. `/ponytail-debt` — quét và tổng hợp các comment đánh dấu nợ kỹ thuật có chủ đích theo cú pháp `shortcut: <limit>, <when to upgrade>` thành sổ nợ (debt ledger).
5. `/ponytail-gain` — hiển thị bảng điểm benchmark thực nghiệm (agentic scoreboard).
6. `/ponytail-help` — thẻ tra cứu nhanh.

### 2.3 Claude Code "Band" & Local Task Board (mới từ `v5.3`)
- Một dải UI nằm tại slot `AbovePrompt` trong Claude Code (`2.1.290+`) hiển thị trực tiếp theo từng task: chi phí, số token, thời gian agent hoạt động, **phần trăm tái sử dụng code (`% reuse`)**, cảnh báo caller chưa đóng khi xóa hàm (`⚠ N callers open`), và trạng thái test.
- Cung cấp nút chuyển mức nhanh, chạy review/audit, copy tóm tắt phiên dạng Markdown, hoặc mở **Task Board HTML offline** đọc từ sổ cái CSV trong `~/.config/ponytail/band/`.
- Lệnh `/ponytail band import` cho phép nạp ngược (backfill) lịch sử từ các transcript Claude Code cũ.

---

## 3. Cấu trúc thư mục & Manifests

### 3.1 Cây thư mục chính
- **Gốc repository:** `README.md`, `AGENTS.md`, `INSTALL.md`, `LICENSE`, `package.json`, `plugin.json`, `plugin.yaml`, `__init__.py`, `after-install.md`, `gemini-extension.json`, `opencode.json`.
- **Core skills (`skills/`):** `plugin.json` và 6 thư mục skill (`ponytail/`, `ponytail-review/`, `ponytail-audit/`, `ponytail-debt/`, `ponytail-gain/`, `ponytail-help/`), mỗi thư mục chứa một `SKILL.md`.
- **Adapters & thư mục plugin đa nền tảng:**
  - `.claude-plugin/` (`plugin.json`, `marketplace.json`)
  - `.codex-plugin/` (`plugin.json`)
  - `.devin-plugin/`, `.grok-plugin/`, `.kimi-plugin/`, `.qoder-plugin/`
  - `.opencode/` (`command/*.md`, `plugins/index.js`, `plugins/ponytail.mjs`, `plugins/ponytail-frontmatter.cjs`)
  - `pi-extension/` (`index.js`, `package.json`, `test/`)
  - `commands/` (`ponytail*.toml` cho Gemini / Qwen / Antigravity CLI)
  - Các bản sao rule tĩnh cho IDE: `.cursor/rules/`, `.windsurf/rules/`, `.clinerules/`, `.agents/rules/`, `.qoder/rules/`, `.kiro/steering/`, `.github/copilot-instructions.md`
  - `.openclaw/` (skills được sinh tự động cho ClawHub)
- **Hook runtime & Claude Code Band (`hooks/`):**
  - Hook manifests: `claude-codex-hooks.json`, `claude-band.json`, `copilot-hooks.json`, `cursor-hooks.json`, `qoder-hooks.json`
  - Node hooks: `ponytail-activate.js`, `ponytail-mode-tracker.js`, `ponytail-subagent.js`, `ponytail-runtime.js`, `ponytail-instructions.js`, `ponytail-config.js`, `ponytail-map.js`, `ponytail-band-import.js`
  - Statusline scripts: `ponytail-statusline.sh`, `ponytail-statusline.ps1`
  - `hooks/band/`: `register.tsx`, `metrics.ts`, `board.ts`, `logo.ts`, `types.d.ts`
- **CI, kiểm tra & scripts (`scripts/`, `tests/`, `.github/workflows/`):**
  - `.github/workflows/test.yml`, `publish.yml`
  - `scripts/`: `check-rule-copies.js`, `check-versions.js`, `build-openclaw-skills.js`, `publish-openclaw-skills.js`, `cursor-hooks.js`, `uninstall.js`
  - `tests/`: 23 file `*.test.js` / `*.test.tsx`
- **Đánh giá, ví dụ & tài liệu (`benchmarks/`, `examples/`, `docs/`, `i18n/`, `assets/`):**
  - `benchmarks/`: Promptfoo single-shot (`promptfooconfig.yaml`, `behavior.js`, `correctness.js`, `loc.js`) và `benchmarks/agentic/` (`run.py`, `tasks.py`, `judge.py`, `complete.py`, `answer.py`, `compare.py`, `README.md`) cùng 10 báo cáo trong `benchmarks/results/`
  - `examples/`: `README.md` + 11 ví dụ before/after (`csv-sum.md`, `rate-limit.md`, `email-validation.md`, ...)
  - `docs/`: `agent-portability.md`, `cursor-hooks.md`

### 3.2 Chi tiết các tệp cấu hình & CI
- **`package.json` (`@dietrichgebert/ponytail` `5.3.3`):**
  - Không có `dependencies`.
  - Exports `main`, `.`, `./plugin` trỏ tới `./.opencode/plugins/ponytail.mjs`.
  - Khai báo `"pi": { "extensions": ["./pi-extension/index.js"], "skills": ["./skills"] }`.
  - Script test: `node --test tests/*.test.js && npm test --prefix pi-extension`.
- **`.claude-plugin/plugin.json` (`5.3.3`):**
  - Đăng ký `./hooks/claude-codex-hooks.json`, `./hooks/claude-band.json` và types `./hooks/band/types.d.ts`.
  - Khai báo `userConfig`: `ledger` (boolean, mặc định `true`), `webhookUrl` (string, `""`), `webhookToken` (sensitive string lưu trong system keychain), `sendNames` (boolean, mặc định `true`).
- **`.codex-plugin/plugin.json` (`5.3.3`):** Trỏ `skills` tới `./skills/` và `hooks` tới `./hooks/claude-codex-hooks.json`, kèm UI metadata và composer icons.
- **`plugin.yaml` & `__init__.py` (Hermes Agent `5.3.3`):** Đăng ký hooks `pre_llm_call` và `pre_gateway_dispatch`, 6 commands và 6 skills (`ponytail:<skill>`).
- **`gemini-extension.json` (`5.3.3`):** Khai báo `"contextFileName": "AGENTS.md"`.
- **`opencode.json`:** `{"$schema": "https://opencode.ai/config.json"}`.
- **CI (`.github/workflows/test.yml`):** Chạy trên Node 22 + Python 3.12 + `pandas`, thực thi tuần tự:
  1. `scripts/check-rule-copies.js`
  2. `scripts/check-versions.js` (khóa semver trùng khớp giữa 7 manifests: `.claude-plugin/plugin.json`, `.codex-plugin/plugin.json`, `.devin-plugin/plugin.json`, `.github/plugin/plugin.json`, `.qoder-plugin/plugin.json`, `gemini-extension.json`, `package.json`)
  3. `npm test`
  4. `python3 benchmarks/agentic/run.py --selftest`

---

## 4. Kiến trúc lõi & Cơ chế thực thi nội bộ

### 4.1 Prompt nguồn duy nhất & Chống lệch bản sao
1. **Prompt lõi (`skills/ponytail/SKILL.md`, 3.495 bytes):**
   - Bắt buộc agent đọc đoạn code bị tác động, liệt kê toàn bộ callers/tests/fixtures/config/exports và kiểm tra ảnh hưởng người dùng trước khi sửa.
   - **Thang 6 bậc "Smallest complete change":**
     1. *Does it need to exist?* — bỏ qua tính năng/tùy chọn không được yêu cầu và nêu tên trong 1 dòng.
     2. *Already in this codebase?* — ưu tiên dùng lại helper/component/pattern đã có.
     3. *Standard library or platform feature?* — component sẵn có của dự án được ưu tiên hơn widget native.
     4. *Installed dependency?* — tuyệt đối không cài thêm dependency mới chỉ cho vài dòng logic.
     5. *Readable one-liner?* — viết biểu thức một dòng nếu vẫn dễ đọc.
     6. *Minimum code that works.*
   - **Hàng rào "Never cut":** Không cắt validation ở trust boundary, xử lý lỗi mất dữ liệu, bảo mật, accessibility, hiệu chuẩn phần cứng, hành vi được yêu cầu. Mọi logic mới không tầm thường (rẽ nhánh, vòng lặp, parser, tiền tệ, bảo mật) bắt buộc có ít nhất một test/assert nhỏ; dùng comment `shortcut: <limit>, <when to upgrade>` khi chấp nhận đánh đổi có giới hạn; kết thúc câu trả lời bằng 1–2 dòng ghi rõ kiểm tra đã bỏ qua và rủi ro.
2. **Bản rút gọn (`AGENTS.md`, 2.720 bytes) & Drift guard (`scripts/check-rule-copies.js`):**
   - `AGENTS.md` lược bỏ frontmatter và bảng `Levels` cho các agent chỉ đọc file rule tĩnh.
   - `check-rule-copies.js` xác minh khớp từng byte (sau khi bỏ frontmatter) giữa `AGENTS.md` và 7 bản sao rule IDE (`.cursor/rules/ponytail.mdc`, `.windsurf/rules/ponytail.md`, `.clinerules/ponytail.md`, `.agents/rules/ponytail.md`, `.qoder/rules/ponytail.md`, `.github/copilot-instructions.md`, `.kiro/steering/ponytail.md`), kèm kiểm tra cụm từ bất biến đối chiếu với `SKILL.md`.
3. **Lọc hướng dẫn theo mode (`hooks/ponytail-instructions.js` & `__init__.py`):**
   - `filterSkillBodyForMode(body, mode)` bóc YAML frontmatter và chỉ giữ các dòng bảng `| **mode** |` cùng ví dụ `- mode: "..."` khớp với mức đang bật (`lite`, `full`, `ultra`). Nếu không đọc được `SKILL.md`, tự fallback về chuỗi nhúng tương đương `AGENTS.md`.

### 4.2 Vòng đời Hook, Phát hiện Host & Lưu trạng thái (`hooks/`)
- **Giải cấu hình (`hooks/ponytail-config.js`):** Thứ tự ưu tiên `PONYTAIL_DEFAULT_MODE` > `$XDG_CONFIG_HOME/ponytail/config.json` (hoặc `~/.config/ponytail/config.json` / `%APPDATA%\ponytail\config.json`) > `'full'`. Chỉ các runtime mode (`off`, `lite`, `full`, `ultra`) được lưu làm mặc định (`review` là one-shot).
- **Phát hiện host & quản lý state (`hooks/ponytail-runtime.js`):**
  - Nhận diện môi trường chạy qua biến môi trường/đường dẫn: VS Code Copilot (`COPILOT_PLUGIN_DATA` hoặc `.vscode/.../agent-plugins`), Codex (`PLUGIN_DATA`), Qoder (`QODER_SESSION_ID`), CodeBuddy (`CODEBUDDY_PLUGIN_ROOT`), Cursor (`CURSOR_VERSION`), hoặc Claude Code gốc.
  - Lưu trạng thái ở `<stateDir>/.ponytail-active` **và** theo từng dự án bằng mã băm SHA-256 của đường dẫn `CLAUDE_PROJECT_DIR` chuẩn hóa trong `ponytail-modes/` để các repo mở đồng thời không xung đột state.
  - Ghi stdout đồng bộ qua `fs.writeSync(1, ...)` (tránh cắt cụt pipe trên macOS khi gọi `process.exit`), định dạng đầu ra đúng schema của từng host (`additionalContext`, `hookSpecificOutput`, `additional_context` + `continue: true` của Cursor, hoặc raw stdout cho Claude `SessionStart`).
- **Luồng sự kiện chính (`hooks/claude-codex-hooks.json`):**
  - `SessionStart` (`startup|resume|clear|compact`) → `ponytail-activate.js`: đọc `source` từ stdin (giữ nguyên live mode khi `compact`), xuất `SKILL.md` đã lọc, ghép thêm **codebase symbol map** từ `ponytail-map.js` (không dependency ngoài, timeout 3 giây, ngân sách tối đa 2.000 ký tự, chạy `git ls-files` + regex và ưu tiên thư mục `util/helper/lib/service/component/hook`). Trên Claude Code, copy `ponytail-statusline.{sh,ps1}` sang `claudeDir` (tránh bị dọn cache theo version) và nhắc một lần nếu chưa cấu hình `statusLine`.
  - `UserPromptSubmit` → `ponytail-mode-tracker.js`: phân tích `/ponytail [lite|full|ultra|off]`, `/ponytail default <mode>`, `/ponytail band [on|off|import]` và lệnh tắt `"stop ponytail"` / `"normal mode"`. Áp dụng timeout stdin có `ref` 1000ms để ngăn lỗi treo EOF trên PowerShell Windows. Bơm bộ rule khi đổi mode trên Cursor/Codex hoặc ở phiên Qoder (không có `SessionStart`).
  - `SubagentStart` → `ponytail-subagent.js`: truyền bộ quy tắc đang kích hoạt cho subagent được spawn; hỗ trợ lọc bằng regex `PONYTAIL_SUBAGENT_MATCHER` chạy trong `vm.runInNewContext(..., { timeout: 100 })` để chống ReDoS.

### 4.3 Native Plugins & Claude Code Band
- **OpenCode / Kilo Code (`.opencode/plugins/ponytail.mjs`):** Hỗ trợ song song API V2 (`setup(ctx)` dùng `ctx.skill.transform`, `ctx.command.transform`, `ctx.session.hook('context' | 'compaction', ...)`) và API V1 (`server()` dùng `config`, `experimental.chat.system.transform`, `command.execute.before`), tái sử dụng helper CJS trong `hooks/` thông qua `createRequire`.
- **pi / Oh My Pi (`pi-extension/index.js`):** Đăng ký `/ponytail` kèm autocomplete, đồng bộ mode bằng `pi.appendEntry("ponytail-mode", ...)` qua `session_start`/`session_tree`/`session_switch`/`session_branch`, cập nhật thanh trạng thái và bơm nội dung vào `event.systemPromptOptions.sections.ponytail` để **giữ nguyên prompt cache** (có fallback nối vào `systemPrompt`).
- **Hermes Agent (`__init__.py`):** Cài đặt tương đương `_filter_skill_body_for_mode` bằng Python và gắn vào `pre_llm_call` / `pre_gateway_dispatch`.
- **Claude Code Band (`hooks/band/`):**
  - `register.tsx`: gắn vào slot render `AbovePrompt` và vòng đời lượt chạy (turn lifecycle) của Claude Code.
  - `metrics.ts`: thống kê token, chi phí, biểu đồ sparkline theo lượt (`metricsSvg`), nhận diện lệnh chạy test & phân tích kết quả pass/fail (`testCounts`), và **đo tái sử dụng code theo thời gian thực**: dùng `git grep` + regex trích xuất hàm định nghĩa (`defsIn`) và lời gọi (`callsIn`) để tính `% reuse` cũng như phát hiện hàm đã xóa vẫn còn caller mở (`⚠ N callers open`).
  - Lưu 1 dòng/task (`taskKey`) vào `~/.config/ponytail/band/<project>.csv` chuẩn RFC 4180, dựng dashboard HTML offline không cần server (`board.ts`), và tùy chọn gửi HTTP POST JSON snapshot tới `webhookUrl` (`https://` hoặc `localhost`) kèm Bearer token (`webhookRequest`).

---

## 5. Phương pháp Benchmark & Kết quả công bố (`benchmarks/`)

- **Kiến trúc đo lường:** Chuyển từ Promptfoo single-shot (`benchmarks/promptfooconfig.yaml`) sang **agentic harness** (`benchmarks/agentic/run.py`) chạy các phiên headless `claude -p` trong thư mục tạm cô lập (ngoài git repo, vô hiệu hóa `CLAUDE.md`, auto-memory, Bash và MCP).
- **Bộ 39 tasks:**
  - 12 tính năng trên `full-stack-fastapi-template`.
  - 18 task kiểm tra ẩn (surgical hidden-check tasks) bao phủ SQL injection, path traversal, HMAC, rate-limiting, CSV, quyền riêng tư, đổi tên đa caller.
  - 9 task mở (open tasks).
  - Chấm kết quả bằng `judge.py` (LLM judge đo mức over-engineering) và `complete.py` (đo độ hoàn thiện).
- **Kết quả công bố cho Ponytail 5** (`benchmarks/results/2026-10-07-agentic.md`, chạy trên Opus 5.5, `39 tasks × 5 runs = 585 sessions`, so với baseline không dùng skill):
  - **LOC:** `-53%`
  - **Gzip code info:** `-41%`
  - **Output tokens:** `-45%`
  - **Chi phí trung bình:** `-26%` (`0.142 USD` so với `0.200 USD`; rẻ hơn trên 30/38 task)
  - **Thời gian chạy:** `-41%`
  - **Số lượt (turns):** `-22%`
  - **An toàn / hidden checks:** đạt `97%` (so với `96%` không dùng skill và `96%` của v4.13)
  - **Tỷ lệ logic rủi ro có kèm test:** `98%` (so với `68%` không dùng skill)

---

## 6. Đánh giá kỹ thuật, Giới hạn đã biết & Phạm vi chưa kiểm tra

### 6.1 Điểm mạnh nổi bật
- **Zero-dependency runtime & kỷ luật phân phối đa-agent:** Một nguồn prompt gốc, tự động kiểm soát drift byte-for-byte trên 7 IDE và khóa version đồng bộ 7 manifest trong CI.
- **Xử lý kỹ edge-case hệ điều hành và runtime:** Giải mã UTF-8 qua ranh giới chunk, bỏ BOM Windows, chống treo EOF PowerShell, chống cắt cụt stdout macOS, sandbox `vm` chống ReDoS, cô lập state bằng SHA-256 theo project, và bơm prompt theo section bảo toàn prompt caching.
- **Đóng vòng phản hồi bằng đo lường:** Kết hợp symbol map tại `SessionStart` để thúc đẩy reuse, benchmark agentic nhiều lượt lặp, và chỉ số trực tiếp trong phiên (`band`).

### 6.2 Giới hạn đã ghi nhận (từ `shortcut:` comments & docs của repo)
- `ponytail-map.js` và `hooks/band/metrics.ts` phân tích code bằng **regex** thay vì AST/tree-sitter nên có thể bỏ sót định nghĩa lồng nhau/động; `ponytail-map.js` sẽ bỏ qua map nếu vượt quá timeout 3 giây.
- **Cursor hooks:** Không thể bơm ngữ cảnh vào subagent (do giới hạn API `subagentStart` của Cursor) và không tắt được file `.cursor/rules/ponytail.mdc` đã đặt sẵn trong workspace.
- **Claude Code Band:** Phụ thuộc API UI của Claude Code `2.1.290+`, không hiển thị trên VS Code chat panel, cloud session hoặc chế độ `claude -p`.
- **Ghi chú khách quan về benchmark:** Các con số trong `benchmarks/results/` là kết quả tự công bố từ repo trên cấu hình cụ thể (Opus 5.5, tắt Bash/MCP), chưa được tái chạy độc lập trên các nền tảng/model khác (như Gemini trên Antigravity).

### 6.3 Phạm vi chưa đọc chi tiết trong phiên khảo sát này
- 23 tệp unit test trong `tests/`.
- Các bản dịch trong `i18n/`.
- Nội dung chi tiết 11 ví dụ trong `examples/` (mới kiểm tra danh sách thư mục).
- Mã nguồn chi tiết của `hooks/ponytail-band-import.js`.
- Toàn văn `INSTALL.md` và `docs/cursor-hooks.md`.
