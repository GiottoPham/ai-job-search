#!/usr/bin/env bash
# Transcribes a wav file to text via whisper.cpp. Usage: transcribe.sh <input.wav> [lang]
# lang is a whisper language code (en, vi, ...); omit/pass "auto" to auto-detect.
set -euo pipefail

WAV="${1:?usage: transcribe.sh <input.wav> [lang]}"
LANG_CODE="${2:-auto}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MODEL_PATH="$SKILL_DIR/models/ggml-base.bin"
WHISPER_BIN_FILE="$SKILL_DIR/.whisper_bin"

if [ ! -f "$WHISPER_BIN_FILE" ] || [ ! -f "$MODEL_PATH" ]; then
  echo "[error] voice setup not complete - run scripts/setup_voice.sh first" >&2
  exit 1
fi
WHISPER_BIN="$(cat "$WHISPER_BIN_FILE")"

OUT_PREFIX="${WAV%.wav}"
"$WHISPER_BIN" -m "$MODEL_PATH" -f "$WAV" -l "$LANG_CODE" -nt -otxt -of "$OUT_PREFIX" >/dev/null 2>&1

TXT_FILE="${OUT_PREFIX}.txt"
if [ -f "$TXT_FILE" ]; then
  sed 's/^[[:space:]]*//;s/[[:space:]]*$//' "$TXT_FILE"
else
  echo "" >&2
  echo "[error] transcription produced no output" >&2
  exit 1
fi
