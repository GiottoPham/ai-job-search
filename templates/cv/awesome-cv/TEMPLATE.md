# Template: awesome-cv

- **Type:** CV
- **Engine:** xelatex
- **Page limit:** 2 pages (matches framework default; Awesome-CV comfortably fits the standard content budget from `05-cv-templates.md`)
- **Fonts:** Source Sans 3 (body) and Roboto (headers/accents) — **bundled** as static Regular/Bold/Italic/BoldItalic `.ttf` files in `fonts/`, loaded by explicit `Path=` in `awesome-cv.cls`. No system font installation needed; fully self-contained.
- **Class/packages:** custom `awesome-cv.cls` (bundled alongside `template.tex` in this folder) + fontawesome6, unicode-math, tcolorbox, parskip, bookmark, accsupp — all present in a standard TeX Live install alongside the class file

## Compile command

    cd cv && xelatex -interaction=nonstopmode nguyen_cv_<company>.tex

Requires both `awesome-cv.cls` and the `fonts/` directory to be present alongside the output `.tex` file — copy them from `templates/cv/awesome-cv/` into `cv/` (once; shared across all applications using this template, not regenerated per company).

## Style rules

- Colored accent theme set via `\colorlet{awesome}{awesome-skyblue}` — other built-in options: awesome-emerald, awesome-red, awesome-pink, awesome-orange, awesome-nephritis, awesome-concrete, awesome-darknight. Pick one and keep it consistent across CV and any matching cover letter.
- Header is centered (`\makecvheader[C]`) with name, position/headline, and social links (LinkedIn/GitHub/homepage) rendered as one line
- `\cvsection{}` for top-level sections, `\cvsubsection{}` for subsections (e.g. splitting Honors into International/Domestic/Community) — only use `\cvsubsection` if a section genuinely needs grouping, most won't
- Entries: `\cventries{...}` environment wrapping one or more `\cventry{title}{org}{location}{dates}{cvitems block}` — bullets go in a nested `\begin{cvitems}...\end{cvitems}`
- Simple award/certificate lines use `\cvhonors{...}` wrapping `\cvhonor{name}{issuer}{credential id}{date}` — no bullet sub-list, single line per entry
- Footer shows date, name + "Résumé", and page number automatically via `\makecvfooter{}{}{}i` — do not hand-roll a footer

## Known pitfalls

- **The upstream template ships broken for current font distributions.** Upstream `awesome-cv.cls` loads Source Sans 3 / Roboto by family name via the system font store, requesting named instances (Regular/Italic/Bold/BoldItalic, plus Light/Light Italic). Current Google Fonts builds of both families ship as single-file *variable* fonts, and on this system fontspec/HarfBuzz could not resolve even a plain "Italic" named instance from them — every named-instance lookup threw `! Package fontspec Error: The font "..." cannot be found`, regardless of whether the variable font was installed system-wide.
- **Fix applied:** used `fonttools varLib.instancer` to bake out real static Regular/Bold/Italic/BoldItalic instances from the installed variable fonts, saved them into this folder's `fonts/`, and rewrote the three font declarations in `awesome-cv.cls` (`\setmainfont`, `\setsansfont`, `\newfontfamily\roboto`) to load them via explicit `Path = fonts/` + filename instead of by family name. This is why `awesome-cv.cls` in this folder differs from the upstream file — do not replace it with a fresh copy from GitHub without reapplying this fix (see the comment block directly above the font declarations in the `.cls` for exact detail).
- **Light weight is not bundled.** The "Light"/"Light Italic" FontFace overrides were dropped rather than instantiated — `\headerfontlight` / `\bodyfontlight` will render in regular weight instead (cosmetic only, produces a harmless "Font shape ... undefined, using ... instead" warning, not an error).
- Requires `xelatex`, not `lualatex` — the `.cls` sets `Renderer=HarfBuzz` font features that are XeTeX/LuaTeX-specific but were only verified against xelatex during this template's test compile.
- `\quote{}` (the personal quote under the header) is optional flavor text — feel free to drop it entirely for a more conservative look; it's not required by the class.
