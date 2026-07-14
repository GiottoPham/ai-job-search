# Search Queries for Job Scraper

<!-- SETUP: Customize these queries based on your skills, target roles, and location -->

## Search Sites

Primary (Vietnam / remote job market):

- **linkedin.com/jobs** - LinkedIn job listings (filter: Vietnam / Remote)
- **topcv.vn** - major Vietnamese job board
- **topdev.vn** - Vietnam-focused tech job board
- **vietnamworks.com** - major Vietnamese job board (strong tech/IT section)
- **itviec.com** - IT/tech-specific Vietnamese job board
- **viecoi.vn** / **careerviec.vn** - Vietnamese job boards
- **indeed.com** - general job search worldwide, filter by Remote

Global remote-first (fully remote roles, any country):
- **remotive.com** - curated remote jobs in tech & beyond
- **remoteok.com** - tech remote jobs worldwide, popular with startups
- **wellfound.com** (formerly AngelList Talent) - startup remote jobs, good for Founding/Early Engineer roles

Secondary (company career pages via Google):

- Direct Google searches with `site:` filters for known target companies

Manual-paste only (Facebook groups):

- Vietnamese tech job groups (e.g. "IT Jobs Vietnam", "Vietnam Software Engineers", "ITviec Community", frontend/React Native-specific groups) are a known source of postings, but they sit behind Facebook's login wall - WebSearch/WebFetch cannot crawl group posts.
- **Workflow:** when you see a promising post in one of these groups, paste the post text or link here and I'll run it through the same quick fit assessment (Step 3) and dedupe/store it in `seen_jobs.json` like any other result. Do not attempt automated fetching against facebook.com URLs - it will fail or return nothing usable.

**Note:** Unlike the framework's original Danish CLI scraper tools (Jobindex, Jobbank, Jobdanmark, Jobnet), the sites above do not yet have dedicated scraper integrations in `.agents/skills/`. Until that tooling exists, `/scrape` should rely on Google `site:` searches and WebFetch/WebSearch against these domains, plus LinkedIn Jobs search.

**weworkremotely.com dropped as a source (2026-07-13):** individual job-posting pages returned HTTP 403 to WebFetch (bot-blocked) on every attempt, and the candidate confirmed the same links also fail to load in a regular browser - not just a scraping-tool problem, the links are genuinely unusable. Don't search or present WWR results going forward.

**Known WebFetch limitation (confirmed 2026-07-13):** Individual job-posting pages on **remoteok.com** return HTTP 403 to WebFetch (bot-blocked) - every single-listing fetch attempt failed in testing (unconfirmed whether this also blocks regular browser access - unlike WWR, not yet verified with the candidate). **remotive.com** individual listings are hit-or-miss (frequent 404s, possibly stale/expired URLs from the search cache). For these two sites, don't burn WebFetch calls trying to open individual listings - rely on the title/company/requirements/salary/region already surfaced in the WebSearch result snippet and summary instead, and note in the results table that full-JD details (exact deadline, complete requirements) couldn't be independently verified so the user should open the link before applying.

## Query Categories

Queries are grouped by priority. Each query should be combined with your location terms ("Ho Chi Minh City", "Vietnam", "Remote") where the site supports it.

### Priority 1: Frontend Engineer (Senior/Middle)

These match your strongest and most desired career direction.

```
site:linkedin.com/jobs "Frontend Engineer" (Senior OR Middle) (Vietnam OR Remote)
site:topdev.vn "Frontend Engineer" (Senior OR Middle)
site:itviec.com "Frontend Developer" React
site:vietnamworks.com "Frontend Engineer" React OR "React Native"
site:indeed.com "Frontend Engineer" React Remote
site:remotive.com Frontend React
site:remoteok.com Frontend React
```

### Priority 2: Full-Stack JS Engineer (Senior/Middle)

Matches your secondary career direction (frontend-rooted, moving toward full-stack).

```
site:linkedin.com/jobs "Full Stack Engineer" (React OR Node.js) (Senior OR Middle) (Vietnam OR Remote)
site:topdev.vn "Full Stack Developer" (React OR Node.js)
site:itviec.com "Fullstack Developer" (JavaScript OR TypeScript)
site:indeed.com "Full Stack Engineer" (React OR Node.js) Remote
site:remotive.com "Full Stack" (React OR Node.js)
site:remoteok.com "Full Stack" (React OR Node.js)
```

### Priority 3: React Native / Mobile Engineer

Direct target role - backed by hands-on native mobile work (push notifications, universal/deep linking, WebView bridge architecture, in-app purchases, Expo SDK upgrades), not just React Native/Expo familiarity.

```
site:linkedin.com/jobs "React Native" (Engineer OR Developer) (Vietnam OR Remote)
site:itviec.com "React Native" mobile developer
site:indeed.com "React Native" Remote
site:remoteok.com "React Native"
```

### Priority 4: Broader Technical / AI-Product Engineer

Wider net, including roles that value the LLM-integration and full-stack side-project experience (Giottolio, CareerReady).

```
site:linkedin.com/jobs "Product Engineer" (AI OR LLM) (Vietnam OR Remote)
site:topcv.vn (React OR JavaScript) developer
site:vietnamworks.com "Founding Engineer" OR "Early Engineer"
site:wellfound.com "Founding Engineer" OR "Early Engineer" (React OR JavaScript)
site:indeed.com "Product Engineer" (AI OR LLM) Remote
```

## Location Filter

When evaluating results, verify the job matches one of these arrangements:

- **Remote** - any country (no commute constraint)
- **Ho Chi Minh City, Vietnam** - hybrid or onsite acceptable
- Roles requiring relocation outside Vietnam without a remote option: FLAG (discuss with user before pursuing)

## Date Filter

Only include jobs posted within the last 14 days, or with an application deadline that has not yet passed. If a posting date cannot be determined, include it but flag as "date unknown".

## Deal-breakers to Screen Out

- Roles requiring weekend work or non-Monday-Friday schedules
- Roles below the $1,000+ USD/month salary baseline (when salary is disclosed)

## Adapting Queries

If the user specifies a focus area, select queries from the matching category and also generate 2-3 custom queries for that focus. For example:

- "/scrape [focus_area]" -> relevant category queries + custom focus-specific queries
