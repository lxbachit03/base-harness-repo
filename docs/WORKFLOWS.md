# Toàn Cảnh Các AI Agent Workflows Hiện Đại: Phân Tích, Vấn Đề & Giải Pháp

> [!NOTE]
> **Tài liệu tham khảo nội bộ (Team-Facing Document)**:
> Tài liệu này tổng hợp và phân tích 5 trường phái kiến trúc/quy trình làm việc (Workflows) phổ biến nhất của AI Agents trong phát triển phần mềm hiện đại. Tài liệu này nhằm giúp đội ngũ kỹ thuật lựa chọn và kết hợp đúng mô hình cho từng bài toán cụ thể. Tài liệu này **không** nằm trong luồng nạp tự động của Harness repo.

---

## Mục Lục
1. [Workflow 1: Prompt Engineering & Metaprompting](#workflow-1-prompt-engineering--metaprompting)
2. [Workflow 2: Loop Engineering (Autonomous & Self-Correction Loops)](#workflow-2-loop-engineering-autonomous--self-correction-loops)
3. [Workflow 3: Graph Engineering (State Machines & Multi-Agent DAGs)](#workflow-3-graph-engineering-state-machines--multi-agent-dags)
4. [Workflow 4: Context Engineering & Advanced Retrieval](#workflow-4-context-engineering--advanced-retrieval)
5. [Workflow 5: Harness Engineering & System of Record](#workflow-5-harness-engineering--system-of-record)
6. [Ma Trận So Sánh & Khung Ra Quyết Định Lựa Chọn Workflow](#ma-trận-so-sánh--khung-ra-quyết-định-lựa-chọn-workflow)

---

## Workflow 1: Prompt Engineering & Metaprompting

### 1. Khái Niệm & Cơ Chế Hoạt Động
- **Cơ chế**: Tối ưu hóa chỉ thị đơn lẻ (Single-turn / Few-turn) truyền vào mô hình ngôn ngữ (LLM). Bao gồm kỹ thuật thiết kế System Prompts, Zero-shot/Few-shot examples, Chain-of-Thought (CoT), Persona/Role Prompting, và Structured Output Schemas (JSON/Pydantic).
- **Trường hợp sử dụng tối ưu**: Phân loại văn bản, tóm tắt nội dung, trích xuất dữ liệu có cấu trúc, dịch thuật, tạo boilerplate code đơn giản.

### 2. Vấn Đề & Cạm Bẫy (Problems & Pitfalls)
- **Giới hạn bài toán đơn bước (Single-Turn Limitation)**: Không thể tự động giải quyết các bài toán phức tạp đòi hỏi phải chạy thử mã nguồn, bắt lỗi runtime, hay phối hợp nhiều bước.
- **Không có phản hồi từ môi trường (No Environment Feedback)**: Model đưa ra dự đoán tĩnh dựa trên trọng số mà không thể xác minh xem code có chạy được trên thực tế hay không.
- **Dễ trôi dạt định dạng (Format Drift) & Bị tấn công Prompt Injection**: Khi dữ liệu đầu vào biến thiên phức tạp, model dễ vi phạm schema hoặc bị ảnh hưởng bởi nội dung độc hại.

### 3. Đề Xuất & Giải Pháp Cải Thiện
- **Sử dụng Strict Structured Outputs**: Ép kiểu dữ liệu đầu ra bằng JSON Schema hoặc Function Calling thay vì dựa vào regex parse text tự do.
- **Nâng cấp thành Tool-Assisted Prompting**: Cho phép model gọi các API/công cụ tính toán thay vì bắt model tự tính toán trong đầu.
- **Áp dụng Prompt Hardening & Metaprompts**: Sử dụng các quy chuẩn tiền xử lý (Pre-hooks/Guards) để loại bỏ mơ hồ trước khi gửi prompt đến LLM.

---

## Workflow 2: Loop Engineering (Autonomous & Self-Correction Loops)

### 1. Khái Niệm & Cơ Chế Hoạt Động
- **Cơ chế**: Đặt LLM vào một vòng lặp tự trị (Feedback Loop / ReAct Framework: *Reason $\rightarrow$ Act $\rightarrow$ Observe $\rightarrow$ Reflect*). Agent liên tục suy luận, gọi tools (terminal, file edits, web search), đọc kết quả trả về, tự sửa sai (Self-Correction) và lặp lại cho đến khi thỏa mãn điều kiện dừng.
- **Trường hợp sử dụng tối ưu**: Tự động sửa lỗi (Autonomous debugging), chạy migration scripts, viết mã kết hợp chạy test suites, quét lỗ hổng bảo mật.

### 2. Vấn Đề & Cạm Bẫy (Problems & Pitfalls)
- **Vòng lặp vô tận & Lỗi dây chuyền (Infinite Loops & Error Cascades)**: Khi gặp lỗi môi trường (ví dụ: thiếu dependency, sai quyền thư mục), Agent cố thử sai mù quáng 10-20 lượt làm cạn kiệt ngân sách token mà không giải quyết được vấn đề.
- **Tràn cửa sổ ngữ cảnh (Context Window Bloat)**: Mỗi vòng lặp nhồi thêm raw logs, stack traces và code diff vào history $\rightarrow$ Context phình to, model bị "lú lẫn" và suy giảm chất lượng suy luận.
- **Ảo tưởng hoàn thành (Premature Completion)**: Agent thấy một lệnh chạy không báo đỏ liền tự nhận là đã xong việc dù nghiệp vụ cốt lõi chưa đạt.

### 3. Đề Xuất & Giải Pháp Cải Thiện
- **Thiết lập Hard Iteration Limits & Timeout**: Giới hạn tối đa số bước trong một loop và có bộ đếm thời gian thực.
- **Cơ chế Checkpoint & Context Pruning**: Rút gọn log sau mỗi bước; chỉ giữ lại bản tóm tắt trạng thái (State Delta) thay vì toàn bộ lịch sử stdout/stderr.
- **Cơ chế Hard Gates & Observable Proofs**: Buộc Agent phải chạy script kiểm chứng độc lập trước khi được phép kích hoạt trạng thái "Done".

---

## Workflow 3: Graph Engineering (State Machines & Multi-Agent DAGs)

### 1. Khái Niệm & Cơ Chế Hoạt Động
- **Cơ chế**: Biểu diễn toàn bộ quy trình dưới dạng đồ thị có hướng (DAG) hoặc máy trạng thái hữu hạn (State Machine - ví dụ: LangGraph, AutoGen, CrewAI). Mỗi Node là một Agent hoặc một tác vụ chuyên biệt (Planner, Coder, Reviewer, Tester), các Edges đại diện cho các điều kiện rẽ nhánh và chuyển đổi trạng thái (State Transitions).
- **Trường hợp sử dụng tối ưu**: Quy trình phát triển phần mềm doanh nghiệp có nhiều vòng kiểm duyệt nghiêm ngặt (Human-in-the-loop), xử lý tài liệu đa luồng, pipeline CI/CD phức tạp.

### 2. Vấn Đề & Cạm Bẫy (Problems & Pitfalls)
- **Bùng nổ độ trễ và chi phí Token (Chatter Noise & Latency Explosion)**: Khi nhiều agent trò chuyện và bàn giao công việc qua lại, lượng token trao đổi tăng theo cấp số nhân khiến chi phí cực cao và thời gian phản hồi rất lâu.
- **Phức tạp trong Debug & Quản lý Trạng thái (State Explosion)**: Khi đồ thị phân nhánh phức tạp, rất khó lần vết xem lỗi bắt nguồn từ node nào hoặc xảy ra xung đột dữ liệu (Race condition).
- **Thiếu tính linh hoạt (Rigidity)**: Đồ thị được vẽ cứng nhắc, khi bài toán thực tế phát sinh tình huống ngoài kịch bản thì hệ thống thường bị kẹt hoặc xử lý ngớ ngẩn.

### 3. Đề Xuất & Giải Pháp Cải Thiện
- **Tối Giản Số Lượng Subagents (Lean Agent Architecture)**: Chỉ chia nhỏ agent khi thực sự cần phân tách quyền hạn (Read-only Investigator vs Write Executor); tránh việc tạo ra quá nhiều "chuyên gia" nói chuyện phiếm với nhau.
- **Shared State Schema Tinh Gọn**: Dùng schema dữ liệu chung rõ ràng, có phiên bản (Versioning) cho trạng thái của đồ thị.
- **Cổng Phê Duyệt Của Con Người (Human Checkpoints)**: Đặt điểm dừng yêu cầu con người xác nhận trước các node có tác động lớn (triển khai production, xóa database).

---

## Workflow 4: Context Engineering & Advanced Retrieval

### 1. Khái Niệm & Cơ Chế Hoạt Động
- **Cơ chế**: Tập trung vào việc chọn lọc, nén và nạp chính xác các mẩu thông tin quan trọng nhất vào Context Window của Agent tại đúng thời điểm cần thiết. Bao gồm: Hybrid Search (Vector Dense + BM25 Sparse), Code AST Indexing, Graph-RAG, Re-ranking, và Dynamic Context Injection.
- **Trường hợp sử dụng tối ưu**: Làm việc trên các codebase khổng lồ (hàng triệu dòng code), tra cứu kho tri thức tài liệu doanh nghiệp, hỏi đáp chính sách.

### 2. Vấn Đề & Cạm Bẫy (Problems & Pitfalls)
- **Mất ngữ nghĩa do chia nhỏ văn bản (Chunking Loss & Semantic Fragmentation)**: Khi cắt nhỏ code/tài liệu thành các chunks 500 tokens, các mối quan hệ logic liên hàm/liên file bị đứt gãy, dẫn đến việc LLM hiểu sai bức tranh toàn cảnh.
- **Nhiễu ngữ cảnh (Contextual Noise / Irrelevant Retrieval)**: Tìm kiếm vector trả về các đoạn text na ná từ khóa nhưng hoàn toàn sai lệch ngữ cảnh thực tế, làm phân tán sự tập trung của model.
- **Điểm mù tìm kiếm (Search Blindspots)**: Tìm kiếm từ khóa không thể nhận diện được các phụ thuộc kiến trúc ngầm (Implicit dependencies).

### 3. Đề Xuất & Giải Pháp Cải Thiện
- **Code Graph & AST Indexing**: Sử dụng cây cú pháp trừu tượng (AST) và Symbol Graph (Class, Function definitions, References) thay vì chỉ dùng Vector RAG văn bản thuần túy.
- **Mô Hình Router 2 Tầng (Two-Tier Retrieval / Top-Down Map)**: Sử dụng một file Index tổng quan định tuyến trước, sau đó mới nạp chi tiết file mục tiêu (tương tự như `INDEX.md` trong Harness).
- **Reranker Chính Xác Cao**: Luôn đưa kết quả tìm kiếm qua một Cross-Encoder Reranker để loại bỏ triệt để các chunks nhiễu.

---

## Workflow 5: Harness Engineering & System of Record

### 1. Khái Niệm & Cơ Chế Hoạt Động
- **Cơ chế**: Xây dựng một "bộ khung cương tỏa" (Harness Framework) lấy chính Repository và File System làm **System of Record (Nguồn Chân Lý Duy Nhất)**. Kết hợp:
  - **Top-Down Navigation Router (`INDEX.md`)**: Định tuyến ngữ cảnh có cấu trúc, ngăn ngừa quét file bừa bãi ($O(1)$ token routing).
  - **Kế hoạch Linh hoạt vs Kế hoạch Bền vững**: Dùng *Ephemeral Plans* cho tác vụ nhỏ có ranh giới rõ và *Durable Plans (`plans/active/`)* cho các tác vụ phức tạp dài hơi.
  - **Bộ Lọc Cổng Chặt Chẽ (Hard Gates qua `goal-griller`)**: Làm rõ 6 tiêu chí (Outcome, Success Condition, Scope Boundary, Context, Validation Loop, Stop Rules) trước khi cho phép Agent viết code.
  - **Công Cụ Kiểm Chứng Xác Định ($O(1)$ Deterministic Validators)**: Dùng script Python/Node.js để kiểm tra tính toàn vẹn thay vì bắt AI tự suy luận ngữ nghĩa tốn kém.
  - **Ràng Buộc Kép Rủi ro - Đề xuất (Risk-to-Proposal Constraint)**: Mọi rủi ro phát hiện đều phải đi kèm đề xuất giải pháp khả thi.
- **Trường hợp sử dụng tối ưu**: Phát triển phần mềm nghiêm ngặt, tự động hóa tác vụ code phức tạp nhiều phiên, duy trì tính bền vững và nhất quán lâu dài của dự án AI-assisted.

### 2. Vấn Đề & Cạm Bẫy (Problems & Pitfalls)
- **Chi phí Duy trì Đồng bộ (Synchronization Overhead)**: Nếu người dùng hoặc agent thêm/xóa file trong thư mục harness mà quên cập nhật `INDEX.md`, luồng routing có thể bị đứt gãy.
- **Đòi hỏi Kỷ luật Cao (Discipline Requirement)**: Người dùng có thể cảm thấy phiền nếu Agent liên tục hỏi làm rõ (Hard Gate Interview) cho các tác vụ cực kỳ đơn giản.

### 3. Đề Xuất & Giải Pháp Cải Thiện
- **Script Tự Động Đồng Bộ Cục Bộ (`sync-harness-index.js --fix`)**: Tự động phát hiện và chèn các liên kết mới vào `INDEX.md`, giải phóng con người khỏi việc cập nhật thủ công.
- **Cơ Chế Phân Luồng Linh Hoạt (Triage & Route)**: Tự động phân loại tác vụ: việc nhỏ thì dùng nhánh `direct` (không tạo goal rườm rà), việc lớn thì mới kích hoạt `goal-griller` đầy đủ.
- **Cá Nhân Hóa Trải Nghiệm Qua `PERSONA.md`**: Cho phép người dùng chuyển đổi phong cách giao tiếp (Minimalist, Mentor, Pair Programmer) mà không làm ảnh hưởng đến kỷ luật kỹ thuật.

---

## Ma Trận So Sánh & Khung Ra Quyết Định Lựa Chọn Workflow

| Tiêu Chí Đánh Giá | Prompt Engineering | Loop Engineering | Graph Engineering | Context / RAG | Harness Engineering |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Mức độ tự trị (Autonomy)** | Thấp (1 lượt) | Cao (Tự lặp) | Trung bình - Cao | Thấp - Trung bình | Rất cao (Có kiểm soát) |
| **Mức tiêu thụ Token** | Rất thấp ($O(1)$) | Rất cao ($O(N)$) | Cao ($O(M \times N)$) | Trung bình | Tối ưu ($O(1)$ Router) |
| **Khả năng kiểm soát (Control)** | Rất cao | Thấp (Dễ drift) | Rất cao (Theo đồ thị) | Trung bình | Cực kỳ chặt chẽ |
| **Khả năng tự sửa lỗi (Self-Correction)**| Không có | Rất tốt | Theo kịch bản | Phụ thuộc Prompt | Tốt (Có kiểm chứng độc lập) |
| **Độ phức tạp cài đặt** | Cực kỳ đơn giản | Đơn giản | Phức tạp | Trung bình | Trung bình - Chuẩn hóa |
| **Phù hợp nhất cho bài toán** | Task đơn lẻ, trích xuất dữ liệu | Debugging nhanh, script ngắn | Pipeline DN, quy trình nhiều bước | Codebase lớn, hỏi đáp tri thức | **Phát triển phần mềm dài hạn, dự án quy mô** |

---

### Khung Khuyến Nghị Lựa Chọn Kiến Trúc (Decision Guide):
1. **Dùng Prompt Engineering** khi: Bạn chỉ cần xử lý văn bản, tóm tắt, trích xuất JSON nhanh trong 1 turn.
2. **Dùng Loop Engineering** khi: Cần AI tự động fix một bug cụ thể, có unit test rõ ràng để làm điều kiện dừng (stopping criteria).
3. **Dùng Graph Engineering** khi: Có một quy trình nghiệp vụ cố định nhiều bước với các vai trò tách biệt rõ ràng và cần con người phê duyệt ở giữa.
4. **Dùng Context / RAG** khi: Cần mở rộng bộ nhớ tra cứu trên kho tài liệu khổng lồ vượt quá context window.
5. **Dùng Harness Engineering** khi: Cần xây dựng một hệ thống pair-programming bền vững, có kiểm soát rủi ro, tiết kiệm token, duy trì ngữ cảnh xuyên suốt giữa nhiều session và đảm bảo code viết ra luôn có bằng chứng kiểm thử thực tế.
