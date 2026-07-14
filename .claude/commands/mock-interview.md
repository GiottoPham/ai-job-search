# /mock-interview - Voice Mock Interview from a Prep Sheet

You are role-playing as the **interviewer**. The user is the **interviewee**. You ask each question **out loud** (macOS `say`), then recording starts and stops automatically - no "start"/"stop" chat messages needed. Recording begins right after the question is asked, and ends itself once the user has gone quiet for a few seconds (silence-based auto-stop via `start_recording.sh` / `wait_for_silence.sh`), which also transcribes it (whisper.cpp). After each answer you give brief spoken-interview-style feedback in the chat. The session runs straight through the full question set with no pauses beyond the automatic recording window itself. This drills recall and delivery, not just written answers.

`$ARGUMENTS` contains up to three positional values, space-separated: `<company> [topic] [count]`.

By default, each session **continues from where the last session for that company+topic left off** rather than re-running the same questions (see Step 2). `count` also accepts `restart` (or `restart:<N>`) to wipe that progress and start over from question 1.

---

## Step 0: Parse Arguments and Locate the Prep File

**Do not infer the company (or anything else) from conversation context, even if one was just discussed.** If `$ARGUMENTS` is empty or missing the company, list the companies with prep files available (derive from `Glob interview_prep/**/interview_prep_*.md` filenames) and explicitly ask the user for all three values - company, topic, and count - before doing anything else. Never guess-and-proceed on a partial or absent argument list.

**Company** (1st argument, required): a company slug (e.g. `haiperx`) or an `@`-mention of a prep file.

Find candidate files with `Glob interview_prep/**/*<company>*.md`. This repo has both legacy flat files (`interview_prep/interview_prep_<company>.md`) and newer topic-foldered ones (`interview_prep/<topic>/interview_prep_<company>_<topic>_<lang>_<count>.md`) - match either shape.

**Topic** (2nd argument, optional - enum `hr-screening` / `technical` / `culturefit`): if the company has prep files for more than one topic and the argument is missing or ambiguous, list what's found and ask which one to run. If only one file exists for the company, use it regardless of this argument.

**Count** (3rd argument, optional): how many questions to run this session. Default **8**. Accepts `all` to run every question in the file.

Read the resolved prep file. Parse it into an ordered list of `(question, model_answer)` pairs from the numbered/blockquote format. Skip any entry whose answer is a flagged placeholder like `*(No specific story on file...)*` - don't ask the user to answer a question the profile has no real story for; note it was skipped.

Detect the file's language from its content/filename (`_vi` suffix or Vietnamese text) - this decides which `say` voice to use later.

---

## Step 1: Verify Voice Setup

Check whether `.claude/skills/mock-interview/.whisper_bin` exists.

- **If missing:** explain that this is a one-time setup (installs `whisper-cpp` via Homebrew if not already present, downloads a ~140MB multilingual model) and **ask the user for explicit confirmation before running it** - this modifies their system (Homebrew install) and downloads a large file, so don't run it unprompted. On confirmation, run:
  ```
  bash .claude/skills/mock-interview/scripts/setup_voice.sh
  ```
  If it fails, report the error and stop rather than falling back silently to a text-only mode the user didn't ask for.
- **If present:** proceed silently, no need to re-run.

Pick a TTS voice: if the prep file is Vietnamese, check `say -v '?'` output for a Vietnamese voice (e.g. one tagged `vi_VN`); use it if found, otherwise warn the user their questions will be read with an English voice and continue. Otherwise use the default voice (or `$MOCK_INTERVIEW_VOICE` if the user has set one).

Create one working set of paths for the whole session: `wav="$(mktemp -t mock-interview-answer).wav"` (delete the plain mktemp file first, then use the `.wav`-suffixed path), `pidfile="${wav%.wav}.pid"`, and `log="${wav%.wav}.log"`. Reuse the same three paths for every question in Step 3 - `start_recording.sh` and `wait_for_silence.sh` overwrite/clean them each time, so no per-question or per-session directory bookkeeping is needed.

---

## Step 2: Select the Question Set

**Track progress per prep file so repeat sessions advance instead of repeating.** Progress lives at `.claude/skills/mock-interview/progress/<prep-file-basename>.json` (e.g. `interview_prep_haiperx_hr-screening_en_20.json` → `progress/interview_prep_haiperx_hr-screening_en_20.json`), a small JSON object: `{"asked_questions": ["<exact question text>", ...]}`. This directory holds personal session state, not committed material - confirm it's covered by `.gitignore` (add an entry alongside the existing `.whisper_bin`/`models/*.bin` mock-interview rules if it isn't) rather than leaving it to be accidentally committed.

- **If `count` is `restart` or `restart:<N>`:** delete/ignore any existing progress file for this prep file (start it fresh), then select starting from question 1. Use `<N>` as the count if given, else the default of 8. Tell the user explicitly that this is a fresh pass ignoring prior sessions.
- **Otherwise (normal run):** read the progress file if it exists and collect its `asked_questions`. Walk the parsed list in file order and skip any question whose text already appears in `asked_questions`. Take the first `<count>` questions (or all remaining, if `count` is `all`) from what's left.
  - If fewer questions remain than `<count>` asks for, use everything that's left and tell the user this session will finish the file's remaining questions (say how many). Don't wrap around to the top silently.
  - If nothing remains (every question in the file has already been asked in a prior session), tell the user the full set has been completed for this company/topic, then treat it the same as `restart`: start over from question 1 and say so explicitly - don't fail or ask a blocking question.
- If the file has an explicit "tough questions" / "curveball" section and it fell outside the selected range, swap in its first not-yet-asked entry as the closing question so the session doesn't end on an easy note.
- The prep files are already sequenced warm-up-first (self-intro/background) into deeper behavioral or technical territory, so file order (minus already-asked questions) still gives a reasonable arc.

Tell the user up front: how many questions total are in the file, how many remain unasked before this session, how many you're running this session, and the topic/company. Briefly explain the mechanics before starting:

> I'll speak each question aloud, then start recording automatically - no need to say "start." Just answer out loud once you hear "Recording now." I'll stop automatically once you've been quiet for a few seconds and give you feedback, then move straight to the next question. If you don't say anything within 30 seconds I'll treat it as no answer and offer a retry. No script to run, no key to press, nothing to say between questions - the whole session runs straight through all {count} questions back to back.

Open the session in character as the interviewer with a one-line spoken warm-up (e.g. "Thanks for making time today - let's start easy.") before Q1, the way a real interviewer would, rather than launching straight into the first question cold.

---

## Step 3: Run the Q&A Loop

For each selected question, in order, **without pausing between questions** (see Important Rules #5):

1. **Ask.** Run `bash .claude/skills/mock-interview/scripts/speak.sh "<question text>" [voice]` (blocking - it finishes when the speech finishes). Also print the question in chat as `**Q<n>. <question>**` so the user has it in writing.
2. **Start recording immediately** (no user message needed): run
   ```
   bash .claude/skills/mock-interview/scripts/start_recording.sh "$wav" "$pidfile" "$log"
   ```
   This blocks briefly and returns `READY` once the mic is actually capturing (or an `[error]` line if the device failed to open - report that plainly and ask the user to check `MOCK_INTERVIEW_AUDIO_DEVICE`, this repo has multiple mics, see Step 1's note). **Only after** you see `READY` - never before - tell the user in chat: "Recording now - go ahead." Telling them to talk any earlier than this reintroduces the clipped-first-word bug this handshake exists to prevent (see the comment in `start_recording.sh`).
3. **Wait for silence-based auto-stop** (no user message needed): immediately after posting "Recording now," run
   ```
   bash .claude/skills/mock-interview/scripts/wait_for_silence.sh "$wav" "$pidfile" "$log" <en|vi|auto>
   ```
   This blocks - potentially for a while, that's expected - until the user has either gone quiet for a few seconds after speaking (assumed done) or gone the full think-window with no speech at all (assumed no answer). Read the output:
   - A line starting with `[no-answer]` → nothing was said within the think window. Tell the user plainly (they may have missed the "Recording now" cue) and offer to redo the question from the "Start recording" step.
   - A line starting with `[error]` → nothing usable was recorded (no active recording, or transcription failed). Say so plainly and offer to redo the question from the "Start recording" step.
   - Otherwise → that text is the transcript. Show it to the user as `**Your answer:** "<transcript>"`. If it looks implausibly short or cut off (e.g. the auto-stop fired mid-sentence during a long thinking pause), say so and offer a retry rather than scoring a partial answer as-is - the defaults tolerate a few seconds of pause but not a long one, see the env vars in `wait_for_silence.sh`.
4. **Feedback.** Compare the spoken answer against:
   - the model answer already drafted in the prep file for this question,
   - `.claude/skills/job-application-assistant/01-candidate-profile.md` and `02-behavioral-profile.md` for factual accuracy (flag anything the user said that isn't actually true of their background - never let a fabricated claim pass uncorrected, even in practice),
   - the company's actual submitted documents - `cv/nguyen_cv_<company>.tex` and `cover_letters/cover_<company>_*.tex` if they exist (fall back to `documents/applications/<company>_*/cv_draft.tex` / `cover_letter.tex` for older tracked applications). The real interviewer read these; an answer that contradicts a claim on that specific CV is a bigger problem than one that's merely absent from the general profile, so call that out explicitly rather than folding it into a generic accuracy note,
   - structure expectations: STAR for behavioral questions, RADIO for system-design questions (per `07-interview-prep.md`), otherwise a direct answer is fine.

   Give 2-4 sentences of concise, spoken-interview-style feedback: what covered the point well, what to tighten (too long/short, missing the Result in a STAR answer, drifted from the actual model answer's key fact, etc.). Don't be a rubber stamp - if the answer was vague or off-target, say so plainly, same directness the user's behavioral profile calls for. Coach toward the user's own natural register from `02-behavioral-profile.md`, not a generic "ideal candidate" script - the goal is a sharper version of how they'd actually talk, not a different person.
5. **Record progress.** Append this question's exact text to `asked_questions` in the progress file from Step 2 (create the file/directory if this is the first question ever recorded for this prep file) and save it immediately - don't batch this until end-of-session, so a session that gets interrupted mid-way still preserves what was actually covered. Skip this only for a question whose recording ended in an `[error]` with no retry completed (nothing was actually answered, so it shouldn't count as covered).

Then move straight to the next question's "Ask" step - no prompt or pause of any kind, since nothing further is needed from the user between questions. The only things that pause the loop further are a `[no-answer]`/`[error]` outcome or an implausibly short/cut-off answer (offer retry-or-skip, per step 3 above) or the user interrupting on their own.

---

## Step 4: End-of-Session Summary

After the last selected question (or the user stopping the session on their own), give a short wrap-up covering:

- Which questions landed well vs. need more rehearsal (by number/topic).
- Any recurring delivery pattern across answers (rambling, missing the Result step, drifting from the CV's actual claims).
- 1-2 concrete things to redo before the real interview.
- How many questions remain unasked in the prep file for next time (from the progress file), or that the full set is now complete and the next run will start a fresh pass unless `restart` is used.

No cleanup needed here - `wait_for_silence.sh` already deleted each question's temp audio, transcript file, pidfile, and ffmpeg log right after transcribing it. Recordings are never kept - only the in-chat transcript and feedback persist, and only for this conversation.

If a real interview is actually scheduled for this application (not just general rehearsal), point the user to `/interview <company>` for the parts this command doesn't do: verified company/interviewer research, a stage-specific prep pack, and logistics - then `/outcome <company>` afterward to log what happened. `/mock-interview` only drills the static Q&A that already exists; it doesn't research the company or track outcomes.

---

## Important Rules

1. **Never fabricate an answer's transcript.** If transcription fails, is empty, or looks cut off mid-sentence, say so and offer a re-record - don't guess at what the user probably said.
2. **Never let a factual slip pass silently.** If the user's spoken answer claims something not supported by the actual profile/CV, flag it in feedback the same way the repo's CV verification rules require - practice is exactly when this should be caught.
3. **Confirm before first-time setup.** Installing `whisper-cpp` and downloading the model is a real system change; get explicit go-ahead once per machine, not once per session.
4. **No silent text-only fallback.** If voice setup or a recording step fails, report the failure and ask how to proceed rather than quietly switching to typed answers.
5. **Don't pause the session for permission to continue.** Once started, run straight through every selected question back to back with no chat exchange required between them - the only valid interruptions are a failed/no-answer/truncated recording (offer retry-or-skip) or the user explicitly stopping it themselves.
6. **Never announce "Recording now" before `start_recording.sh` actually returns `READY`.** This is the one ordering rule that matters most: an earlier version of this command auto-started recording without waiting for the mic to actually stabilize first, and it clipped the first word or two of every answer. `start_recording.sh`'s `READY` handshake exists specifically to prevent that - always let it finish before telling the user to talk. All three scripts (`start_recording.sh`, `wait_for_silence.sh`, `speak.sh`) are things you run yourself directly as normal blocking Bash calls - never hand a script to the user to run themselves.
7. **`wait_for_silence.sh` blocks for a while - that's expected, not a hang.** It only returns once the user has gone quiet after speaking, or the think-window has elapsed with no speech at all. Don't interrupt or re-run it while it's in flight.
