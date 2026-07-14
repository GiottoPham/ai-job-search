#!/usr/bin/env bash
# Blocks until the recording started by start_recording.sh has gone quiet
# long enough to assume the speaker is done, then stops it and transcribes.
# No user "stop" message needed - this decides the moment itself.
#
# Two silence thresholds apply, because "hasn't started talking yet" and
# "just finished talking" call for different patience:
#   - before any speech is heard: wait up to MOCK_INTERVIEW_THINK_SECS
#     (default 30) for the speaker to start - covers thinking time before
#     answering.
#   - once speech has been heard: stop after MOCK_INTERVIEW_SILENCE_SECS
#     (default 4) of continuous silence follows - assumes the answer is
#     finished rather than mid-thought.
# ffmpeg's own -t cap (set by start_recording.sh, MOCK_INTERVIEW_MAX_SECS)
# is the ultimate backstop if silence is never detected (e.g. noisy room).
#
# Usage: wait_for_silence.sh <wav_path> <pidfile_path> <log_path> [lang]
#   lang - whisper language code (en, vi, auto). Default: auto
#
# Output: transcript text on stdout, or a line starting with "[error]" (mic
# / transcription failure) or "[no-answer]" (nothing was said within the
# think window) on failure. No audio file is kept on disk afterward.
#
# Env overrides:
#   MOCK_INTERVIEW_SILENCE_SECS - trailing silence after speech before
#                                 auto-stop (default 4)
#   MOCK_INTERVIEW_THINK_SECS   - silence allowed before any speech before
#                                 giving up (default 30)
set -uo pipefail

WAV="${1:?usage: wait_for_silence.sh <wav_path> <pidfile_path> <log_path> [lang]}"
PIDFILE="${2:?usage: wait_for_silence.sh <wav_path> <pidfile_path> <log_path> [lang]}"
LOG="${3:?usage: wait_for_silence.sh <wav_path> <pidfile_path> <log_path> [lang]}"
LANG_CODE="${4:-auto}"
SILENCE_SECS="${MOCK_INTERVIEW_SILENCE_SECS:-4}"
THINK_SECS="${MOCK_INTERVIEW_THINK_SECS:-30}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MODEL_PATH="$SKILL_DIR/models/ggml-base.bin"
WHISPER_BIN_FILE="$SKILL_DIR/.whisper_bin"

cleanup() { rm -f "$WAV" "${WAV%.wav}.txt" "$PIDFILE" "$LOG"; }
trap cleanup EXIT

if [ ! -f "$WHISPER_BIN_FILE" ] || [ ! -f "$MODEL_PATH" ]; then
  echo "[error] voice setup not complete - run scripts/setup_voice.sh first" >&2
  exit 1
fi
WHISPER_BIN="$(cat "$WHISPER_BIN_FILE")"

if [ ! -f "$PIDFILE" ]; then
  echo "[error] no active recording found (missing pidfile) - was start_recording.sh run for this question?" >&2
  exit 1
fi
FFPID="$(cat "$PIDFILE")"

SPOKE_YET=0
STATE="silent"
SILENCE_SINCE="$(date +%s.%N)"
LINES_SEEN=0

while kill -0 "$FFPID" 2>/dev/null; do
  sleep 0.3
  NOW="$(date +%s.%N)"
  TOTAL_LINES="$(wc -l < "$LOG" 2>/dev/null || echo 0)"
  if [ "$TOTAL_LINES" -gt "$LINES_SEEN" ]; then
    NEW="$(sed -n "$((LINES_SEEN + 1)),\$p" "$LOG" 2>/dev/null)"
    LINES_SEEN="$TOTAL_LINES"
    if echo "$NEW" | grep -q "silence_end"; then
      STATE="speaking"
      SPOKE_YET=1
    fi
    if echo "$NEW" | grep -q "silence_start"; then
      STATE="silent"
      SILENCE_SINCE="$NOW"
    fi
  fi

  if [ "$STATE" = "silent" ]; then
    ELAPSED="$(awk -v a="$NOW" -v b="$SILENCE_SINCE" 'BEGIN{print a-b}')"
    if [ "$SPOKE_YET" -eq 1 ]; then
      awk -v e="$ELAPSED" -v t="$SILENCE_SECS" 'BEGIN{exit !(e>=t)}' && break
    else
      awk -v e="$ELAPSED" -v t="$THINK_SECS" 'BEGIN{exit !(e>=t)}' && break
    fi
  fi
done

kill -INT "$FFPID" 2>/dev/null || true
for _ in $(seq 1 50); do
  kill -0 "$FFPID" 2>/dev/null || break
  sleep 0.1
done
kill -0 "$FFPID" 2>/dev/null && kill -KILL "$FFPID" 2>/dev/null || true

if [ "$SPOKE_YET" -eq 0 ]; then
  echo "[no-answer] no speech detected within ${THINK_SECS}s" >&2
  exit 1
fi

if [ ! -s "$WAV" ]; then
  echo "[error] no audio was recorded" >&2
  exit 1
fi

echo "Transcribing..." >&2
"$WHISPER_BIN" -m "$MODEL_PATH" -f "$WAV" -l "$LANG_CODE" -nt -otxt -of "${WAV%.wav}" >/dev/null 2>&1

TXT_FILE="${WAV%.wav}.txt"
if [ -f "$TXT_FILE" ] && [ -s "$TXT_FILE" ]; then
  sed 's/^[[:space:]]*//;s/[[:space:]]*$//' "$TXT_FILE"
else
  echo "[error] transcription produced no output" >&2
  exit 1
fi
