# /prepare-interview - Generate a Targeted Interview Q&A Prep Sheet

You are generating an interview prep sheet: a set of likely questions with short, casual, fully-grammatical (subject + verb) answers grounded strictly in the candidate's actual profile and the specific job posting. Never invent achievements, stories, or facts not already established in the profile files or verified job posting.

`$ARGUMENTS` contains up to four positional values, space-separated, in this order: `<company> <topic> [language] [count]`.

---

## Step 0: Parse Arguments

**Company** (1st argument, required): a company name/slug (e.g. `haiperx`), a path to a CV file (e.g. `cv/nguyen_cv_haiperx.tex`), or an `@`-mention of one. Extract the company slug from whichever form is given — normalize to lowercase, no spaces/punctuation (match existing convention: `haiperx`, `vnggames`, `eazylab`). Verify `cv/nguyen_cv_<company>.tex` exists; if not, list the CVs found under `cv/` (Glob `cv/nguyen_cv_*.tex`) and ask the user to pick one.

If the 1st argument is missing entirely, fall back to inferring the company from conversation context (the company most recently discussed, or the most recently touched `cv/nguyen_cv_*.tex` / `interview_prep/*` file) — but only as a fallback. If it can't be inferred confidently either, ask the user which company this prep is for before continuing.

**Topic** (2nd argument, required — this is an enum):
- `hr-screening` — background, motivation, logistics, light fit questions
- `technical` — role/stack-specific technical and system-design questions
- `culturefit` — values, work style, team dynamics

Match case-insensitively and tolerate minor variants (`hr`, `hrscreening`, `culture-fit`, `culture` all map to their enum). If the value is missing or doesn't match any of the three, list the three options and ask the user to pick.

**Language** (3rd argument, optional — enum `vi` / `en`):
- Default to `en` if omitted.
- `vi` means the whole file — questions and answers — is written in Vietnamese.

**Count** (4th argument, optional, integer):
- Default to `20` if omitted or not a valid number.

---

## Step 1: Gather Context

Do not re-read files already in context from earlier in the conversation.

1. Read the company's existing CV: `cv/nguyen_cv_<company>.tex` (and cover letter if present). Treat this as the ground truth for what the candidate has claimed — **never answer with a story or claim that contradicts or isn't supported by the actual CV on file.**
2. Read `.claude/skills/job-application-assistant/01-candidate-profile.md` and `02-behavioral-profile.md` for the full pool of real, honest anecdotes to draw from (not everything on the CV made the cut, but everything used in an answer must be true).
3. Check `job_search_tracker.csv` for a row matching this company — pull notes, fit rating, JD source link.
4. If a JD URL is known (from the tracker or an existing `interview_prep/*` file for this company), re-fetch it with WebFetch — don't rely on stale assumptions from earlier drafts. If no JD source exists anywhere, ask the user for the posting URL or pasted text before generating **technical** or **culturefit** content (hr-screening can proceed on profile alone if truly nothing else is available, but flag the gap).

---

## Step 2: Generate Questions by Topic

Every answer must be **short, casual, and fully grammatical** — every sentence needs an explicit subject and verb (no fragments like "4 years full-stack, mostly frontend"; write "I have 4 years of full-stack experience"). Match the tone already established in this repo's `interview_prep/*.md` files.

### `hr-screening`
Cover: self-intro, walk-through-CV, years of experience in the role type, why leaving current role, why this company, salary expectation, availability, working schedule/logistics, and 2-3 light behavioral basics. Plain direct answers — STAR only if a question explicitly asks "tell me about a time...".

### `technical`
Cover: stack-specific questions drawn from the JD's required/nice-to-have skills, plus a few system/architecture questions if the JD or role implies design ownership (API design, schema design, scaling, integration choices).

- For any question that is a **system/architecture design question** (e.g. "how would you design X", "how would you structure the API/schema for Y"), structure the answer around **RADIO**:
  - **R**equirements — what the system needs to do, constraints
  - **A**rchitecture — high-level components and how they connect
  - **D**ata model — key entities/schema
  - **I**nterface — API/contract shape between components
  - **O**ptimizations — tradeoffs, scaling, what you'd improve next
  Keep it compressed into a short, casual, spoken-style answer — RADIO is the structure, not a section-by-section essay. Ground it in a real example from the candidate's work when possible (e.g. tRPC schema design at CarNow, CareerReady's backend) rather than a hypothetical from scratch.
- For "tell me about a technical challenge/bug/decision" questions, use **STAR** (see below).
- For plain knowledge questions ("what's your experience with X"), a short direct answer is enough — no framework needed.

### `culturefit`
Cover: work style, autonomy vs. oversight preference, collaboration style, adapting to change, handling disagreement, values alignment with the company. Most of these are "tell me about a time" prompts — use **STAR**.

**STAR structure** (for any behavioral prompt, in any topic): Situation, Task, Action, Result — compressed into 2-4 casual, complete sentences, not labeled S/T/A/R in the output. Pull real stories from the candidate profile (subscription system if it's on that company's CV, 4-person team coordination, the QA staging tool, CareerReady, tRPC schema collaboration, package upgrades). **If no real anecdote exists in the profile for a question you'd otherwise include, do not invent one** — either drop the question or include it with a flagged placeholder like: `*(No specific story on file — needs your real memory before the call.)*`, same pattern used for "tell me about a mistake" in prior prep files.

Generate exactly `<count>` questions total for the chosen topic (adjust the mix above proportionally — e.g. a 10-question `technical` set skews toward stack questions with 2-3 RADIO/STAR ones, not the other way around).

If `language` is `vi`, write every question and every answer in Vietnamese, keeping the same short/casual/full-sentence-grammar standard.

---

## Step 3: Write the File

1. Ensure the topic folder exists: `interview_prep/<topic>/` (create with `mkdir -p` if missing).
2. Write to `interview_prep/<topic>/interview_prep_<company>_<topic>_<language>_<count>.md`.
3. File structure:

```markdown
# Interview Prep — <Company> (<Role from CV>) — <Topic label>

**Source:** <JD link if available> — <1-line company/role facts: openings, experience required, salary band, deadline>

**What the JD actually wants:** <tech stack / must-haves / nice-to-haves, condensed>

Every answer is written as short, complete sentences (subject + verb) so you can say each one out loud as-is. <If topic is technical: mention RADIO for design questions. If culturefit or hr-screening includes behavioral: mention STAR.>

---

1. **<Question>**
> "<Answer>"

2. **<Question>**
> "<Answer>"

...
```

Keep the same numbered-question, blockquoted-answer format used in existing `interview_prep/*.md` files for consistency.

---

## Step 4: Confirm

Report to the user:
- File path written
- Question count and topic
- Breakdown of how many questions used STAR, how many used RADIO, and how many are plain answers
- Any flagged placeholders (real anecdotes the user needs to supply)
- Any JD facts that changed since a prior prep file for this company existed (e.g. corrected assumptions) — surface these explicitly, don't bury them
