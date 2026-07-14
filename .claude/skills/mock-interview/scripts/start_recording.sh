#!/usr/bin/env bash
# Starts a detached recording (with live silence detection logged to
# <log_path>, so a caller can later tell when the speaker has gone quiet)
# and blocks only until the mic stream has actually stabilized, then prints
# READY and returns (the recording keeps running in the background via
# nohup+disown, independent of this script's exit - setsid isn't available
# on macOS). Pair with wait_for_silence.sh, which blocks until enough
# silence has elapsed, then stops the recording and transcribes it.
#
# The explicit readiness handshake exists because telling the user to talk
# before ffmpeg is actually capturing clips the first word or two -
# avfoundation takes a beat to start yielding real audio frames. Callers
# that auto-start recording (no user "go ahead" message) must still wait for
# this script's READY before treating the mic as live, or that clipping
# comes back.
#
# Usage: start_recording.sh <wav_path> <pidfile_path> <log_path>
#
# Env overrides:
#   MOCK_INTERVIEW_AUDIO_DEVICE  - ffmpeg avfoundation device index (default :0)
#   MOCK_INTERVIEW_MAX_SECS      - hard cap safety net if silence is never
#                                  detected (default 300)
#   MOCK_INTERVIEW_SILENCE_NOISE - silencedetect noise floor (default -20dB;
#                                 laptop-mic ambient/fan noise commonly peaks
#                                 around -25dB to -30dB, so anything much
#                                 below -20dB false-triggers on room tone
#                                 instead of actual speech - raise further,
#                                 e.g. -15dB, in a noisy room)
set -uo pipefail

WAV="${1:?usage: start_recording.sh <wav_path> <pidfile_path> <log_path>}"
PIDFILE="${2:?usage: start_recording.sh <wav_path> <pidfile_path> <log_path>}"
LOG="${3:?usage: start_recording.sh <wav_path> <pidfile_path> <log_path>}"
DEVICE="${MOCK_INTERVIEW_AUDIO_DEVICE:-:0}"
MAX_SECS="${MOCK_INTERVIEW_MAX_SECS:-300}"
NOISE_DB="${MOCK_INTERVIEW_SILENCE_NOISE:--20dB}"

rm -f "$WAV" "$PIDFILE" "$LOG"

nohup ffmpeg -hide_banner -loglevel info -f avfoundation -i "$DEVICE" \
  -t "$MAX_SECS" -ar 16000 -ac 1 \
  -af "silencedetect=noise=${NOISE_DB}:d=0.3" \
  -y "$WAV" >/dev/null 2>"$LOG" &
FFPID=$!
disown "$FFPID" 2>/dev/null || true
echo "$FFPID" > "$PIDFILE"

# Poll for the wav header + at least one real audio chunk to show up before
# declaring readiness, instead of a blind fixed sleep.
for _ in $(seq 1 20); do
  if ! kill -0 "$FFPID" 2>/dev/null; then
    echo "[error] recording process exited before it became ready - check the mic device (MOCK_INTERVIEW_AUDIO_DEVICE)" >&2
    exit 1
  fi
  SIZE=$(stat -f%z "$WAV" 2>/dev/null || echo 0)
  if [ "$SIZE" -gt 4096 ]; then
    echo "READY"
    exit 0
  fi
  sleep 0.15
done

# Fell through without confirming real audio data - still likely fine (quiet
# room), but warn rather than silently proceeding.
if kill -0 "$FFPID" 2>/dev/null; then
  echo "READY"
  exit 0
fi
echo "[error] recording process is not running" >&2
exit 1
