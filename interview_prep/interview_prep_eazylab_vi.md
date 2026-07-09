# Chuẩn bị phỏng vấn — EazyLab (Frontend Developer, ReactJS/TypeScript/GraphQL)

## Trả lời theo cấu trúc STAR (sẵn sàng dùng)

### 1. Sở hữu pattern cho Admin Dashboard *(điều JD quan tâm nhất — điểm mạnh nhất của bạn)*
- **S (Tình huống):** Tại HouseNow · CarNow, hai dòng sản phẩm cần công cụ quản trị nội bộ, nhưng các dashboard được xây dựng rời rạc trong hệ sinh thái 7 app, không có pattern nhất quán cho table/form.
- **T (Nhiệm vụ):** Tôi phụ trách phần lớn việc phát triển tính năng admin dashboard, cần ngăn team lặp lại việc giải quyết cùng một vấn đề UI/data-flow ở mỗi màn hình mới.
- **A (Hành động):** Tôi chuẩn hoá pattern cho table, form, dialog dựa trên design system chung (Shadcn UI, Tailwind, design token từ Figma), và cấu trúc lại data flow để các tính năng mới có thể tái sử dụng cùng convention.
- **R (Kết quả):** Các tính năng dashboard mới được triển khai nhanh hơn, và cả hai dashboard sản phẩm vẫn nhất quán về cấu trúc dù được xây dựng bởi nhiều người khác nhau theo thời gian.

### 2. Kinh nghiệm GraphQL (Giottolio) *(bù đắp khoảng trống cụ thể — bằng chứng GraphQL trực tiếp)*
- **S:** Công việc chính thức của tôi dùng REST/tRPC, không phải GraphQL, nên tôi chưa có bằng chứng thực tế với GraphQL.
- **T:** Tôi chủ động thiết kế dự án cá nhân Giottolio để bao gồm một GraphQL API thật trên PostgreSQL, không chỉ là một trang web tĩnh.
- **A:** Tôi tự thiết kế schema, viết query/mutation, và định nghĩa TypeScript type xuyên suốt từ database đến UI.
- **R:** Giờ tôi có thể nói cụ thể về GraphQL — thiết kế schema, cấu trúc query/mutation, kiểu dữ liệu — không chỉ là "tôi có đọc qua".

### 3. Chủ động đề xuất giải pháp (công cụ QA) — dùng cho câu hỏi "kể về lúc bạn chủ động"
- **S:** QA cần test mọi bản preview của PR trên app mobile thật, nhưng WebView trong app không thể đổi sang bản preview khác nếu không rebuild native.
- **T:** Không ai yêu cầu tôi sửa việc này — tôi nhận thấy đây là điểm nghẽn lặp lại liên tục.
- **A:** Tôi xây một màn hình dev chỉ dùng cho staging, cho phép QA đổi WebView sang bất kỳ bản preview Vercel nào ngay lập tức.
- **R:** Trở thành công cụ chuẩn của team, loại bỏ điểm nghẽn lặp lại ở mỗi chu kỳ release.

### 4. Điều phối team mà không micromanage — cho câu hỏi "lãnh đạo không cần chức danh"
- **S:** Team frontend 4 người, phụ trách toàn bộ frontend của hai sản phẩm.
- **T:** Các bản thiết kế cần được chia nhỏ thành task để làm song song.
- **A:** Tôi chia nhỏ thiết kế thành task cụ thể, review code để giữ tính nhất quán, đồng thời vẫn trực tiếp code chứ không chỉ quản lý.
- **R:** Team triển khai đều đặn mà không cần một PM riêng.

## Câu trả lời cho form ứng tuyển: "Điều gì khiến bạn muốn gia nhập công ty chúng tôi?"
> Vai trò này khớp trực tiếp với kinh nghiệm của tôi: tôi đã phụ trách phần lớn tính năng Admin Dashboard tại HouseNow · CarNow, xây dựng giao diện cho dữ liệu mật độ cao và chuẩn hoá thư viện component dùng chung giữa các layout dashboard. Tôi cũng có kinh nghiệm thực tế với real-time state (dùng Ably, SSE trong các dự án cá nhân) và Framer Motion cho animation/tương tác UI, đúng với những gì vị trí này yêu cầu. Tôi thích môi trường làm việc trực tiếp, tốc độ nhanh, và muốn phát triển sâu hơn ở mảng dashboard/data-heavy UI.

## "Structuring data flow" nghĩa là gì? (câu hỏi có thể gặp, trả lời bằng ví dụ thật)

**S (Tình huống):** Trang quản lý tin đăng ở admin dashboard HouseNow có nhiều tab trạng thái (chờ duyệt, đã duyệt, đã bán, yêu cầu chỉnh sửa, đã xoá...), mỗi tab cần filter theo người phụ trách khác nhau (PIC, approver, updater), cộng thêm search từ khoá, filter khu vực/nguồn/video, phân trang và sắp xếp — tất cả trên cùng một bảng.

**T (Nhiệm vụ):** Đảm bảo filter/pagination/sorting nhất quán, có thể chia sẻ qua URL, hoạt động đúng khi back/forward hoặc refresh trang, và tránh gọi API dư thừa mỗi lần chuyển tab hay đổi trang.

**A (Hành động):**
- Định nghĩa toàn bộ filter state bằng một Zod schema, validate trực tiếp trên URL search params của TanStack Router — filter không nằm trong local state, mà nằm trong URL
- Viết một hook riêng đọc/ghi filter thông qua router (`useSearch`/`navigate`), tự động reset về trang 1 mỗi khi filter thay đổi
- Viết một hook riêng khác để transform filter thành input cho query: tuỳ theo tab đang chọn mà map field khác nhau (ví dụ tab "chờ duyệt" lọc theo PIC, tab "đã duyệt" lọc theo approver, tab "đã xoá" lọc theo người cập nhật cuối)
- Gọi API qua TanStack Query với `placeholderData: keepPreviousData` để giữ dữ liệu trang cũ hiển thị trong lúc tải trang mới, tránh giật/nhấp nháy UI khi chuyển trang
- Dùng loader của route để prefetch trước một số dữ liệu quan trọng (ví dụ tổng số tin đăng) trước khi component render

**R (Kết quả):** Toàn bộ logic filter/pagination/sort tách hẳn khỏi UI component, tái sử dụng được cho các bảng dữ liệu khác trong dashboard, và người dùng có thể copy URL để chia sẻ đúng view họ đang xem (đúng filter, đúng tab, đúng trang).

*Đây chính là ví dụ cụ thể cho câu "establishing reusable patterns for tables... and structuring data flow" trong CV.*

## Lý do chọn EazyLab
- Vai trò này gần như đúng những gì bạn đang làm (admin dashboard, React+TS, design token từ Figma) — nên dẫn dắt bằng sự trùng khớp cụ thể này, không phải bằng sự hào hứng chung chung.
- Làm việc trực tiếp với Founder phù hợp với xu hướng thích giao tiếp trực tiếp và quyền sở hữu công việc thật sự (theo hồ sơ hành vi) — nói điều này một cách chân thật, đừng thổi phồng.
- Lộ trình lên Full-Stack Engineer được nêu trong JD khớp với định hướng phát triển bạn đã tự xác định — đây là điều thật, không phải nói cho hay.
- **Lưu ý:** Tôi không thể xác minh thêm thông tin về EazyLab ngoài nội dung JD (trang web của họ chặn truy cập) — đừng nhắc đến lịch sử/thành tựu công ty mà bạn chưa tự kiểm chứng.

## Chuẩn bị cho các câu hỏi khó
- **"Kinh nghiệm với TypeScript generics/type narrowing?"** — liên hệ từ việc dùng Zod để validate schema và TanStack Form có type; thành thật nếu chưa dùng generics nhiều.
- **"Từng xử lý permission/role trong UI chưa?"** — liên hệ từ logic phân quyền/entitlement trong hệ thống subscription tại HouseNow; thừa nhận đây là kinh nghiệm liên quan chứ không hoàn toàn giống phân quyền theo vai trò tổ chức.
- **"Vì sao kết thúc ở HouseNow tháng 4/2026?"** — câu này bạn cần tự chuẩn bị trung thực và hướng về phía trước; tôi không đoán thay.
- **"Có thoải mái làm việc trực tiếp với Founder ở startup nhỏ, ít quy trình không?"** — liên quan đến khả năng thích nghi môi trường cao của bạn; trả lời chân thật.
- **"Kinh nghiệm trực quan hóa dữ liệu lớn (data visualization cho large datasets)?"** *(gap mới phát hiện từ bản tin tuyển dụng chính thức trên trang công ty — nhấn mạnh hơn bản JD chi tiết ban đầu)* — hồ sơ của bạn có kinh nghiệm admin dashboard (task list, status, operational view) nhưng chưa có project cụ thể về biểu đồ/chart cho dataset lớn; nên thành thật và liên hệ từ kinh nghiệm xử lý bảng dữ liệu mật độ cao thay vì nhận vơ.

## Câu hỏi nên hỏi lại nhà tuyển dụng
- "Admin Dashboard hiện đã có pattern ban đầu hay mình sẽ là người thiết lập từ đầu?"
- "GraphQL schema/backend đã có sẵn, hay frontend cũng tham gia thiết kế API?"
- "Lộ trình lên Full-Stack Engineer/Quản lý dự án có mốc hay tiêu chí cụ thể không?"
- "Nhịp làm việc hằng ngày với Founder như thế nào — nhiều sync hay chủ yếu tự chủ theo task?" *(kiểm tra văn hoá họp hành nhiều, một điểm có thể gây khó chịu cho bạn)*
