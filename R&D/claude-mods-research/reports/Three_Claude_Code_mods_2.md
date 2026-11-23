# Ba mod Claude Code (đợt 2) và harness repo: nên cài mod nào?

- Ngày: 2026-11-23
- Đối tượng:
  - `effort-optimizer` 0.1.0 trong <https://github.com/jz-wilson/claude-mods>, đọc ở commit `2153b719` (2026-10-23); code giống từng byte với `main` (0.1.1, `87e98524`, 2026-11-18)
  - `cache-clock` 0.3.2 cùng repo, đọc ở commit `cd9448a7` (2026-11-10); `main` đã lên 0.3.4
  - `efficient-browser` 0.1.0 trong <https://github.com/Sagor31h2/claude-mods> (MIT), nhánh `dev` (nhánh duy nhất), commit `90df9ee2` (2026-11-15)
- Ghi chú chi tiết (có số dòng và link nguồn):
  - [effort-optimizer.md](<../research_notes/Ba mod Claude Code 2/effort-optimizer.md>)
  - [cache-clock.md](<../research_notes/Ba mod Claude Code 2/cache-clock.md>)
  - [efficient-browser.md](<../research_notes/Ba mod Claude Code 2/efficient-browser.md>)

## Kết luận

**Không cài mod nào trong đợt này. `effort-optimizer` mâu thuẫn trực tiếp với cách
User và harness chọn effort. `cache-clock` và `efficient-browser` vô hại về code
nhưng giá trị thấp, và đều có cách thay thế không cần dependency.**

- **`effort-optimizer`:** mỗi prompt gõ tay tốn thêm một lệnh gọi Sonnet 5.5 để
  chọn effort. Chế độ `auto` âm thầm ghi đè `effortLevel: xhigh` của User và
  checklist effort theo vai trò của harness. Chế độ `suggest` (mặc định) mở hộp
  thoại modal chặn request đầu tiên của turn, nên worker không người trông có thể
  treo.
- **`cache-clock`:** band đếm ngược tới lúc prompt cache nguội. Với gói subscription
  của User (TTL 1 giờ), cache hiếm khi nguội giữa chừng. `/usage` và trường
  `prompt_cache` của statusLine đã cho cùng thông tin. Tính năng "Keep warm" (tắt
  mặc định) gọi model thật và tốn tiền.
- **`efficient-browser`:** tự thêm `scale: 0.5` cho screenshot của bảy tool browser
  và computer-use, nên mỗi ảnh còn khoảng ¼ token. Code chỉ 99 dòng và sạch, nhưng
  repo mới một ngày tuổi, chưa từng chạy thật, bám nhánh `dev` không ghim. Mod cũng
  không phủ `orca screenshot`.
- **Chuỗi cung ứng chung với đợt 1:** tác giả đơn lẻ, cài từ marketplace là bám đầu
  nhánh. Hai mod của jz-wilson còn không có license và là bản phân phối lại từ
  "benai-mods" của Ben AI. Chưa xác minh được lời ghi "with permission".

## So sánh nhanh

| | `effort-optimizer` | `cache-clock` | `efficient-browser` |
| :--- | :--- | :--- | :--- |
| Làm gì | Chọn effort cho mỗi prompt theo rubric "four questions" của Ben AI; hỏi (`suggest`) hoặc tự đổi (`auto`) | Đếm ngược tới lúc cache nguội; khi nguội và chat ≥150k token thì có nút handoff; tùy chọn Keep warm | Điền `scale: 0.5` vào screenshot khi model không tự đặt |
| Giao diện | Hộp thoại `$.ui.ask`, band `AbovePrompt`, nhãn cam ở `SessionMode`, `/effort-optimizer` | Band `AbovePrompt`, toast, `/cacheclock`, `/keepwarm` | Chỉ lệnh `/efficient-browser on\|off\|status` |
| Ghi đĩa / tiến trình | Log `~/.claude/mods-logs/`; đọc `~/.claude/mods/switches.json` mỗi 3 giây; có thể đổi setting effort qua `$.config.set` | Log, `switches.json`, `~/.claude/handoffs/.request-<sid>`; chạy `python3`/`python bin/ttl.py` sau mỗi turn | Một cờ `enabled` trong `$.store` |
| Gọi model | 1 lệnh Sonnet 5.5 mỗi prompt (~600–1.800 token input, ≤120 output) | 0; khi bật Keep warm thì `$.model.fork` mỗi lần trước khi hết TTL, tối đa 30 lần / 2 giờ | 0 |
| Chèn vào context | 0 | 0 | 0 (ngược lại, giảm token ảnh) |
| Trưởng thành | 3 sao, 2 fork, 48 commit, 1 người; không license; CI Linux và Windows; test chỉ kiểm phần lệnh | Như cột trái; 9 test × 2 surface; bản ghim đã bị 0.3.4 sửa lỗi | 1 sao, 0 fork, 4 commit trong 6 phút; MIT; không release, không tag |
| Đề xuất | **Không cài** | **Không cài**; nếu cần thì đọc `prompt_cache` trong statusLine | **Không cài**; nếu cần thì tự viết hoặc vendor ở `90df9ee2` |

Số token là ước tính từ độ dài chuỗi và từ mô tả schema của tool, chưa đo bằng
tokenizer.

## effort-optimizer: tối ưu effort bằng cách lấy quyền chọn của User

**Cách chạy.** Một module `register.tsx` (537 dòng). Hook `prompt.submit` chỉ giữ
lại prompt có origin `composer` hoặc `bridge`, bỏ qua prompt rỗng và slash command.
Ở bước đầu tiên của turn (`turn.step`, `index === 0`), trước khi request đầu đi,
`pick()` gửi prompt (cắt còn 4.000 ký tự) và 600 ký tự của câu trả lời trước tới
`claude-sonnet-5-5` với `effort: 'low'`, `maxTokens: 120`. Rubric dừng ở câu "yes"
đầu tiên theo thứ tự low → high → xhigh/max → medium. `applyLevel` thử
`$.config.set` trên hàng effort của `/config`. Nếu bị từ chối, nó giữ một override
và viết lại `effort` của mọi request ở luồng chính cho tới khi User kéo picker.
Subagent không bị đụng tới
([register.tsx](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx)).

**Chỗ đáng lưu ý.**

- **Không có đánh giá chất lượng nào.** Rubric xếp low lên đầu, nên một prompt vừa
  lặp vừa rủi ro sẽ nhận low. Anthropic khuyên dùng effort mặc định và coi effort là
  sở thích chung, không phải lựa chọn theo từng task
  ([Claude blog](https://www.claude.com/blog/claude-model-and-effort-level-in-claude-code)).
- **Menu effort hiển thị sai.** Ở đường dự phòng, menu vẫn hiện mức cũ; mod tự thừa
  nhận điều này trong band "info" và bù bằng nhãn cam ở footer.
- **Code chết.** Không chỗ nào đặt band `phase: 'offer'`, nên các nút Switch / Skip
  không bao giờ hiện, dù lệnh `/effort-optimizer suggest` vẫn nói chúng có.
- **Prompt injection có giới hạn.** Văn bản dán vào có thể đẩy mức lên `max` (tốn
  tiền) hoặc xuống `low` (làm ẩu). Thiệt hại chỉ nằm trong lựa chọn effort.
- **Riêng tư.** Prompt được gửi thêm một lần lên cùng provider, tính vào credentials
  của phiên; "nothing caps them per call". Log không ghi nội dung prompt.

**Nguồn gốc.** Rubric chép từ video của Ben AI ngày 22/10/2026
([tóm tắt](https://notes.nicolasdeville.com/ai/claude-effort-levels/)). Cả hai fork
có `register.tsx` giống từng byte. Catalogue mods.aidojo.si không liệt kê mod này,
nhưng có hơn mười mod định tuyến effort tương tự (`effort-auto`, `effort-router`,
…). Sagor31h2 cũng có một `effort-optimizer` khác tên trùng ("Never above high"),
và trên ClaudSkills còn một SKILL.md trùng tên. Cài theo tên trần rất dễ nhầm.

## cache-clock: đồng hồ đúng, nhưng TTL 1 giờ khiến nó ít việc

**Cách chạy.** Sau mỗi turn chính, mod chạy `ttl.py`. Script đọc tối đa 3 MB cuối
transcript JSONL và trả `1h` nếu reply gần nhất có `ephemeral_1h_input_tokens > 0`,
ngược lại trả `5m`. Nếu không chạy được Python, mod đoán 5 phút. Mỗi giây band đếm
ngược từ `lastEnd`, ẩn khi đang có turn
([register.tsx](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx),
[ttl.py](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/bin/ttl.py)).

**Chỗ đáng lưu ý.**

- **Bản ghim đếm lệch.** 0.3.2 bắt đầu đếm từ lúc turn kết thúc, trong khi cache
  tính từ lúc request bắt đầu, nên đồng hồ chậm đúng bằng độ dài request cuối. Bản
  0.3.4 (commit `1f637d6`, #32) đã sửa
  ([compare](https://github.com/jz-wilson/claude-mods/compare/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e...main)).
- **Thông điệp hơi lệch giá.** "re-reads … at full cost" thật ra là ghi cache lại ở
  mức 1,25× (TTL 5 phút) hoặc 2× (TTL 1 giờ) giá input
  ([pricing](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing)).
- **Keep warm có thể lỗ.** Mỗi ping là `$.model.fork` ("Reply with the single word:
  ok") chạy ở effort của phiên, tức có thể tốn thêm token suy nghĩ. Với TTL 5 phút,
  2 giờ ping tốn khoảng 2,8 lần context (C), hơn một lần ghi lại (1,25 C); điểm hòa
  vốn là ~12 ping (~50 phút). Với TTL 1 giờ, 2 ping chỉ tốn khoảng 0,2 C so với 2 C
  ghi lại. Điều này chỉ đúng nếu một lần đọc qua fork thật sự gia hạn entry 1 giờ;
  docs xếp fork vào nhóm TTL 5 phút và chưa ai kiểm
  ([prompt-caching](https://code.claude.com/docs/en/prompt-caching)).
- **Không có cầu chì như cache-keeper.** `cache-keeper` của nateherkai (đợt 1, cùng
  repo với `goal-meter`) dừng Keep warm khi một ping phải ghi thay vì đọc.
  `cache-clock` chỉ hiển thị cờ `cold` rồi ping tiếp. Hai mod viết độc lập;
  `cache-clock` không phải fork của nateherkai
  ([cache-keeper](https://github.com/nateherkai/claude-code-mods/blob/main/cache-keeper/hooks/register.mjs)).
- **Gọi Python mỗi turn** bằng tên trần `python3`/`python` từ PATH. Rủi ro này giống
  mọi tool shell-out.
- **Trạng thái toàn cục.** Ẩn band ở một chat là ẩn ở mọi chat. Nút handoff chỉ ghi
  một file yêu cầu, và chỉ có tác dụng khi cài thêm mod `handoff`.

**Trùng tên.** Có ít nhất ba "cache clock": bản Ben AI → jz-wilson này,
`cache-keeper` (Nate Herk gọi là "cache clock" trong video) và `hamzafer/cache-clock`
(chạy qua statusLine). Trên GitHub còn nhiều bản upload `benai-mods` không license,
ví dụ `jai38/benai-mods`.

## efficient-browser: tiết kiệm thật, nhưng cài để làm việc model tự làm được

**Cách chạy.** Hook `tool.call` không có matcher, nên chạy trên mọi lần gọi tool.
Với bảy tên tool cố định (`mcp__Claude_Browser__computer`/`browser_batch`,
`mcp__claude-in-chrome__computer`/`browser_batch`, `mcp__computer-use__screenshot`/
`zoom`/`computer_batch`), `scaleWalk` thêm `scale` cho mọi action `screenshot`
chưa có `scale`, kể cả item lồng trong batch. `zoom` chỉ được thêm khi bật
`scaleZoom`. Mod không bao giờ ghi đè `scale` mà model đã đặt. `userConfig` gồm
`scale` (0,1–1), `scaleZoom` và `extraTools`. Lỗi thì fail open
([register.ts](https://github.com/Sagor31h2/claude-mods/blob/90df9ee2d7bf04cecf06c72f40c703cd6f4732fb/mods/efficient-browser/hooks/register.ts)).

**Chỗ đáng lưu ý.**

- **Click vẫn đúng.** Schema của tool browser nói tọa độ luôn ở khung full-resolution.
  Rủi ro thật là khó đọc: chữ nhỏ và lỗi giao diện tinh vi có thể bị bỏ sót, hoặc
  model phải zoom thêm, ăn bớt phần tiết kiệm.
- **Tác giả tự nhận** "Only tested with the plugin test kit, not in a live session",
  và shape input cho `mcp__Claude_Browser__*` và `mcp__computer-use__*` là "guessed"
  ([README](https://github.com/Sagor31h2/claude-mods/blob/90df9ee2d7bf04cecf06c72f40c703cd6f4732fb/README.md)).
  Nếu tool computer-use từ chối thuộc tính lạ, screenshot sẽ lỗi cứng, không bị bỏ
  qua im lặng.
- **Không phủ** `mcp__remote-devices__Claude_Browser__*`, Playwright hay `orca
  screenshot` (một lệnh Bash).
- **Marketplace.** Tên `my-mods` (owner "local") rất chung chung. Repo `claude-mods`
  cũng trùng tên với `0xDarkMatter/claude-mods`. Các mod anh em có rủi ro cao hơn:
  `input-router` gửi nội dung Read/MCP lên Haiku.

## Đối chiếu với harness

| Ràng buộc | `effort-optimizer` | `cache-clock` | `efficient-browser` |
| :--- | :--- | :--- | :--- |
| #009 authority | Cài, update và đổi global setting đều cần authority riêng; `$.config.set` còn có thể ghi đè `effortLevel` của User (chưa kiểm) | Như cột trái; tạo thêm `~/.claude/mods/`, `mods-logs/`, `handoffs/` | Như cột trái; user scope sửa `~/.claude/settings.json`, nơi đang chứa hook Orca và statusLine |
| #064 (33.400 byte đầu phiên) | 0 | 0 | 0 |
| #094 (installer không ghi `AGENTS.md`, rule, hook vào repo) | Đạt ở user/local scope; project scope tạo `.claude/settings.json` mới trong repo | Như cột trái | Như cột trái; bản thân mod là một runtime hook trên mọi tool call |
| `statusLine` của User | Không đụng | Không đụng (`AbovePrompt`). Mod anh em `cache-bar` thì chiếm `statusLine.command`, không cài nhầm | Không đụng |
| Effort tường minh (`effortLevel: xhigh`, checklist effort trong `coding-sub-session.md`, `prd-research-sub-session.md`, `research-subagents.md`, Herdr `--effort`) | **Mâu thuẫn:** `auto` thay mức đã chọn cho cả turn và giữ tới khi kéo picker; `suggest` hỏi lại mỗi prompt | Không liên quan; ping Keep warm chạy ở effort của phiên, nên ở `xhigh` tốn hơn | Không liên quan |
| Coordinator/worker không người trông | `$.ui.ask` chặn trước request đầu; chưa rõ prompt do `start_session`/Herdr gửi có origin `composer` hay không | Mỗi worker có đồng hồ riêng; tin nhắn `peer`/`coordinator` không dừng Keep warm | Không ảnh hưởng luồng; giảm token ảnh cho cả worker |
| Hướng dẫn browser hiện có | Không liên quan | Không liên quan | Không trùng, không xung đột: `utilizing-tools-claude` chỉ định tuyến tới built-in browser, chưa có rule text-first hay `scale` |

Repo không có `.claude/settings.json`. `.claude/settings.local.json` chỉ có
`skillOverrides`, nên không mod nào xung đột với cấu hình project hiện tại.

## Đề xuất

1. **`effort-optimizer`: không cài.** Giữ checklist effort tường minh đang có. Nếu
   User muốn thử, chỉ thử ở local scope trong một repo nháp, chế độ `suggest`, có
   authority theo #009, và tắt (`/effort-optimizer off`) trong mọi phiên
   coordinator/worker.
2. **`cache-clock`: không cài.** Nhu cầu "cache còn ấm không" nên giải bằng cách
   thêm trường `prompt_cache` vào script statusLine hiện có của User. Cách này không
   cần plugin, không spawn Python, không gọi model, nhưng là sửa user settings nên
   vẫn cần User đồng ý. Nếu sau này vẫn muốn mod: ghim `cache-clock-v0.3.4` trở lên
   (không dùng 0.3.2), để Keep warm tắt, và chỉ cài `cache-clock` chứ không cài cả
   marketplace 14 mod (`reflect` ghi `CLAUDE.md`, `cache-bar` chiếm statusLine).
3. **`efficient-browser`: không cài từ marketplace.** Nếu User muốn giảm token
   screenshot, có hai lựa chọn: (a) một dòng rule harness ("routine screenshots dùng
   `scale: 0.5`; cần chi tiết thì zoom"), tốn vài chục byte context mỗi phiên; hoặc
   (b) vendor 99 dòng `register.ts` ở `90df9ee2` thành mod tự bảo trì, nạp bằng
   `--plugin-dir`. Cả hai đi qua `improve-harness`, có authority theo #009 và ghi
   thành improvement record theo khuôn #094, kèm ngưỡng đánh giá đặt trước (ví dụ
   số lần phải zoom lại trên N phiên browser).
4. **Với mọi mod:** chỉ cài từ repo gốc và ghim bằng tag hoặc commit, không dùng
   `--scope project`, và kiểm owner trước khi cài vì cả ba tên đều có bản trùng.

## Giới hạn của báo cáo này

- Không cài, không chạy mod nào; hành vi runtime, giao diện và số token đều suy từ
  code, README, schema tool và tài liệu type bản 2.1.330.
- Không có `gh`; metadata GitHub lấy qua REST API không xác thực ngày 2026-11-23.
- Số token và chi phí là ước tính. Chưa lấy giá Sonnet 5.5 hay Opus 5.5 thực tế, và
  chưa đo cache khi effort đổi giữa các turn.
- Chưa kiểm: `$.config.set` trên hàng effort được chấp nhận hay bị từ chối, và có
  ghi vào `effortLevel` không; ping qua fork có gia hạn entry 1 giờ không;
  `mcp__computer-use__*` có nhận `scale` không; origin của prompt do coordinator gửi;
  định dạng transcript 2.1.330 có còn khớp `ttl.py`.
- Không xác minh được nguồn gốc "benai-mods" và lời ghi "with permission"; không tìm
  bản re-upload của `efficient-browser` dưới tên khác.
