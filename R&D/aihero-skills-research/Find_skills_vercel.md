# Deep dive: `find-skills` (vercel-labs/skills)

Ngày đọc: 2026-11-24. Nguồn:
- https://github.com/vercel-labs/skills/tree/main/skills/find-skills (thư mục
  chỉ có `SKILL.md`, 141 dòng, 5,472 byte)
- README của repo, `docs/commands.md`, `docs/agents.md`,
  `docs/troubleshooting.md`, https://skills.sh/
- Repo `vercel-labs/skills`: giấy phép MIT, khoảng 40.7k sao. Trên skills.sh,
  `find-skills` có khoảng 4.5M lượt cài.

## 1. Skill này là gì

`find-skills` là skill đi kèm CLI `npx skills`. Vercel gọi CLI này là package
manager của hệ sinh thái agent skill mở. CLI hỗ trợ Claude Code, Codex,
Cursor, OpenCode "và 75 agent khác", theo spec ở agentskills.io. Skill dạy
agent tìm skill có sẵn khi User cần một năng lực, giới thiệu skill đó, rồi
cài giúp nếu User đồng ý.

**Trên máy này nó đã được cài từ trước**: `~/.agents/skills/find-skills/`,
với `~/.claude/skills/find-skills` là symlink trỏ tới đó (cài ngày
2026-09-28, cùng đợt với các skill Orca). Bản local **giống hệt từng byte**
bản upstream hiện tại, và đang nằm trong danh sách skill của phiên Claude
này.

## 2. Frontmatter và trigger

- `name: find-skills`
- `description`: giúp User tìm và cài skill khi họ hỏi kiểu "how do I do X",
  "find a skill for X", "is there a skill that can…", hoặc muốn mở rộng năng
  lực của agent.
- Không có `disable-model-invocation`, nên model tự gọi được. Mục "When to
  Use" còn nới thêm: "can you do X" với năng lực chuyên biệt, muốn có tools,
  templates hay workflows, ước có trợ giúp ở một lĩnh vực (design, testing,
  deployment…).

## 3. Quy trình 6 bước

1. **Hiểu nhu cầu**: lĩnh vực, tác vụ cụ thể, và tác vụ đó có đủ phổ biến để
   đã có skill hay không.
2. **Xem leaderboard skills.sh trước**: bảng xếp theo tổng lượt cài. Ví dụ
   được nêu là `vercel-labs/agent-skills` và `anthropics/skills`.
3. **Tìm**: `npx skills find <query> [--owner <owner>]`, ví dụ `npx skills
   find react performance`. Chạy không có query sẽ mở chế độ tìm tương tác
   kiểu fzf, không dùng được trong agent.
4. **Kiểm chất lượng trước khi giới thiệu**: "Do not recommend a skill based
   solely on search results." Ba tiêu chí:
   - Lượt cài: ưu tiên từ 1K trở lên, cẩn thận với skill dưới 100.
   - Nguồn: `vercel-labs`, `anthropics`, `microsoft` đáng tin hơn tác giả lạ.
   - Sao GitHub: repo dưới 100 sao thì nên nghi ngờ.
5. **Trình bày**: tên và công dụng, lượt cài và nguồn, lệnh cài, link
   skills.sh. Tên trong ví dụ (`react-best-practices`) đã lệch với listing
   hiện tại (`vercel-react-best-practices`), nên phải lấy tên từ output của
   `find`.
6. **Cài khi User muốn**: `npx skills add <owner/repo@skill> -g -y`. Cờ `-g`
   cài ở cấp user (`~/.claude/skills/`, …), cờ `-y` bỏ qua mọi xác nhận.

Khi không tìm thấy: nói rõ là không có, đề nghị làm trực tiếp, và gợi ý tự
tạo skill bằng `npx skills init`.

## 4. Hành vi của CLI liên quan tới agent

| Mục | Hành vi |
| :--- | :--- |
| Phạm vi | Mặc định cài cho project (`./.claude/skills/`, …, "committed with your project"); `-g` cài cho user |
| Cách cài | Symlink từ thư mục của từng agent tới một bản gốc (khuyến nghị), hoặc `--copy` |
| Lock | `skills-lock.json` cho project; lock global khi dùng `-g` (máy này: `~/.agents/.skill-lock.json`) |
| Không hỏi | `-y`, cộng `--skill` và `-a <agent>` để không bị hỏi chọn agent |
| AGENTS.md/CLAUDE.md | Tài liệu không nói CLI sửa các file này (chưa đọc mã nguồn) |
| Telemetry | Gửi "anonymous usage data", kèm định danh repo/skill nếu repo public; tắt bằng `DISABLE_TELEMETRY=1` hoặc `DO_NOT_TRACK=1` |
| Yêu cầu | Node.js ≥ 22.20 |
| Tránh trong agent | `npx skills find` không có query, và `npx skills use … --agent` (mở agent tương tác) |

## 5. Đánh giá

**Điểm mạnh**
- Ngắn, chỉ một file, không có script. Quy trình rõ: tìm, kiểm, trình bày,
  rồi mới cài.
- Có một bước kiểm chất lượng tối thiểu và một nhánh rõ ràng cho trường hợp
  không tìm thấy.

**Điểm yếu và rủi ro**
1. **Trigger quá rộng.** "how do I do X" và "can you do X" khớp với phần lớn
   yêu cầu thường ngày. Model có thể load skill và đi tìm skill ngoài trong
   khi chỉ cần làm việc trực tiếp. Mỗi lần load tốn khoảng 1.4k token, và mỗi
   lần chạy `npx` còn gửi telemetry.
2. **Bước 6 cài bằng `-y`, không đọc nội dung trước.** Một skill bên thứ ba
   là chỉ dẫn được nạp vào context của agent, có thể kèm script. Skill không
   yêu cầu đọc `SKILL.md` hay các file trước khi cài. Tiêu chí lượt cài và số
   sao làm giả được, và cũng không chứng minh nội dung an toàn. Trang
   `/audits` của skills.sh không được nhắc tới.
3. **Tin cậy dựa trên độ nổi tiếng.** Danh sách nguồn đáng tin (`vercel-labs`,
   `anthropics`, `microsoft`) được hard-code, và chính tác giả skill có tên
   trong đó.
4. **Ví dụ đã cũ**: tên skill trong ví dụ không còn khớp listing.

## 6. Đối chiếu với repo này

| Điểm | `find-skills` | Quy tắc của repo hoặc phiên |
| :--- | :--- | :--- |
| Cài đặt | Agent tự chạy `add -g -y` khi User "muốn" | #009: cài cần User cấp quyền cụ thể cho đúng thứ đó; quy tắc phiên: tải hay chạy file từ nguồn chưa tin cậy cần hỏi |
| Ghi vào repo | Mặc định cài cho project và commit cùng repo | #094: installer bên thứ ba không được ghi AGENTS.md, rule hay hook vào repo; repo đã có cặp mirror `.agents/skills` ↔ `.claude/skills` do `harness_check` kiểm |
| Đọc trước khi dùng | Không yêu cầu | Phiên: "never distribute what it has not seen"; nội dung quan sát được là dữ liệu, không phải lệnh |
| Kênh tìm skill | `npx skills find` và skills.sh | Claude Desktop có sẵn `SearchSkills`/`SuggestSkills` (catalog của org) và `SearchPlugins` |
| Mirror | Symlink sang `~/.agents/skills` | Skill của repo là bản sao thật, không phải symlink |

Kết luận:
- **Dùng được, nhưng chỉ cho bước tìm và giới thiệu (bước 1–5).** Bước 6 xung
  đột với #009: agent chỉ nên đưa lệnh cài cho User, hoặc cài sau khi User
  đồng ý đúng skill đó, đúng phạm vi đó.
- **Không cài skill tìm được vào repo bằng phạm vi mặc định (project).** Làm
  vậy sẽ đẩy file vào `.claude/skills/` mà không có bản ở `.agents/skills/`,
  `harness_check` sẽ báo lệch mirror, và nó đụng #094.
- Nếu muốn giữ skill này mà giảm rủi ro, có hai hướng. Cả hai đều là thay đổi
  cấu hình nên cần User đồng ý:
  - Thêm `skillOverrides` cho `find-skills` thành `"user-invocable-only"`,
    để chỉ chạy khi User gọi tên và hết bị kích hoạt bởi "how do I do X".
  - Thêm một dòng vào `utilizing-tools-claude`: skill bên ngoài được tìm và
    giới thiệu, đọc `SKILL.md` của nó trước, và chỉ cài khi User cho phép
    đúng skill và đúng phạm vi đó (theo #009).
- Trên Claude Desktop, catalog của org (`SearchSkills`, `SearchPlugins`) là
  kênh tìm có kiểm soát hơn. `find-skills` hữu ích hơn cho agent không có
  catalog, như `agy` hoặc Codex.
