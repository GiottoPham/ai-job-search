# Chuẩn bị phỏng vấn — VNGGames (Software Engineer / Frontend Engineer, Mobile/Web)

Vị trí: Frontend Engineer (Mobile/Web), team Game Publishing Platform, Thành phố Hồ Chí Minh
Mã tin: 26-PEN-3790 · https://vn.linkedin.com/jobs/view/frontend-engineer-mobile-web-at-vnggames-4436539441

## Vòng 1 — HR Screening

| # | Câu hỏi | Ý chính cần chuẩn bị |
|---|----------|------------------------|
| 1 | "Giới thiệu về bản thân / kể về quá trình làm việc của bạn." | 4+ năm kinh nghiệm đưa React và React Native lên production (Nobee -> HouseNow · CarNow). Dẫn đầu bằng hệ thống subscription IAP — full release lifecycle, App Store và Google Play — vì đây là yêu cầu số 1 trong tin tuyển dụng. Kết bằng thói quen làm việc AI-tool-forward (Claude Code) vì tin tuyển dụng nhắc trực tiếp điều này. |
| 2 | "Vì sao bạn quan tâm đến vị trí này ở VNGGames?" | VNGGames đang mở rộng quốc tế theo chiến lược Go Global (Roblox VN, NARAKA: Bladepoint, Legend Reborn) — UI System Library và Game Publishing Platform cần duy trì nhất quán trên nhiều title cùng lúc, không chỉ một sản phẩm. Đây chính là bài toán nhất quán bạn đã giải quyết cho hệ sinh thái 7 app, 15+ shared package của HouseNow · CarNow ở quy mô 400k+ user. Nói điều này một cách chân thật, không phải lời khen sáo rỗng — đây là điểm trùng khớp thật. |
| 3 | "Vì sao bạn nghỉ ở HouseNow · CarNow?" (kết thúc 04/2026) | Câu này cần chuẩn bị trung thực và hướng về phía trước — không viết sẵn ở đây. Tránh nói tiêu cực về công ty cũ; nên gắn với điều bạn đang tìm kiếm tiếp theo (nền tảng live-service quy mô lớn, chiều sâu mobile hơn). |
| 4 | "Mức lương mong muốn của bạn là bao nhiêu?" | Mức sàn là 1.000+ USD/tháng (mức tối thiểu bạn đặt ra). Đưa ra một khoảng, không phải một con số cố định, và neo theo mặt bằng thị trường cho kỹ sư frontend/mobile 4+ năm kinh nghiệm tại TP.HCM nếu bạn có con số cụ thể trong đầu. |
| 5 | "Bạn có thể bắt đầu khi nào / thời gian báo trước?" | Có thể bắt đầu ngay. |
| 6 | "Bạn có thoải mái làm onsite/hybrid tại TP.HCM không?" | Có — hoàn toàn khớp với vị trí địa lý và điều kiện của bạn, không cần chuyển chỗ ở. |
| 7 | "Tin tuyển dụng có nhắc đến việc hỗ trợ vận hành live service và xử lý sự cố ảnh hưởng người chơi — bạn có thoải mái với phạm vi này, kể cả khả năng phải xử lý ngoài giờ không?" | Nên hỏi ngược lại một phần (xem mục "Câu hỏi nên hỏi lại" bên dưới) — ràng buộc cứng của bạn là Thứ Hai đến Thứ Sáu, không làm cuối tuần. Hỏi rõ xem "vận hành live service" có bao gồm lịch trực/on-call hay không trước khi giả định là không. |
| 8 | "Bạn biết đến vị trí này từ đâu?" | Qua LinkedIn. |

## Vòng 2 — Technical Interview

| # | Câu hỏi | Ý chính cần chuẩn bị |
|---|----------|------------------------|
| 1 | "Kể về một app React Native bạn đã đưa lên production, từ đầu đến cuối." | **Đã có sẵn theo STAR.** Hệ thống subscription tại HouseNow · CarNow: in-app purchase cho iOS và Android qua toàn bộ release lifecycle (build qua Expo/EAS, internal test build, production build/.ipa/.apk, submit lên App Store + Google Play, qua review), cộng thêm luồng thanh toán QR-code cho web. Đây là bằng chứng mạnh nhất, khó "làm giả" nhất, khớp trực tiếp với yêu cầu "Proven Mobile Development Experience" của họ. |
| 2 | "Kể về kinh nghiệm xây dựng hoặc duy trì UI component library / design system dùng chung." | Đóng góp vào design system dựa trên Shadcn UI với design token riêng cho từng sản phẩm, tái sử dụng trên 7 app và 15+ shared package tại HouseNow · CarNow, giữ tính nhất quán và accessibility (WCAG AA) trong toàn hệ sinh thái. Khớp trực tiếp với mảng "UI System Library" họ đang tìm. |
| 3 | "Bạn dùng công cụ AI (Claude, Cursor) trong công việc hằng ngày như thế nào?" | Dùng Claude Code cho việc sửa bug và khám phá code: lấy context task từ Linear qua MCP, tham chiếu tài liệu convention riêng của từng dự án (component, layout, pattern gọi API) để giữ output nhất quán, review trước khi merge. Cũng dùng để xây dựng tính năng end-to-end trên CareerReady. Cần nói rõ về *quy trình*, không chỉ nhắc tên công cụ — tin tuyển dụng này quan tâm đến cách dùng, không chỉ việc có dùng hay không. |
| 4 | "Bạn đã từng làm việc với kiến trúc micro-frontend như Single-Spa hay SystemJS chưa?" | **Khoảng trống thật — không nói quá.** Chưa có kinh nghiệm trực tiếp. Liên hệ: 4+ năm giữ UI nhất quán trên nhiều app dùng chung package (7 app, 15+ shared package) chính là tư duy kiến trúc modular tương tự, chỉ ở một tầng khác. Cách tiếp cận: hiểu rõ ràng buộc trước, rồi triển khai dần từng bước. |
| 5 | "Bạn xử lý việc giám sát/khắc phục sự cố production đang ảnh hưởng người dùng thật như thế nào?" | **Đã có sẵn theo STAR.** Xây một màn hình dev chỉ dùng cho staging trong app React Native, cho phép QA đổi WebView sang bất kỳ bản preview Vercel nào ngay lập tức, không cần rebuild native — không ai yêu cầu, bạn tự nhận ra điểm nghẽn lặp lại ở mỗi chu kỳ release và tự sửa. Khớp trực tiếp với yêu cầu "live service operations, monitoring, and troubleshooting" của họ. |
| 6 | "Bạn xử lý state management và API/data fetching trong app React hoặc React Native như thế nào?" | Zustand cho state, TanStack Query cho server state/caching. Nhắc đến việc phối hợp với backend engineer về entitlement/payment API trong hệ thống subscription như một ví dụ cụ thể về collaboration API. |
| 7 | "Bạn tiếp cận việc testing frontend và mobile như thế nào?" | Jest, React Testing Library, Playwright — unit và end-to-end, là một phần chuẩn trong code review, không phải làm thêm sau cùng. |
| 8 | "Bạn làm việc với backend engineer để thiết kế và tích hợp API như thế nào?" | Hệ thống subscription cần phối hợp chặt với entitlement và payment API — bạn không chỉ tiêu thụ một API có sẵn, mà cùng backend engineer định hình contract theo nhu cầu của luồng mobile/web. Khớp trực tiếp với yêu cầu "Collaborate with backend engineers to integrate APIs". |
| 9 | "Kinh nghiệm của bạn về web performance, Core Web Vitals, hoặc frontend security (XSS, auth) như thế nào?" | **Khoảng trống thật — chưa có bằng chứng cụ thể.** Đừng bịa câu chuyện ở đây. Có thể nói chung về việc xây dựng app Next.js/Vercel có quan tâm đến performance, và authentication qua OAuth (từ CareerReady), nhưng cần thẳng thắn rằng bạn chưa đo/tối ưu Core Web Vitals cụ thể. Nói "tôi chưa đi sâu vào mảng này, nhưng đây là những gì liên quan tôi đã làm" tốt hơn là bịa ra một con số. |
| 10 | "Bạn sẽ tiếp cận việc giữ UI System Library nhất quán trên nhiều title game khác nhau như thế nào?" | Câu hỏi kiểu system-design — dùng ví dụ cấu trúc data flow (đã chuẩn bị cho EazyLab) làm mô hình tư duy cho dạng bài toán này (quản lý state, pattern tái sử dụng, tránh giải lại cùng một vấn đề UI/data ở mỗi bề mặt), áp dụng cho "title" thay vì "sản phẩm". |
| 11 | "Bạn thấy mình ở đâu trong vài năm tới?" | Gắn với định hướng nghề nghiệp: đào sâu chuyên môn frontend/mobile, đồng thời có không gian phát triển thêm chiều sâu backend và system design ở quy mô lớn — chân thật, khớp với định hướng bạn đã tự xác định, không nói chung chung cho có. |
| 12 | "Điểm yếu lớn nhất của bạn là gì?" | Chuẩn bị một điểm yếu thật với cách khắc phục cụ thể — không viết sẵn ở đây, cần thật và cá nhân. |

## Câu trả lời mẫu đầy đủ

Cấu trúc đơn giản cho mỗi câu: **trả lời trực tiếp một câu -> 1-2 câu bằng chứng cụ thể -> câu kết hướng về phía trước.** Giữ trong khoảng 30-60 giây, trừ khi là câu hỏi kỹ thuật sâu.

### Vòng 1 — HR Screening

**1. Giới thiệu về bản thân.**
"Tôi là kỹ sư frontend với 4+ năm kinh nghiệm đưa React và React Native lên production. Gần đây nhất tại HouseNow · CarNow, tôi phụ trách toàn bộ hệ thống subscription — in-app purchase cho iOS và Android qua toàn bộ release lifecycle, cộng thêm luồng thanh toán web — cho nền tảng có 400k+ người dùng. Tôi cũng làm việc theo hướng AI-tool-forward, dùng Claude Code hằng ngày cho cả việc sửa bug lẫn xây dựng tính năng mới hoàn chỉnh. Tôi đang tìm cơ hội mang sự sở hữu mobile-và-web đó đến một nền tảng live-service quy mô lớn, đó là lý do vị trí này thu hút tôi."

**2. Vì sao bạn quan tâm đến vị trí này ở VNGGames?**
"VNGGames đang mở rộng sang các thị trường mới theo chiến lược Go Global, có nghĩa là UI System Library và nền tảng của các bạn cần duy trì nhất quán trên nhiều title cùng lúc, không chỉ một sản phẩm. Đó chính xác là bài toán nhất quán tôi đã giải quyết ở HouseNow · CarNow, giữ design system nhất quán trên 7 app và 15+ shared package. Tôi muốn tiếp tục giải bài toán đó ở quy mô của các bạn."

**3. Vì sao bạn nghỉ ở HouseNow · CarNow?**
*(Điền thật — đây chỉ là khung mẫu.)* "[Nêu lý do thật một cách thẳng thắn — ví dụ hợp đồng kết thúc, muốn tìm phạm vi công việc mới, v.v.] Tôi đang tìm [điều bạn thực sự muốn tiếp theo: quy mô lớn hơn, chiều sâu mobile hơn, v.v.], đó cũng là một phần lý do vị trí này thu hút tôi."

**4. Mức lương mong muốn của bạn là bao nhiêu?**
"Mức sàn của tôi là 1.000+ USD/tháng, và tôi muốn ở mức cạnh tranh so với mặt bằng thị trường cho kỹ sư frontend/mobile 4+ năm kinh nghiệm tại TP.HCM. Tôi sẵn sàng bàn cụ thể hơn khi hiểu rõ toàn bộ cơ cấu đãi ngộ."

**5. Bạn có thể bắt đầu khi nào?**
"Tôi có thể bắt đầu ngay."

**6. Bạn có thoải mái làm onsite/hybrid tại TP.HCM không?**
"Có, tôi đang ở TP.HCM nên onsite hay hybrid đều phù hợp với tôi."

**7. Bạn có thoải mái hỗ trợ vận hành live service, kể cả khả năng phải xử lý ngoài giờ không?**
"Tôi thoải mái với việc chịu trách nhiệm về reliability và giám sát hệ thống — thực tế tôi từng tự xây một công cụ QA ở công ty cũ chỉ để giảm ma sát trong chu kỳ release. Có một điều tôi muốn hiểu rõ hơn là việc này có bao gồm lịch on-call hay không, vì lịch làm việc Thứ Hai đến Thứ Sáu là một ràng buộc bắt buộc với tôi. Anh/chị có thể chia sẻ thêm về việc này trong thực tế không?"

**8. Bạn biết đến vị trí này từ đâu?**
"Qua LinkedIn."

### Vòng 2 — Technical Interview

**1. Kể về một app React Native bạn đã đưa lên production.**
"Tại HouseNow · CarNow tôi phụ trách toàn bộ hệ thống subscription — in-app purchase cho iOS và Android. Việc này bao gồm xây dựng tính năng, tạo internal test build rồi production build qua Expo/EAS, submit lên App Store và Google Play, xử lý quá trình review, cộng thêm luồng thanh toán QR-code cho web. Tôi cũng phối hợp chặt với backend engineer về entitlement và payment API phía sau, vì cả luồng mobile và web đều phụ thuộc vào cùng một contract backend."

**2. Kể về kinh nghiệm xây dựng hoặc duy trì UI component library dùng chung.**
"Tôi đóng góp vào design system dựa trên Shadcn UI với design token riêng cho từng sản phẩm, được tái sử dụng trên 7 app và 15+ shared package tại HouseNow · CarNow. Mục tiêu là giữ UI nhất quán và đạt accessibility — WCAG AA cho các luồng chính — dù nhiều người khác nhau xây dựng các app khác nhau trên nền đó theo thời gian."

**3. Bạn dùng công cụ AI như Claude Code trong công việc hằng ngày như thế nào?**
"Tôi dùng Claude Code cho cả việc sửa bug lẫn xây dựng tính năng hoàn chỉnh. Với sửa bug, tôi lấy context task từ Linear qua MCP và chỉ nó vào tài liệu convention riêng của dự án — pattern component, layout, cách gọi API — để output nhất quán với phần còn lại của codebase, rồi review trước khi merge. Với dự án cá nhân như CareerReady, tôi dùng nó để xây dựng toàn bộ tính năng từ đầu đến cuối. Vấn đề không nằm ở việc công cụ viết code nhanh hơn, mà là giữ một quy trình nhất quán xung quanh nó."

**4. Bạn đã từng làm việc với kiến trúc micro-frontend như Single-Spa hay SystemJS chưa?**
"Chưa trực tiếp. Điều tôi đã làm trong 4+ năm là giữ UI nhất quán trên nhiều app dùng chung package bên dưới, đó là tư duy kiến trúc modular tương tự, chỉ ở một tầng khác so với Single-Spa hay SystemJS cụ thể. Cách tiếp cận của tôi với bất kỳ kiến trúc mới nào cũng vậy: hiểu rõ ràng buộc trước, rồi triển khai dần từng bước thay vì cố thiết kế lại mọi thứ ngay từ đầu."

**5. Bạn xử lý việc giám sát hoặc khắc phục sự cố production như thế nào?**
"Một ví dụ cụ thể: QA cần test bản preview của mọi PR trên app mobile thật, nhưng WebView trong app không thể đổi sang bản preview khác nếu không rebuild native, làm chậm mỗi chu kỳ release. Không ai yêu cầu tôi sửa việc này, nhưng tôi đã xây một màn hình dev chỉ dùng cho staging, cho phép QA đổi WebView sang bất kỳ bản preview Vercel nào ngay lập tức. Nó trở thành công cụ chuẩn của team và loại bỏ một điểm nghẽn lặp lại trong quy trình release."

**6. Bạn xử lý state management và API/data fetching như thế nào?**
"Tôi dùng Zustand cho client state và TanStack Query cho server state và caching. Ở hệ thống subscription, việc này có nghĩa là phối hợp chặt với backend engineer để định hình contract entitlement và payment API theo đúng nhu cầu của luồng mobile và web, không chỉ tiêu thụ những gì đã có sẵn."

**7. Bạn tiếp cận việc testing frontend và mobile như thế nào?**
"Jest và React Testing Library cho unit và component test, Playwright cho end-to-end. Viết test là một phần chuẩn trong code review của tôi, không phải thứ làm thêm sau cùng."

**8. Bạn làm việc với backend engineer để thiết kế và tích hợp API như thế nào?**
"Ở hệ thống subscription, tôi không chỉ tiêu thụ một API có sẵn — tôi cùng backend engineer định hình contract entitlement và payment dựa trên nhu cầu của cả luồng mua hàng trên mobile lẫn luồng QR-code trên web. Kiểu phối hợp chặt chẽ đó là bình thường với tôi ở bất cứ việc gì liên quan đến tiền hoặc trạng thái người dùng."

**9. Kinh nghiệm của bạn về web performance, Core Web Vitals, hoặc frontend security như thế nào?**
"Thành thật thì tôi chưa đi sâu vào việc đo Core Web Vitals hay hardening XSS một cách tập trung — đây chưa phải là mảng tôi mạnh nhất tính đến giờ. Điều liên quan: tôi đã xây dựng app Next.js có quan tâm đến performance, deploy trên Vercel, và triển khai authentication qua OAuth trên CareerReady. Tôi muốn nói thẳng đây chưa phải thế mạnh đã được chứng minh, hơn là nói quá lên."

**10. Bạn sẽ giữ UI System Library nhất quán trên nhiều title game khác nhau như thế nào?**
"Tôi sẽ bắt đầu bằng việc tách rõ phần dùng chung — token, primitive, pattern layout — khỏi phần riêng cho từng title, và đảm bảo tầng dùng chung có một nguồn chân lý duy nhất thay vì để mỗi team title tự fork riêng. Ở HouseNow · CarNow tôi đã làm việc tương tự: định nghĩa pattern state và data-fetching dùng chung một lần để các tính năng dashboard mới không phải giải lại cùng một vấn đề mỗi lần. Tôi sẽ áp dụng tư duy tương tự ở đây: tìm vấn đề lặp lại, giải nó một lần, làm cho nó dễ tái sử dụng đúng cách."

**11. Bạn thấy mình ở đâu trong vài năm tới?**
"Tôi muốn tiếp tục đào sâu chuyên môn frontend và mobile — React, Next.js, React Native — đồng thời phát triển thêm chiều sâu backend và trách nhiệm system-design theo thời gian. Phạm vi của vị trí này, phụ trách một nền tảng dùng chung cho nhiều title, chính là quy mô sẽ giúp tôi phát triển theo hướng đó."

**12. Điểm yếu lớn nhất của bạn là gì?**
*(Điền thật — đây chỉ là khung mẫu.)* "[Nêu một điểm yếu thật.] Cách tôi khắc phục là [cách xử lý cụ thể bạn thực sự đang áp dụng]."

## Trả lời theo cấu trúc STAR (sẵn sàng dùng)

### 1. Hệ thống subscription React Native — full release lifecycle
- **S (Tình huống):** HouseNow · CarNow cần một hướng monetization xuyên suốt iOS, Android và web cho nền tảng 400k+ người dùng.
- **T (Nhiệm vụ):** Phụ trách toàn bộ hệ thống subscription, không chỉ phần UI.
- **A (Hành động):** Xây dựng và đưa in-app purchase cho iOS và Android lên production qua toàn bộ release lifecycle (build qua Expo/EAS, internal test build, production build, submit và qua review trên App Store + Google Play), cộng thêm luồng thanh toán QR-code cho web, phối hợp chặt với backend engineer về entitlement và payment API phía sau.
- **R (Kết quả):** Một hệ thống monetization xuyên nền tảng hoạt động thật trên production — kinh nghiệm mobile-release trên production cụ thể, có thể kiểm chứng, không phải lý thuyết.

### 2. Công cụ chủ động cải thiện reliability — màn hình dev staging cho QA
- **S:** QA cần test bản preview của mọi PR trên app mobile thật, nhưng WebView trong app không thể đổi sang bản preview khác nếu không rebuild native — điểm nghẽn lặp lại liên tục.
- **T:** Không ai giao việc này — tự nhận ra vấn đề.
- **A:** Xây một màn hình dev chỉ dùng cho staging, cho phép QA đổi WebView sang bất kỳ bản preview Vercel nào ngay lập tức.
- **R:** Trở thành công cụ chuẩn của team, loại bỏ điểm nghẽn lặp lại ở mỗi chu kỳ release. Khớp trực tiếp với yêu cầu "live service operations, monitoring, and troubleshooting" của VNGGames.

### 3. Sở hữu design system / UI System Library
- **S:** Hai dòng sản phẩm (HouseNow, CarNow) có nguy cơ lệch nhau về giao diện và cấu trúc trên 7 app và 15+ shared package.
- **T:** Giữ UI nhất quán và đạt accessibility mà không làm chậm tốc độ phát triển tính năng.
- **A:** Đóng góp vào design system dựa trên Shadcn UI với design token riêng cho từng sản phẩm, tái sử dụng trong toàn hệ sinh thái, đạt WCAG AA cho các luồng chính.
- **R:** UI nhất quán trên các sản phẩm được xây dựng bởi nhiều người khác nhau theo thời gian — đúng dạng bài toán như UI System Library của VNGGames, chỉ áp dụng cho một hệ sinh thái khác.

### 4. Phát triển với AI — Claude Code trong quy trình hằng ngày
- **S:** Việc sửa bug và khám phá code tại HouseNow · CarNow cần giữ nhất quán với convention hiện có dù áp lực thời gian.
- **T:** Dùng công cụ AI để tăng tốc mà không đánh đổi chất lượng code hay tính nhất quán.
- **A:** Dùng Claude Code với context task lấy từ Linear (qua MCP), tham chiếu tài liệu convention riêng của dự án (component, layout, pattern tích hợp API), review output trước khi merge. Cũng dùng Claude Code để xây dựng tính năng end-to-end trên các dự án cá nhân (CareerReady, Giottolio).
- **R:** Xử lý bug và tính năng nhanh hơn trong khi vẫn giữ output khớp với convention của team — khớp trực tiếp với yêu cầu "leverage AI-powered tools (Claude, Cursor)" trong tin tuyển dụng.

## Lý do chọn VNGGames
- Chiến lược mở rộng Go Global (Roblox VN, NARAKA: Bladepoint, Legend Reborn — đã xác minh qua tài liệu SDK của VNGGames và thông tin công khai) có nghĩa là nền tảng cần mở rộng quy mô trên nhiều title, đúng bài toán nhất quán bạn đã giải quyết ở quy mô 400k+ người dùng. Dẫn đầu bằng điều này, không phải sự hào hứng chung chung.
- Tránh trích dẫn các giá trị cốt lõi của VNG ("Embracing Challenges", v.v.) — đây là ngôn ngữ HR chung chung, không phải điểm khác biệt thật sự.
- Yêu cầu rõ ràng về khả năng dùng công cụ AI (Claude, Cursor) trong tin tuyển dụng là một điểm trùng khớp hiếm gặp với kinh nghiệm Claude Code của bạn — nói điều này thẳng thắn, đây không phải sự gượng ép.

## Khoảng trống cần xử lý trung thực (đừng nói quá trong buổi phỏng vấn)
- **Kiến trúc micro-frontend (Single-Spa, SystemJS):** chưa có kinh nghiệm trực tiếp — liên hệ từ công việc giữ nhất quán trên nhiều app/shared package.
- **Đo lường Core Web Vitals / performance, chi tiết frontend security (XSS, xử lý cookie):** chưa có bằng chứng cụ thể — thừa nhận thẳng thắn thay vì bịa ra một con số hay sự cố.
- **Cách định vị cấp bậc:** LinkedIn gắn tin này là "Entry level" dù yêu cầu đọc như mid-level (3+ năm). Nếu người phỏng vấn có xu hướng đánh giá bạn ở mức junior, hãy tự tin nhắc lại phạm vi sở hữu thực tế của bạn (sở hữu hệ thống từ đầu đến cuối, điều phối team 4 người) thay vì hạ thấp bản thân.

## Câu hỏi nên hỏi lại nhà tuyển dụng
- "UI System Library hiện đang phục vụ bao nhiêu title, và team duy trì tính nhất quán như thế nào khi con số đó tăng lên theo chiến lược Go Global?"
- "'Vận hành live service' trong thực tế của vị trí này là như thế nào — có lịch on-call không, và có bao giờ kéo dài sang cuối tuần không?" *(kiểm tra trực tiếp với ràng buộc Thứ Hai-Thứ Sáu của bạn — hỏi trước khi giả định)*
- "Claude/Cursor hiện được tích hợp vào quy trình của team như thế nào trong thực tế — dùng cá nhân, hay có convention/quy trình chung?"
- "Mức kinh nghiệm trong team hiện tại phân bổ ra sao — có bao nhiêu kỹ sư ở cấp độ tương tự, và tôi sẽ làm việc gần nhất với ai hằng ngày?"
- "Thành công ở vị trí này trong 6 tháng đầu được định nghĩa như thế nào?"
