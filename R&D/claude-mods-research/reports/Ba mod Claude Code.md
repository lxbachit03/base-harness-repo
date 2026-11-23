# Ba mod Claude Code và harness repo: nên cài mod nào?

- Ngày: 2026-11-23
- Đối tượng:
  - `savvy-progress` 1.2.1 trong <https://github.com/JohnnyVizz/claude-kit> (MIT), đọc trên `main`, commit cuối `af8902c` (2026-10-12)
  - `collision-guard` và `goal-meter` 1.0.0 trong <https://github.com/nateherkai/claude-code-mods> (MIT), commit duy nhất `33a936f` (2026-10-02)
- Ghi chú chi tiết (có số dòng và link nguồn):
  - [savvy-progress.md](<../research_notes/Ba mod Claude Code/savvy-progress.md>)
  - [collision-guard.md](<../research_notes/Ba mod Claude Code/collision-guard.md>)
  - [goal-meter.md](<../research_notes/Ba mod Claude Code/goal-meter.md>)

## Kết luận

**Không cài `savvy-progress` và `collision-guard`. `goal-meter` là mod duy nhất hợp
với harness, nhưng chỉ nên thử như một pilot tùy chọn ở user scope, khi User cấp
authority riêng theo #009, ghim ở `33a936f` và tắt strict.**

- **`savvy-progress`:** thanh tiến độ chỉ hiện với skill `savvy-flow` hoặc agent tên
  `savvy-*`, harness không dùng cả hai. Đổi lại, tool `step` luôn nằm trong tool list
  của mọi request, kể cả của worker harness.
- **`collision-guard`:** giải quyết một rủi ro thật (nhiều agent sửa chung một
  checkout). Nhưng nó chỉ thấy chat Claude Code dùng `Edit`/`Write`/`NotebookEdit`,
  bỏ qua agy, Codex, Bash, subagent và `claude -p`. Lựa chọn "Move to a worktree"
  của nó lại trái luật không dùng worktree (#024, #045).
- **`goal-meter`:** bổ trợ cho `goal-griller` (griller soạn `/goal`, meter hiển thị
  tiến độ sau đó). Không đụng ngân sách #064. Có một bug im lặng (issue #1) và chỉ
  chạy trên Claude Code.
- **Cả ba đều sạch về code:** không gọi mạng, không gọi model. Rủi ro chính là chuỗi
  cung ứng: API mod còn early-access, tác giả đơn lẻ, không có release, và có bản
  clone đóng gói lại.

## So sánh nhanh

| | `savvy-progress` | `collision-guard` | `goal-meter` |
| :--- | :--- | :--- | :--- |
| Làm gì | Thanh tiến độ cho `/savvy-flow` và pane `/agents-info` liệt kê subagent (model, context, chi phí ước tính, thời gian) | Hỏi trước khi sửa file mà chat khác vừa sửa trong 30 phút: Proceed / Move to a worktree / Cancel | Thanh tiến độ có ETA cho `/goal`, dựa trên plan S/M/L mà Claude tự báo qua tool riêng; `/goals` xem goal của mọi chat |
| Giao diện | `AbovePrompt`, `Pane` | Hộp thoại `$.ui.ask`, lệnh `/guard` | `AbovePrompt`, footer `SessionMode`, `Pane`, toast |
| Ghi đĩa / tiến trình | Không (chỉ `$.state` trong phiên) | `~/.claude/mods-data/collision-guard/<session>.json`; chạy `git ls-files` khi có va chạm | `~/.claude/mods-data/goal-meter/<session>.json`; chạy PowerShell/`tail` đọc 12 dòng cuối transcript |
| Chèn vào context | Tool `step` không deferred (~130–170 token mỗi request, mọi agent); ~70 token cho mỗi worker `savvy-*` | 0; ~50–90 token khi có deny | ~150 token mỗi `/goal`; ~2–5k token tool traffic mỗi goal 8–12 task; schema ~350–400 token nếu không deferred |
| Trưởng thành | 430 sao, 109 fork, 35 commit, 10 người đóng góp; dừng từ 2026-10-12, ~25 PR treo | 148 sao, 18 fork, 1 commit, 1 tác giả, không test | Như cột trái; thêm issue #1 chưa ai trả lời |
| Đề xuất | **Không cài** | **Không cài**; làm kiểm tra phía coordinator thay thế | **Tùy chọn, pilot có điều kiện** |

Số token đều là ước tính từ độ dài chuỗi (khoảng 4 ký tự mỗi token), chưa đo bằng
tokenizer.

## savvy-progress: đẹp nhưng gắn với savvy-flow

**Cách chạy.** Một module function-hooks `register.tsx` (1.271 dòng), chỉ import
`atom/read/update` từ `claude-code`. Nó hook `session.start`, `agent.spawn`,
`turn.step`, `turn.complete`, `tool.call` và hai `ui.render`. Chi phí lấy từ `usage`
của từng request subagent, nhân với bảng giá cứng (giá niêm yết 2026-10-10; README
ghi rõ là ước tính, "not a bill"). Grep không thấy `fetch`, `$.fs`, `$.store`,
`$.model`, `$.process` hay `eval`. Text do model đưa vào SVG đều được escape
([register.tsx](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx)).

**Chỗ đáng lưu ý.**

- Tool `step` đăng ký `isDeferred: false` nên schema luôn nằm trong tool list của
  phiên chính và mọi subagent, dù không dùng savvy-flow.
- `agent.spawn` viết lại prompt của subagent `savvy-*`, bảo nó gọi `step` "before
  any other work".
- Lệch namespace: agent cài từ marketplace tên `savvy-flow:savvy-careful` nên phép
  thử `startsWith('savvy-')` không khớp (issue #35, PR #50 chưa merge).
- Mod trả lời tool của mình ở `tool.call`, trong khi tài liệu 2.1.330 nói dùng
  `tool.run`. Có thể là API đã đổi so với bản tác giả thử (2.1.286); chưa kiểm.
- Không vẽ được trong phiên cloud (issue #37).

**Cài đặt.** `/plugin marketplace add johnnyvizz/claude-kit` rồi
`/plugin install savvy-progress@claude-kit`, hoặc `--plugin-dir`. README nói chỉ thử
trên 2.1.286 và API "may change between releases". Bản cài marketplace bám theo
`main`, không ghim được commit.

**Clone.** Nhiều bản đổi tên tồn tại. Ba bản đã grep (`savvy-progress-px`,
`claude-kit-savvy-mod`, `claude-kit-saavy-progress`) không thấy I/O lạ. `LOUONE/crabcam`
thêm một "narrator" gọi `$.model.complete`, gửi dòng tool và target của agent lên
model, tức có thêm chi phí và luồng dữ liệu
([forks](https://api.github.com/repos/JohnnyVizz/claude-kit/forks?per_page=100&sort=newest)).

## collision-guard: đúng vấn đề, sai phạm vi cho harness

**Cách chạy.** Mỗi chat ghi sổ các file đã sửa vào
`~/.claude/mods-data/collision-guard/<sessionId>.json` (heartbeat 60 giây). Hook
`tool.call` chỉ bắt `Edit`, `Write`, `NotebookEdit`. Trước mỗi lần sửa, nó đọc sổ
của các chat khác còn sống (cập nhật trong 15 phút) và tìm cùng đường dẫn đã chuẩn
hóa trong 30 phút. Nếu trùng, nó gọi `$.ui.ask`. Chọn Cancel hoặc Worktree sẽ trả
`{ deny }`, và model đọc lý do đó như kết quả tool
([register.mjs](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)).
Một catalogue tĩnh xếp nó L2 "writes or runs"
([mods.aidojo.si](https://mods.aidojo.si/mods/nateherkai--claude-code-mods--collision-guard/)).

**Điểm yếu.**

- **Fail open:** hook không có `.catch`, nên lỗi hay timeout đều cho sửa. Phiên
  không có surface (`claude -p`) bỏ qua hộp thoại.
- **Bỏ sót:** sửa qua Bash/PowerShell, MCP, người dùng trong IDE, agent không phải
  Claude. Subagent trong cùng một chat nhiều khả năng dùng chung session id nên
  không được bảo vệ lẫn nhau (chưa kiểm).
- **Race:** đọc và ghi sổ không khóa, không nguyên tử.
- **Sổ cũ:** chat crash vẫn chặn người khác tới 15 phút; sổ của chat đã kết thúc
  không bao giờ bị xóa.
- **Riêng tư:** tiêu đề chat (80 ký tự đầu của prompt đầu tiên) lưu dạng thô trên
  đĩa và luôn nằm trong deny gửi cho model của chat khác. Một secret dán vào prompt
  đầu có thể lọt sang chat khác.

**Clone.** Fork phần lớn chưa đổi. `neogeweb3/claude-code-mods`,
`Marketplaces-Plugins-Shared/claude-code-mods` và `inematds/5-mods` có thay đổi sau
upstream và chưa được rà soát
([issue #3](https://github.com/nateherkai/claude-code-mods/issues/3)).

## goal-meter: hiển thị tiến độ từ chính plan của Claude

**Cách chạy.** Khi User gõ `/goal`, hook `command.run` gắn một ghi chú ẩn (~600 ký
tự) vào `context` của lệnh. Ghi chú này yêu cầu Claude lập plan bằng tool
`mcp__goal-meter__tasks`. Theo comment trong code, cách này giữ nguyên prefix đã
cache. Phần trăm tính theo trọng số S=1, M=2, L=3. ETA bằng tốc độ tuyến tính trên
phần đã xong, chỉ hiện sau 2 task. Kết quả goal check đọc từ dòng `goal_status`
trong transcript, một định dạng code tự nhận là "not documented", bằng cách chạy
`powershell.exe -Command "Get-Content ... -Tail 12"` hoặc `tail`
([register.mjs](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs),
[plan.mjs](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/plan.mjs)).

**Điểm yếu.**

- **Issue #1:** đường dự phòng (`turn.start`) và lời nhắc chèn dòng `user` không có
  `isMeta`. Claude Code 2.1.287+ từ chối các dòng này, và `catch {}` rỗng nuốt lỗi.
  Band có thể ghi "reminded Claude" dù lời nhắc chưa tới. Đường chính qua
  `command.run` không bị ảnh hưởng
  ([issue #1](https://github.com/nateherkai/claude-code-mods/issues/1)).
- **Độ chính xác:** chỉ tốt bằng việc Claude tự ghi sổ. Strict mode (mặc định tắt)
  chỉ chặn `Edit`/`Write` trước khi có plan.
- **Riêng tư:** điều kiện goal (tới 2.000 ký tự), tên task và cwd lưu dạng thô,
  không bao giờ xóa. `/goals` hiện goal 12 giờ gần nhất của mọi project trên máy.
- **Cài đặt:** `claude plugin install goal-meter@nateherk-mods`, cần Claude Code
  2.1.287+ và tài khoản đã bật mods. Bản cài là bản copy, nên tự ghim ở `33a936f`
  cho tới lần `plugin update`. `inematds/5-mods` là bản copy giống từng byte.

## Đối chiếu với harness

| Ràng buộc | `savvy-progress` | `collision-guard` | `goal-meter` |
| :--- | :--- | :--- | :--- |
| #009 authority | `marketplace add`, `install` và mỗi lần update đều là cài dependency hoặc đổi global settings, cần authority riêng | Như cột trái; hook chạy trên mọi lần sửa ở mọi project trên máy | Như cột trái |
| #064 (33.400 byte đầu phiên) | Không đọc file đầu phiên; nhưng tool `step` tốn token ở mọi request | 0 | 0; chi phí chỉ phát sinh trong `/goal` |
| `statusLine` | Không đụng (dùng `AbovePrompt`) | Không đụng | Không đụng (dùng `AbovePrompt`, `SessionMode`); dựa vào Stop hook có sẵn ở user level để biết `transcript_path` |
| #094 (installer không ghi `AGENTS.md`, rule, hook vào repo) | Đạt nếu cài user/local scope; project scope sẽ ghi `.claude/settings.json` của repo | Như cột trái | Như cột trái |
| Multi-agent workers | Pane `/agents-info` cho thấy chi phí subagent; worker harness không tên `savvy-*` nên không bị chèn prompt | Không bảo vệ agy, Codex, Bash, subagent hay `-p`, tức phần lớn writer song song của harness | `/goals` giúp coordinator xem goal của các worker, nhưng trộn lẫn project khác |
| #024/#045 không worktree | Không liên quan | **Mâu thuẫn:** "Move to a worktree" bảo model gọi `EnterWorktree`, và lựa chọn này hiện cho mọi file git theo dõi | Không liên quan |
| goal-griller | Không liên quan | Không liên quan | **Bổ trợ:** griller kết thúc trước `/goal`, meter bắt đầu sau `/goal`. Griller viết cho Codex nên meter chỉ có ích khi chạy trên Claude Code |
| ticket-DoD | Không liên quan | Không liên quan | Không thay thế: DoD là việc User nợ, lưu trong repo; meter là task tạm của agent, lưu ngoài repo |

Repo hiện không có `.claude/settings.json`. `.claude/settings.local.json` chỉ có
`skillOverrides`, nên cả ba đều không xung đột với cấu hình project.

## Đề xuất

1. **`savvy-progress`: không cài.** Nếu User chỉ muốn xem chi phí subagent khi chạy
   swarm, dùng một bản copy đã rà soát, nạp bằng `claude --plugin-dir` cho một phiên
   (vẫn cần authority theo #009). Không cài từ marketplace vì bám `main`.
2. **`collision-guard`: không cài.** Muốn giữ ý tưởng thì làm cách riêng của harness:
   coordinator so `git status`/`git diff --name-only` với owned paths của từng
   worker. Cách này phủ được mọi loại agent và không đụng worktree. Ý tưởng này chưa
   có trong harness; nếu làm thì đi qua `improve-harness`.
3. **`goal-meter`: tùy chọn, chỉ khi User muốn.**
   - Cài user scope từ `nateherkai/claude-code-mods`, có authority riêng; không
     vendor vào harness.
   - Ghim `33a936f`; rà soát lại trước mỗi lần update.
   - Để strict tắt; định kỳ xóa `~/.claude/mods-data/goal-meter/`.
   - Nếu tự sửa issue #1 (`isMeta: true`), đó là fork do mình bảo trì.
   - Ghi quyết định vào một improvement record theo khuôn #094, kèm ngưỡng đánh giá
     đặt trước (ví dụ band đúng với plan thực tế trong N goal).
4. **Với mọi mod:** chỉ cài từ repo gốc, không cài từ fork hay bản đóng gói lại,
   và không dùng `--scope project`.

## Giới hạn của báo cáo này

- Không cài, không chạy mod nào; giao diện, hành vi runtime và số token đều suy từ
  code, README và tài liệu type bản 2.1.330.
- Không có `gh`; metadata GitHub lấy qua REST API không xác thực ngày 2026-11-23.
- Chỉ grep 3–4 fork của `savvy-progress`, không diff toàn bộ fork của cả hai repo.
- Chưa kiểm: Herdr/Orca khởi chạy worker Claude kiểu interactive hay `-p`; subagent
  có dùng chung session id không; hook "Goal Guard" mà `goal-griller` nhắc tới (không
  tìm thấy trong `docs-harness`).
