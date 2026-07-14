# Interview Prep — Haiper-X (AI Full-Stack Engineer) — Technical

**Source:** [CareerViet JD](https://careerviet.vn/vi/tim-viec-lam/ky-su-ai-full-stack-hoac-product-designer-kieu-maker.35C7B9DB.html) — 2 openings, 3–5 years exp, 35–70M VND, deadline 30/07/2026.

**What the JD actually wants:** full-stack web (React/Next.js + a backend framework), hands-on LLM API experience (Claude/OpenAI/Gemini), AI-native workflow with coding agents (Claude Code/Cursor/Codex). Nice-to-have: production AI-agent deployment, RAG/vector DB/MCP, a 0→1 launch portfolio piece.

Every answer is short, complete sentences (subject + verb) so you can say it out loud as-is. System/architecture questions use **RADIO** (Requirements, Architecture, Data model, Interface, Optimizations) compressed into a casual answer, not a section-by-section essay. "Tell me about a time" technical questions use **STAR**, also compressed, not labeled.

---

## Stack Knowledge

1. **What's your experience with React and Next.js in production?**
> "I've used React and Next.js in production for about 4 years. Most recently, I built the CarNow and HouseNow web apps and admin dashboards, plus the Next.js marketing sites for both products."

2. **What's your experience with TypeScript?**
> "I use TypeScript across everything I build, both frontend and backend, including schema-driven typing with tRPC and Zod."

3. **What's your backend experience with Node and Express?**
> "My hands-on backend experience comes from CareerReady, where I built the whole Express and Postgres backend myself. I also had close collaboration on backend schema design at CarNow."

4. **What's the difference between REST, GraphQL, and tRPC, and which do you prefer?**
> "I've used all three. I like tRPC for a TypeScript monorepo because the types flow end-to-end with no separate schema to maintain. REST works well when the frontend and backend are more decoupled. GraphQL is good when clients need to shape their own queries, which I used on Giottolio."

5. **What's your experience with tRPC specifically?**
> "At CarNow, I worked directly with backend engineers to shape our tRPC routers and input/output types around what each feature actually needed, instead of just consuming whatever they built."

6. **What's your database experience — Postgres/Drizzle versus MySQL/Prisma?**
> "I used Postgres with Drizzle for CareerReady, where I designed the schema myself. At CarNow, the stack used MySQL with Prisma. I like Drizzle because it stays close to raw SQL, which gives me more control over the schema."

7. **What's your experience with LLM APIs?**
> "I've used Gemini in production for CareerReady — CV parsing, skill-gap detection, and generating mock-interview questions with automatic scoring. I'm comfortable with Claude's and OpenAI's APIs conceptually, but I haven't shipped a project on those specifically."

8. **What AI coding agents have you used, and how do you use MCP?**
> "Claude Code is my daily driver. At CarNow, I connected it to Linear MCP to pull task specs directly and to Figma MCP to turn designs into code, so I skip a lot of manual handoff between tools."

9. **Do you have experience with RAG or vector databases?**
> "I haven't worked hands-on with RAG or vector databases yet. I understand the concepts, and since I'm already comfortable with API and schema design, I'd expect to pick it up quickly."

10. **What testing tools do you use?**
> "I use Jest for unit tests and Playwright for end-to-end tests. I set both up on Giottolio, and I used similar tooling at CarNow."

11. **What's your CI/CD experience?**
> "I set up GitHub Actions for CareerReady, deploying the frontend to Cloudflare Pages and the backend to Railway automatically on every push."

12. **What's your experience with authentication?**
> "I integrated Firebase Authentication and Storage across the CarNow and HouseNow monorepos. On CareerReady, I set up Google OAuth plus email-and-password authentication myself."

---

## System / Architecture Design (RADIO)

13. **How would you design an async AI analysis pipeline with real-time progress updates?**
> "For CareerReady, the requirement was to analyze a CV and job description with Gemini without blocking the user behind a spinner. I built a background job on the Express side, so the API kicks off the analysis and returns right away. The data model tracks each analysis as a job with a status and a list of completed steps. On the interface side, I used Server-Sent Events so the frontend gets a live stream of progress instead of polling. SSE kept it simple compared to WebSockets since the data only flows one way, and it handled my traffic fine."

14. **How would you design the schema and API for a feature when you're collaborating closely with backend engineers, not consuming a fixed contract?**
> "At CarNow, the requirement usually started as a specific UI flow, not a fixed data shape. I'd map out exactly what the screen needed, then sit down with the backend engineer and shape the tRPC router and input/output types together. Because tRPC shares types end-to-end, the interface stayed strongly typed on both sides with no separate API docs to maintain. If the data model needed to change, we adjusted the schema directly instead of bolting on a workaround. That collaboration was the real optimization — it avoided the usual back-and-forth of the frontend guessing what the backend would return."

15. **How would you structure a data-heavy admin dashboard view with filters, pagination, and sorting?**
> "On the HouseNow admin dashboard, the requirement was multiple status tabs, each needing different filters, plus search, pagination, and sorting on one table. I put the whole filter state into the URL as a Zod-validated schema, so it stayed shareable and correct on refresh. The data model separated the filter state from the actual query input, since each tab mapped to a different assignee field. For the interface, I called the API through TanStack Query with keepPreviousData so the old page stayed visible while the next one loaded, and I prefetched key data through the route loader. That kept the UI feeling fast without any backend changes."

16. **How would you design a full-stack app end-to-end if you owned both frontend and backend?**
> "CareerReady is the real example. The requirement was a CV-analysis app with an AI mock interview. I picked Express and Postgres for the backend since I wanted full control over the schema, and React for the frontend. The data model centers on users, CVs, analyses, and interview sessions. For the interface, I built a REST API and kept the contract simple since one frontend was consuming it. For optimizations, I moved the heavy Gemini calls into the async pipeline instead of blocking requests, and set up CI/CD through GitHub Actions so every change shipped automatically."

---

## Technical Challenges (STAR)

17. **Tell me about a technical challenge you solved.**
> "On CareerReady, the AI analysis could take a while, and a blocking spinner felt broken. I needed a way to show real progress instead of a static loading screen. I built an async pipeline with Server-Sent Events, where the backend streams each analysis step as it completes. The app now feels responsive even though the actual Gemini call still takes time."

18. **Tell me about a time you had to make a backend or schema decision.**
> "At CarNow, backend wanted to ship a fixed API contract for a new feature before I'd even seen the screen. I needed the data shape to actually match the UI I was building. I pushed back, walked through the screen with them, and we shaped the tRPC schema together instead. The result was a schema that fit the feature exactly, with no wasted round trips or workaround fields."

19. **Tell me about setting up a deployment pipeline.**
> "For CareerReady, I wanted every push to ship automatically instead of deploying by hand. I needed CI/CD that could handle both a static frontend and a backend service. I set up GitHub Actions to deploy the frontend to Cloudflare Pages and the backend to Railway on every merge. That let me focus on building features instead of babysitting deploys."

20. **Tell me about building something reusable across multiple products.**
> "At CarNow, both CarNow and HouseNow needed consistent UI, but the components were being built separately for each. I needed one shared source of truth. I built and maintained a shared component package on Shadcn UI and Tailwind, meeting WCAG AA accessibility standards, and both web apps consumed it. The result was consistent UI across both products and less duplicated work for the team."
