# Template: jakes-resume

- **Type:** CV
- **Engine:** pdflatex
- **Page limit:** 2 pages (originally a strict single-page ATS-optimized resume; overridden per user preference on 2026-07-13 to allow room for the Projects section — follow the framework's default 2-page cutting/fit rules from `05-cv-templates.md` instead of the aggressive single-page cuts below)
- **Fonts:** Computer Modern / Latin Modern (default LaTeX article fonts, no installation needed)
- **Class/packages:** `article` (standard) + latexsym, fullpage, titlesec, marvosym, color, verbatim, enumitem, hyperref, fancyhdr, babel, tabularx, glyphtounicode — all standard TeX Live packages, no custom `.cls`

## Compile command

    cd cv && pdflatex -interaction=nonstopmode nguyen_cv_<company>.tex

## Style rules

- **Section order:** Heading -> Summary -> Technical Skills -> Experience -> Projects -> Education -> Languages -> Certifications (Languages/Certifications are appended per-CV, not in the base template skeleton). Skills sits right after Summary, before Experience — do not fall back to the upstream Jake Gutierrez default order (Education/Experience/Projects/Skills), which every tailored CV in this repo has consistently deviated from.
- Always include a `Summary` section right after the heading, before Technical Skills: 2-3 lines, tailored per role (years of experience, core stack, one standout achievement, what you're looking for next). Never skip it — cut a bullet elsewhere before cutting this section.
- Single column, no color, no icons — deliberately minimal so it parses cleanly through ATS resume scanners
- Section headings: small caps, left-aligned, with a horizontal rule (`\titlerule`) underneath
- Entries use `\resumeSubheading{title}{date}{org}{location}` — title/date on one line, org/location italicized on the next
- **Every Experience entry gets a `Tech stack:` line directly below the `\resumeSubheading` (before any company-description paragraph):** `{\small\textbf{Tech stack:} \emph{Tool1, Tool2, ...}}`. List only tools actually evidenced by that entry's own bullets — do not paste in the aggregate Technical Skills list (see `feedback_verify_tech_stack_per_company` guidance: verify per company, don't infer from the aggregate). If the entry also has a company-description paragraph (italic, right below), add `\\[8pt]` after the tech-stack line so there's a visible gap between the two, e.g.:
  ```latex
  {\small\textbf{Tech stack:} \emph{React, Next.js, TypeScript}} \\[8pt]
  {\small\textit{Company is a ... company}}
  ```
  If there's no description paragraph, the tech-stack line goes directly above `\resumeItemListStart` with no extra spacing needed.
- **Tie required JD keywords to at least one concrete Experience/Project bullet, not just the Summary/Skills list.** A skill that only appears in Summary+Skills reads as "familiar with" to a technical reviewer; the same skill anchored to a shipped bullet (or now, the Tech stack line) reads as verified production experience. When tailoring, check that every hard-required JD skill shows up in at least one bullet or tech-stack line, not only in Skills.
- Bullets via `\resumeItem{...}` inside `\resumeItemListStart...\resumeItemListEnd`
- Very tight vertical spacing (negative `\vspace` throughout) — this is intentional and load-bearing for fitting one page; do not add space back in when tailoring
- `\pdfgentounicode=1` is set specifically for ATS-parseability — do not remove

## Known pitfalls

- Requires `glyphtounicode.tex` (ships with standard TeX Live `pdftex` support files — confirmed present, no action needed)
- Now a 2-page format: use the framework's default per-section relevance-weighted cutting from `05-cv-templates.md`, not the old aggressive per-bullet cuts (~3-4 bullets most recent role, 1-2 older roles) that applied under the 1-page limit
- Since this template has no `\needspace`/page-break tooling built in, check for orphaned `\resumeSubheading` titles (a title stranded at the bottom of page 1 with its bullets pushed to page 2) when tailoring to 2 pages, and add manual `\newpage` or spacing adjustments if needed
