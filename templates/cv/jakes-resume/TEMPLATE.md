# Template: jakes-resume

- **Type:** CV
- **Engine:** pdflatex
- **Page limit:** 1 page (this template is designed as a strict single-page ATS-optimized resume; this overrides the framework's default 2-page CV rule)
- **Fonts:** Computer Modern / Latin Modern (default LaTeX article fonts, no installation needed)
- **Class/packages:** `article` (standard) + latexsym, fullpage, titlesec, marvosym, color, verbatim, enumitem, hyperref, fancyhdr, babel, tabularx, glyphtounicode — all standard TeX Live packages, no custom `.cls`

## Compile command

    cd cv && pdflatex -interaction=nonstopmode nguyen_cv_<company>.tex

## Style rules

- **Section order:** Heading -> Summary -> Technical Skills -> Experience -> Projects -> Education -> Languages -> Certifications (Languages/Certifications are appended per-CV, not in the base template skeleton). Skills sits right after Summary, before Experience — do not fall back to the upstream Jake Gutierrez default order (Education/Experience/Projects/Skills), which every tailored CV in this repo has consistently deviated from.
- Always include a `Summary` section right after the heading, before Technical Skills: 2-3 lines, tailored per role (years of experience, core stack, one standout achievement, what you're looking for next). Never skip it, even under the 1-page budget — cut a bullet elsewhere before cutting this section.
- Single column, no color, no icons — deliberately minimal so it parses cleanly through ATS resume scanners
- Section headings: small caps, left-aligned, with a horizontal rule (`\titlerule`) underneath
- Entries use `\resumeSubheading{title}{date}{org}{location}` — title/date on one line, org/location italicized on the next
- Bullets via `\resumeItem{...}` inside `\resumeItemListStart...\resumeItemListEnd`
- Very tight vertical spacing (negative `\vspace` throughout) — this is intentional and load-bearing for fitting one page; do not add space back in when tailoring
- `\pdfgentounicode=1` is set specifically for ATS-parseability — do not remove

## Known pitfalls

- Requires `glyphtounicode.tex` (ships with standard TeX Live `pdftex` support files — confirmed present, no action needed)
- Because this is a strict 1-page format, the framework's default "relevance-weighted cutting" rules from `05-cv-templates.md` apply per-bullet rather than per-section: expect to cut aggressively to ~3-4 bullets for the most recent role and 1-2 for older roles
- No `\needspace`/page-break tooling is relevant since content must fit one page by construction — if content overflows to a second page, cut content rather than trying to rescue the page break
