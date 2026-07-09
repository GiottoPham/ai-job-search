# Interview Prep — EazyLab (Frontend Developer, ReactJS/TypeScript/GraphQL)

## STAR Answers (ready to use)

### 1. Admin Dashboard pattern ownership *(their #1 ask — strongest match)*
- **S:** At HouseNow · CarNow, two product lines needed internal admin tooling, but dashboards had grown ad hoc across a 7-app ecosystem with no consistent table/form patterns.
- **T:** I owned the majority of admin dashboard feature development and needed to stop the team from re-solving the same UI/data-flow problems on every new screen.
- **A:** I standardized table, form, and dialog patterns on our shared design system (Shadcn UI, Tailwind, Figma-sourced tokens), and structured the data flow so new features could reuse the same conventions.
- **R:** New dashboard features shipped faster, and both products' dashboards stayed structurally consistent despite different people building them over time.

### 2. GraphQL depth (Giottolio) *(bridges the one concrete gap — direct GraphQL evidence)*
- **S:** My paid work used REST/tRPC, not GraphQL, so I had no hands-on GraphQL evidence.
- **T:** I scoped my personal project, Giottolio, to include a real GraphQL API on PostgreSQL, not just a static site.
- **A:** I designed the schema, wrote queries/mutations, and modeled TypeScript types end-to-end from database to UI.
- **R:** I can now speak to GraphQL concretely — schema design, query/mutation shape, typing — not just "I've read about it."

### 3. Proactive initiative (QA tool) — for "tell me about a time you took initiative"
- **S:** QA needed to test every PR's preview build on the real mobile app, but the WebView couldn't be redirected without a native rebuild.
- **T:** Nobody asked me to fix it — I noticed it was a repeated bottleneck.
- **A:** Built a staging-only dev screen letting QA switch the WebView to any Vercel preview instantly.
- **R:** Became a standard team tool, removed a recurring drag on every release cycle.

### 4. Coordinating without micromanaging — for "leadership without authority"
- **S:** 4-person frontend team owning the full frontend surface of two products.
- **T:** Design handoffs needed breaking into parallel, assignable work.
- **A:** Broke designs into scoped tasks, ran code reviews for consistency, stayed hands-on with implementation myself.
- **R:** Team shipped consistently without a dedicated PM layer.

## "What does 'structuring data flow' mean?" (likely question — real example)

**S:** HouseNow's admin dashboard listing-management page had multiple status tabs (pending review, approved, sold, needs changes, deleted...), each needing to filter by a different assignee role (PIC, approver, updater), plus search, locality/source/video filters, pagination, and sorting — all on one table.

**T:** Keep filter/pagination/sorting consistent, shareable via URL, correct on back/forward/refresh, and avoid redundant API calls on every tab switch or page change.

**A:**
- Defined the entire filter state as a Zod schema validated directly against the router's URL search params — filters live in the URL, not local state
- Wrote a dedicated hook to read/write filters through the router (`useSearch`/`navigate`), auto-resetting to page 1 whenever a filter changed
- Wrote a separate hook to transform the filter into the actual query input: depending on which tab was active, it mapped a different assignee field (e.g., the "pending review" tab filters by PIC, "approved" by approver, "deleted" by last updater)
- Called the API through TanStack Query with `placeholderData: keepPreviousData` so the previous page's data stayed visible while the next page loaded, avoiding UI flicker
- Used the route's loader to prefetch key data (like the total listing count) before the component even rendered

**R:** All filter/pagination/sort logic was decoupled from the UI components, reusable across other data tables in the dashboard, and users could copy the URL to share the exact view they were looking at (same filter, tab, and page).

*This is the concrete example behind the CV line "establishing reusable patterns for tables... and structuring data flow."*

## "Why EazyLab" Talking Points
- The role is close to exactly what you already do (admin dashboard, React+TS, design tokens from Figma) — lead with that concrete overlap, not enthusiasm.
- Working directly with the Founder appeals to your preference for direct communication and real ownership over layered management (per behavioral profile) — say this honestly, don't oversell it.
- The stated path to Full-Stack Engineer matches your own stated growth direction — genuine, not spin.
- **Caution:** EazyLab's specifics beyond the JD text weren't verifiable (their site blocked WebFetch) — don't reference anything about their history/traction you haven't independently confirmed yourself.

## Prep for Likely Tough Questions
- **"Kinh nghiệm với TypeScript generics/type narrowing?"** — bridge from Zod schema validation and TanStack Form typed usage; be honest if generics haven't been used extensively.
- **"Từng xử lý permission/role trong UI chưa?"** — bridge from subscription/entitlement-gating logic at HouseNow; acknowledge it's adjacent, not identical to org role-based permissions.
- **"Vì sao kết thúc ở HouseNow tháng 4/2026?"** — prep this one honestly and forward-looking; not pre-written here.
- **"Thoải mái làm việc trực tiếp với Founder ở startup nhỏ, ít process?"** — ties to high environment-adaptability trait; answer genuinely.
- **"Experience with data visualization for large datasets?"** *(new gap found in the company's own direct posting — emphasized more than the original detailed JD)* — your admin dashboard experience is task lists/statuses/operational views, not specifically chart/graph-style visualization of large datasets; bridge honestly from high-density table experience rather than overclaiming.

## Questions to Ask Them
- "Admin Dashboard hiện đã có pattern ban đầu hay mình sẽ là người thiết lập từ đầu?"
- "GraphQL schema/backend đã có sẵn, hay frontend cũng tham gia thiết kế API?"
- "Lộ trình lên Full-Stack Engineer/Quản lý dự án có mốc hay tiêu chí cụ thể không?"
- "Nhịp làm việc hằng ngày với Founder như thế nào — nhiều sync hay chủ yếu tự chủ theo task?" *(checks for meeting-heavy culture, a stated friction point)*
