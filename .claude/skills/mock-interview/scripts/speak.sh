#!/usr/bin/env bash
# Speaks text aloud via macOS `say`. Usage: speak.sh "<text>" [voice]
# Voice defaults to MOCK_INTERVIEW_VOICE env var, then macOS default voice.
set -euo pipefail

TEXT="${1:?usage: speak.sh <text> [voice]}"
VOICE="${2:-${MOCK_INTERVIEW_VOICE:-}}"

if [ -n "$VOICE" ]; then
  say -v "$VOICE" "$TEXT"
else
  say "$TEXT"
fi
