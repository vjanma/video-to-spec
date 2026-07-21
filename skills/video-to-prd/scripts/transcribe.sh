#!/usr/bin/env bash
# transcribe.sh — produce <workdir>/transcript.txt with [MM:SS]-timestamped lines.
#
# Prefers captions.vtt (free, from YouTube). Falls back to local whisper.cpp
# transcription of audio.wav, downloading the small model once if needed.
#
# Usage: transcribe.sh <workdir>
set -euo pipefail

err() { echo "ERROR: $*" >&2; exit 1; }

WORKDIR="${1:-}"
[ -n "$WORKDIR" ] && [ -d "$WORKDIR" ] || err "usage: transcribe.sh <workdir>"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$WORKDIR/captions.vtt" ]; then
  echo "Using downloaded captions..."
  python3 "$SCRIPT_DIR/clean_vtt.py" "$WORKDIR/captions.vtt" > "$WORKDIR/transcript.txt"
else
  command -v whisper-cli >/dev/null || err "whisper-cli not found. Install with: brew install whisper-cpp"
  [ -f "$WORKDIR/audio.wav" ] || err "no audio.wav in $WORKDIR (run process_video.sh first)"

  MODEL_DIR="${WHISPER_MODEL_DIR:-$HOME/.cache/whisper-cpp}"
  MODEL="$MODEL_DIR/ggml-small.bin"
  if [ ! -f "$MODEL" ]; then
    echo "Downloading whisper small model (~466MB, one-time)..."
    mkdir -p "$MODEL_DIR"
    curl -L --fail --progress-bar -o "$MODEL.part" \
      "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.bin"
    mv "$MODEL.part" "$MODEL"
  fi

  echo "Transcribing with whisper.cpp (small)..."
  whisper-cli -m "$MODEL" -f "$WORKDIR/audio.wav" --output-srt \
    --output-file "$WORKDIR/whisper_out" >/dev/null 2>&1 ||
    err "whisper-cli transcription failed"

  # SRT -> "[MM:SS] text" lines
  awk '
    /^[0-9]+$/ { next }
    /-->/ {
      split($1, t, /[:,]/)
      secs = t[1]*3600 + t[2]*60 + t[3]
      mm = int(secs/60); ss = secs%60
      stamp = sprintf("[%02d:%02d]", mm, ss)
      next
    }
    /^\s*$/ { next }
    { print stamp, $0 }
  ' "$WORKDIR/whisper_out.srt" > "$WORKDIR/transcript.txt"
fi

LINES="$(wc -l < "$WORKDIR/transcript.txt" | tr -d ' ')"
[ "$LINES" -gt 0 ] || err "transcript came out empty — the video may have no narration"
echo "Transcript ready: $WORKDIR/transcript.txt ($LINES lines)"
