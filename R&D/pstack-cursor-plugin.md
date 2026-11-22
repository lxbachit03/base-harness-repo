# Nghiên cứu `cursor/plugins/pstack` & so sánh thực nghiệm `search_web` vs subagent `browser`

- **Đối tượng khảo sát:** <https://github.com/cursor/plugins/tree/main/pstack>
- **Phiên bản quan sát trực tiếp:** `0.15.46` (`commit 0b46ec399d55f2829e88822998f53b84944837d3`, ngày `2026-11-19`)
- **Tài liệu công cụ tham chiếu:** [docs/tools/antigravity/README.html](../docs/tools/antigravity/README.html)
- **Ngày thực hiện:** `2026-11-22`
- **Công cụ thử nghiệm:** Built-in tool `search_web` và subagent `browser` (model `flash`) trên Antigravity App 2.0

---

## 1. Hướng dẫn sử dụng & use case của built-in tool `search_web`

`search_web` là công cụ tra cứu web tích hợp sẵn do agent tự gọi khi cần thông tin ngoài workspace. Do Antigravity hiện **không còn `read_url_content`** và terminal mặc định (`run_command`) bị sandbox chặn mạng, `search_web` là kênh chính để tra cứu tài liệu tĩnh công khai trên internet.

- **Tham số:**
  - `query` *(bắt buộc)*: chuỗi từ khóa tìm kiếm.
  - `domain` *(tùy chọn)*: tên miền gợi ý ưu tiên nguồn (ví dụ `github.com`, `antigravity.google`, `ai.google.dev`), mang tính ưu tiên chứ không lọc cứng 100%.
- **Định dạng đầu ra:** Bản tóm tắt tổng hợp kèm danh sách nguồn trích dẫn dạng URL redirect của hệ thống grounding, **không** trả về nguyên văn toàn bộ HTML hay file nguồn.
- **Cách người dùng điều khiển hiệu quả:**
  - Nêu rõ tên công cụ/phiên bản/mã lỗi hoặc gắn yêu cầu ưu tiên `domain` chính thức (ví dụ: *"Dùng `search_web` ưu tiên `github.com`..."*).
  - Yêu cầu đối chiếu nhiều nguồn hoặc tách truy vấn hẹp khi cần đào sâu danh sách thành phần.

| Khi nào NÊN dùng `search_web` | Khi nào KHÔNG NÊN dùng `search_web` (và thay thế) |
| :--- | :--- |
| Tra cứu tin mới, release notes, API docs vượt mốc tri thức model. | Cần đọc nguyên văn file, đếm đủ 100% thư mục, hoặc tương tác UI JS động/đăng nhập → dùng subagent **`browser`** (`/browser`) hoặc Chrome DevTools MCP. |
| Debug lỗi theo phiên bản thư viện/OS, tra CVE hoặc GitHub Issues. | Cần tìm/đọc trong repo cục bộ → dùng `read_file` hoặc `run_command` (`rg`, `Select-String`). |
| Tóm tắt nhanh tài liệu tĩnh công khai hoặc so sánh giải pháp từ nhiều bài viết/cộng đồng. | Viết HTML/CSS/JS frontend có sẵn skill `modern-web-guidance` → kích hoạt skill đó trước. |

---

## 2. Kết quả nghiên cứu `cursor/plugins/pstack` bằng `search_web` (Lượt 1)

Thực hiện **7 truy vấn `search_web`** song song và nối tiếp (tổng thời gian khoảng **30 giây**), kết hợp `domain: "github.com"` và tìm kiếm mở rộng.

- **Những gì thu được chính xác:**
  - Xác định tác giả là **Lauren Tan (`@poteto`)** (kỹ sư tại Cursor, thành viên React core team) trong repo chính thức `cursor/plugins`.
  - Nắm rõ triết lý cốt lõi *"go deep first, then fast"* nhằm hạn chế AI sinh "slop code", đặt trọng tâm vào lập kế hoạch trước khi sửa và bắt buộc có bằng chứng thực thi thật (`Prove It Works`).
  - Xác định được router trung tâm `/poteto-mode`, các subagent (`poteto-agent`, `comment-sicko`), các lệnh cài đặt trong Cursor (`/add-plugin pstack`, `/setup-pstack`) và Claude Code (`/plugin marketplace add cursor/plugins`, `/plugin install pstack@cursor-plugins`).
  - Thu được tổng quan nhóm playbooks (bug fix, feature, `figure-it-out`, `autopilot-stack`, `babysit`, `shipping`, `eval.md`, `session-pickup.md`) và các lệnh tiêu biểu (`/architect`, `/arena`, `/blast-radius`, `/tdd`, `/unslop`, `/no-comments`, `/correct`, `/show-me-your-work`, `/ketchup`).
- **Khoảng trống & nhiễu quan sát được sau khi đối chiếu với Lượt 2:**
  - **Không thấy phiên bản và commit hiện hành** (`0.15.46`, `0b46ec3`).
  - **Lẫn thông tin từ plugin khác / bài viết chung:** Nguồn thứ cấp gộp `/deslop` như một thành phần thuộc `pstack` và mô tả khái quát cấu trúc chung của Cursor plugin (`rules` `.mdc`, `hooks`) khiến dễ hiểu nhầm `pstack` có sẵn thư mục `rules/` và `hooks/`.
  - **Thiếu hụt ở danh sách dài:** Chỉ liệt kê được 13/24 tên nguyên lý thiết kế và bỏ sót nhiều skill/module mới (`statechart`, `create-formal-verification-skill`, `ketchup-video`, `automations/benny`, `watch-pr/`).

---

## 3. Kết quả kiểm chứng trực tiếp bằng subagent `browser` (Lượt 2)

Khởi tạo subagent **`browser`** (`Model: "flash"`, chế độ chỉ đọc). Dựa trên `BROWSER_HOST_FACTS` do host ghi nhận, subagent đã truy cập trực tiếp **`https://github.com`** và **`https://raw.githubusercontent.com`** (`blocked_origins: none`, hoàn thành sau khoảng **3 phút 27 giây**). Mở raw blob trên `raw.githubusercontent.com` giúp đọc trọn vẹn `README.md` (27.938 bytes, vượt qua các bảng `<details>` bị thu gọn trên UI GitHub) và cả hai tệp `plugin.json`.

### 3.1 Cấu trúc thư mục gốc & Commit mới nhất

- **Commit mới nhất trên `pstack/`:** `0b46ec3` (`0b46ec399d55f2829e88822998f53b84944837d3`) bởi `poteto` (`Nov 19, 2026`) — *"fix(pstack): run /statechart on native Windows and read TLC's \r\n line ends (#1292)"*.
- **Cây thư mục gốc (10 mục: 6 thư mục, 4 tệp):**
  - **Thư mục (6):** `.cursor-plugin/`, `agents/`, `assets/` (`logo.png`), `automations/` (hiển thị trên GitHub là `automations/benny`), `docs/`, `skills/`.
  - **Tệp (4):** `.gitignore`, `LICENSE` (`MIT`), `README.md` (27.938 bytes), `plugin.json`.
- **Thư mục vắng mặt đã kiểm chứng:** **`rules/` và `hooks/` hoàn toàn không tồn tại** trong `pstack/`.

### 3.2 Metadata trong `plugin.json`

Cả hai manifest đều đồng bộ **`version: "0.15.46"`**, `author: { "name": "Lauren Tan" }`, `license: "MIT"`:

1. **`.cursor-plugin/plugin.json` (31 dòng, 722 bytes):** Khai báo `displayName: "pstack"`, `logo: "assets/logo.png"`, `category: "developer-tools"`, `tags: ["workflow", "principles", "review", "planning"]`, `keywords: ["pstack", "poteto-mode", "workflow", "principles", "agent-style", "subagents", "unslop"]`, và chỉ đăng ký 2 thành phần: `"skills": "./skills/"`, `"agents": "./agents/"` (không khai báo `rules` hay `hooks`).
2. **`plugin.json` ở gốc (21 dòng, 619 bytes):** Dùng `$schema: "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json"`, không liệt kê tường minh danh sách thành phần.

### 3.3 Điểm nổi bật đọc từ `README.md` gốc

- **Phân vai model mặc định:** Đẩy các tác vụ viết code delegate, văn bản và phán đoán về `Opus 5.5` mức `xhigh`, cùng review panel mặc định là `fable 5.2 / opus 5.5 / gemini 4 neon` (tùy chỉnh qua `/setup-pstack`).
- **Cơ chế cài đặt & đồng bộ đa nền tảng:**
  - **Cursor:** `/add-plugin pstack`. Có thể giữ `/poteto-mode` hoạt động liên tục như custom mode bằng `Option+Enter` (macOS) hoặc `Alt+Enter` (Windows), hoặc ghép với `/loop`.
  - **Claude Code:** `/plugin marketplace add cursor/plugins` → `/plugin install pstack@cursor-plugins` (bật auto-update trong tab `marketplaces` → `cursor-plugins`, hoặc cập nhật tay với `claude plugin update pstack@cursor-plugins`). Đọc từ cây sinh sẵn `harness/pstack/` (`node scripts/generate-pstack-harness-trees.mjs`), lệnh có tiền tố `/pstack:...`, lưu lựa chọn model tại `~/.claude/rules/pstack-models.md` và bỏ qua tính năng chỉ dành cho Cursor (`bugbot`, `automations`).
- **Đính chính thành phần ngoài gói (điểm `search_web` dễ nhầm):** `/deslop`, `control-cli`, và `control-ui` **không nằm trong `pstack`** mà thuộc plugin **`cursor-team-kit`**; `/create-skill` và `/autopilot` là built-in của Cursor.

### 3.4 Bảng kiểm kê đầy đủ & chính xác các thành phần

1. **`skills/` — 58 thư mục skill (34 skill quy trình/tiện ích + 24 `principle-*`):**
   - **34 skill quy trình / tiện ích:** `architect`, `arena`, `automate-me`, `benchmark-checklist`, `blast-radius`, `bro`, `correct`, `create-formal-verification-skill`, `create-verification-skill`, `figure-it-out`, `how`, `in-your-own-words`, `interrogate`, `ketchup`, `ketchup-video`, `maintain-formal-verification-skill`, `maintain-verification-skill`, `make-bot-ui`, `no-comments`, `poteto-help`, `poteto-mode`, `recall`, `reflect`, `setup-pstack`, `sharpen`, `show-me-your-work`, `statechart`, `swarm`, `tdd`, `teach`, `technical-writing`, `typescript-best-practices`, `unslop`, `why`.
   - **24 skill nguyên lý (`principle-*`):** `principle-attack-the-premise`, `principle-boundary-discipline`, `principle-build-the-lever`, `principle-encode-lessons-in-structure`, `principle-exhaust-the-design-space`, `principle-experience-first`, `principle-explain-the-number`, `principle-fix-root-causes`, `principle-foundational-thinking`, `principle-guard-the-context-window`, `principle-laziness-protocol`, `principle-make-operations-idempotent`, `principle-migrate-callers-then-delete-legacy-apis`, `principle-minimize-reader-load`, `principle-model-the-domain`, `principle-never-block-on-the-human`, `principle-outcome-oriented-execution`, `principle-prove-it-works`, `principle-redesign-from-first-principles`, `principle-separate-before-serializing-shared-state`, `principle-sequence-verifiable-units`, `principle-subtract-before-you-add`, `principle-test-behavior-not-implementation`, `principle-type-system-discipline`.
2. **`skills/poteto-mode/`** (gồm `SKILL.md`, `worker.md` và 3 thư mục con):
   - **`playbooks/` (22 tệp):** `authoring-a-skill.md`, `autonomous-run.md`, `autopilot-full.md`, `autopilot-stack.md`, `babysit.md`, `bug-fix.md`, `eval.md`, `feature.md`, `hillclimb.md`, `investigation.md`, `multi-phase-plan.md`, `opening-a-pr.md`, `pause-safely.md`, `perf-issue.md`, `prototype.md`, `refactoring.md`, `runtime-forensics.md`, `session-pickup.md`, `shipping.md`, `trace-forensics.md`, `visual-parity.md`, `worktree-cleanup.md`.
   - **`references/` (1 tệp):** `bugbot-triage.md`.
   - **`scripts/` (4 tệp + 1 thư mục):** `bootstrap.ts`, `bun.lock`, `package.json`, `worktree-audit.sh` và `watch-pr/` (12 tệp: `cli.test.ts`, `cli.ts`, `fakes.test-helper.ts`, `github.test.ts`, `github.ts`, `policy.test.ts`, `policy.ts`, `render.ts`, `tsconfig.json`, `types.compile.ts`, `types.ts`, `watch-pr`).
3. **`agents/` (2 tệp):** `comment-sicko.md` (chỉ đọc, kiểm duyệt comment cho `/no-comments`) và `poteto-agent.md` (delegate đọc `poteto-mode`).
4. **`automations/benny/`:** Gói automation chỉ dành cho Cursor (Slack triage + tái hiện/sửa bug), gồm `FOR_AGENTS.md`, `README.md`, `skills/` (`reproduce-and-fix-issues`, `setup-benny`, `triage-issue-reports`), và `templates/` (`configuration.example.yaml`, `reproduce-automation-prompt.md`, `triage-automation-prompt.md`).
5. **`docs/`:**
   - `docs/guide/` (11 tệp `.md`: `README.md`, `01-setup.md` → `10-recipes-and-pitfalls.md`; cùng `images/` gồm 6 `.jpg`: `design.jpg`, `overnight.jpg`, `recipes.jpg`, `router.jpg`, `understanding.jpg`, `verification.jpg`).
   - `docs/harness/claude-code.md`.

---

## 4. So sánh thực nghiệm `search_web` vs subagent `browser`

| Tiêu chí | Built-in `search_web` | Subagent `browser` (`flash`) |
| :--- | :--- | :--- |
| **Tốc độ phản hồi** | Nhanh (~30 giây cho 7 query song song). | Chậm hơn (~3 phút 27 giây) do phải điều hướng UI và đọc từng trang/raw blob. |
| **Độ chính xác nguyên văn** | Trung bình–khá: tổng hợp gián tiếp, không xác định được version `0.15.46` hay commit `0b46ec3`. | **Tuyệt đối ở thời điểm kiểm tra:** đọc thẳng manifest `plugin.json`, `README.md` và danh sách file thật. |
| **Khả năng lọc nhiễu / đính chính** | **Dễ lẫn nguồn:** gộp `/deslop` từ `cursor-team-kit` và khái niệm `rules`/`hooks` chung vào `pstack`. | **Phát hiện & loại nhiễu:** chứng minh `pstack/` không có `rules/`/`hooks/`, và `/deslop` nằm ngoài `pstack`. |
| **Độ đầy đủ danh sách dài** | Thiếu hụt (chỉ lấy 13/24 nguyên lý, sót `statechart`, `formal-verification`, `automations/benny`, `watch-pr/`). | **Đếm đủ 100%:** toàn bộ 58 skills, 22 playbooks, 24 principles, 2 agents, 12 file `watch-pr/`, 11 bài guide. |
| **Vượt UI thu gọn / JS động** | Không mở được thẻ `<details>` thu gọn hoặc nội dung chỉ render phía client. | Mở được trang, cuộn đọc và chuyển sang `raw.githubusercontent.com` để lấy toàn văn không cắt xén. |
| **Ngữ cảnh đa nguồn ngoài trang đích** | **Mạnh hơn:** gom được blog giải thích, thảo luận cộng đồng, góc nhìn so sánh từ nhiều site. | **Giới hạn tại trang đích:** chỉ thấy thông tin tồn tại trong các URL được điều hướng tới. |
| **Chi phí & rào cản** | Nhẹ context; phụ thuộc chỉ mục tìm kiếm đã index. | Tốn nhiều step/context; cần cấp quyền origin; dừng lại khi gặp login/CAPTCHA/payment wall. |

**Quy trình phối hợp khuyến nghị:** Dùng **`search_web`** trước để định vị tài liệu chính thức và nắm bối cảnh đa nguồn → dùng subagent **`browser`** khi có URL đích cụ thể cần kiểm chứng số liệu, cấu trúc repo hoặc nội dung nguyên văn mới nhất.

---

## 5. Rủi ro, hạn chế và đề xuất sử dụng

1. **Rủi ro dựa hoàn toàn vào `search_web` khi audit kỹ thuật một repo cụ thể:**
   - **Hiện tượng:** Bản tóm tắt tìm kiếm dễ trộn lẫn thông tin giữa các plugin cùng hệ sinh thái (như `/deslop` của `cursor-team-kit` lẫn vào `pstack`) hoặc bỏ sót thành phần không nổi bật trong danh sách dài.
   - **Đề xuất:** Khi yêu cầu kiểm kê chính xác file, phiên bản hoặc sự vắng mặt của thư mục tại một URL GitHub cụ thể, luôn xác minh lại bằng subagent `browser` (ưu tiên đọc file raw khi UI bị thu gọn).
2. **Rủi ro dùng subagent `browser` cho khảo sát diện rộng hoặc câu hỏi đơn giản:**
   - **Hiện tượng:** Thời gian chạy lâu (~3,5 phút so với ~30 giây) và tiêu tốn nhiều step điều hướng chỉ để duyệt cây thư mục tĩnh.
   - **Đề xuất:** Chỉ gọi `browser` cho URL đích cần độ chính xác nguyên văn hoặc trang tương tác JS; dùng `search_web` cho tra cứu tài liệu ngắn, lỗi phổ biến, hoặc tổng hợp nhiều nguồn.
3. **Rủi ro tin ngay kết quả văn bản do subagent `browser` báo cáo:**
   - **Hiện tượng:** Nội dung trang web hoặc phản hồi subagent là dữ liệu không đáng tin cậy tuyệt đối nếu chưa đối chiếu nguồn truy cập thực tế.
   - **Đề xuất:** Luôn đối chiếu phản hồi của `browser` với thông điệp hệ thống `BROWSER_HOST_FACTS` (`visited_origins`, `blocked_origins`, đường dẫn screenshot) trước khi kết luận; giữ subagent ở trạng thái idle sau khi xong để tái sử dụng cho cùng luồng nếu cần.

---

## 6. Các phần chưa kiểm chứng (Unattempted Proof)

- Nội dung chi tiết bên trong từng tệp `skills/*/SKILL.md` và các thư mục `automations/benny/skills/*/references/` chưa được mở đọc trong đợt khảo sát này.
- Chưa cài đặt hay chạy thử `pstack` trực tiếp trên Cursor hoặc Claude Code để đo hiệu năng thực tế khi thực thi code.
- Chưa thử nghiệm subagent `browser` trên luồng trang web yêu cầu đăng nhập, điền form thay đổi trạng thái hoặc có cổng chặn chống bot/thanh toán.
