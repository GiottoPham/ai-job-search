#!/usr/bin/env bash
# One-time setup for the /mock-interview voice pipeline: verifies ffmpeg,
# installs whisper.cpp via Homebrew if missing, and downloads the
# multilingual base model (needed to transcribe both English and
# Vietnamese prep sessions).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MODEL_DIR="$SKILL_DIR/models"
MODEL_NAME="ggml-base.bin"
MODEL_PATH="$MODEL_DIR/$MODEL_NAME"
MODEL_URL="https://huggingface.co/ggerganov/whisper.cpp/resolve/main/$MODEL_NAME"
WHISPER_BIN_FILE="$SKILL_DIR/.whisper_bin"

echo "== Mock Interview Voice Setup =="

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "[missing] ffmpeg not found. Install with: brew install ffmpeg" >&2
  exit 1
fi
echo "[ok] ffmpeg found"

if ! command -v say >/dev/null 2>&1; then
  echo "[missing] macOS 'say' command not found - this pipeline requires macOS." >&2
  exit 1
fi
echo "[ok] say found"

WHISPER_BIN=""
for candidate in whisper-cli whisper-cpp main; do
  if command -v "$candidate" >/dev/null 2>&1; then
    WHISPER_BIN="$candidate"
    break
  fi
done

if [ -z "$WHISPER_BIN" ]; then
  echo "[missing] whisper.cpp not found. Installing via Homebrew (brew install whisper-cpp)..."
  brew install whisper-cpp
  for candidate in whisper-cli whisper-cpp main; do
    if command -v "$candidate" >/dev/null 2>&1; then
      WHISPER_BIN="$candidate"
      break
    fi
  done
fi

if [ -z "$WHISPER_BIN" ]; then
  echo "[error] whisper.cpp install failed - binary not found on PATH." >&2
  exit 1
fi
echo "[ok] whisper.cpp found: $WHISPER_BIN"
echo "$WHISPER_BIN" > "$WHISPER_BIN_FILE"

mkdir -p "$MODEL_DIR"
if [ ! -f "$MODEL_PATH" ]; then
  echo "Downloading whisper model ($MODEL_NAME, ~140MB, one-time)..."
  curl -L --fail -o "$MODEL_PATH" "$MODEL_URL"
fi
echo "[ok] model present: $MODEL_PATH"

echo ""
echo "Available microphones (set MOCK_INTERVIEW_AUDIO_DEVICE=:N if not the default):"
ffmpeg -f avfoundation -list_devices true -i "" 2>&1 | grep -A20 "AVFoundation audio devices" || true

echo ""
echo "Setup complete."
