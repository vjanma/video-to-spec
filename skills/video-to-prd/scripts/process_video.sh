#!/usr/bin/env bash
# process_video.sh — turn a local video file or YouTube URL into analysis inputs.
#
# Usage: process_video.sh <input: file path or YouTube URL> <workdir>
#
# Produces inside <workdir>:
#   video.<ext>      the source video (downloaded if input was a URL)
#   audio.wav        16kHz mono audio for whisper (only if no captions found)
#   captions.vtt     YouTube captions, if available
#   frames/          keyframe PNGs named frame_<MM>m<SS>s.png
#   meta.txt         duration, frame count, caption availability
set -euo pipefail

err() { echo "ERROR: $*" >&2; exit 1; }

INPUT="${1:-}"; WORKDIR="${2:-}"
[ -n "$INPUT" ] && [ -n "$WORKDIR" ] || err "usage: process_video.sh <file-or-youtube-url> <workdir>"
command -v ffmpeg >/dev/null || err "ffmpeg not found. Install with: brew install ffmpeg"

mkdir -p "$WORKDIR/frames"
WORKDIR="$(cd "$WORKDIR" && pwd)"

# --- 1. Acquire the video -------------------------------------------------
VIDEO=""
if [[ "$INPUT" =~ ^https?:// ]]; then
  command -v yt-dlp >/dev/null || err "yt-dlp not found (needed for URLs). Install with: brew install yt-dlp"
  echo "Downloading video (<=720p) and captions..."
  yt-dlp -f "bv*[height<=720]+ba/b[height<=720]/b" \
    --write-auto-subs --write-subs --sub-format vtt --sub-langs "en.*,en" \
    -o "$WORKDIR/video.%(ext)s" \
    --no-playlist "$INPUT" >&2
  VIDEO="$(find "$WORKDIR" -maxdepth 1 -name 'video.*' ! -name '*.vtt' ! -name '*.part' | head -1)"
  [ -n "$VIDEO" ] || err "download failed: no video file produced"
  SUB="$(find "$WORKDIR" -maxdepth 1 -name 'video.*.vtt' | head -1)"
  [ -n "${SUB:-}" ] && mv "$SUB" "$WORKDIR/captions.vtt"
else
  [ -f "$INPUT" ] || err "file not found: $INPUT"
  ext="${INPUT##*.}"
  cp "$INPUT" "$WORKDIR/video.$ext"
  VIDEO="$WORKDIR/video.$ext"
fi

DURATION="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$VIDEO" | cut -d. -f1)"
[ -n "$DURATION" ] || err "could not read video duration (unsupported format?)"

# --- 2. Extract audio for whisper (skip if captions exist) ----------------
if [ ! -f "$WORKDIR/captions.vtt" ]; then
  echo "Extracting audio..."
  ffmpeg -y -v error -i "$VIDEO" -vn -ar 16000 -ac 1 -c:a pcm_s16le "$WORKDIR/audio.wav"
fi

# --- 3. Keyframe extraction via scene detection ---------------------------
# Screen recordings transition subtly, so use a low threshold, then adapt.
echo "Detecting screen changes..."
extract_frames() {
  local threshold="$1"
  rm -f "$WORKDIR/frames/"*.png "$WORKDIR/scene_times.txt"
  ffmpeg -y -v info -i "$VIDEO" \
    -vf "select='gt(scene,$threshold)',showinfo" -fps_mode vfr \
    "$WORKDIR/frames/raw_%04d.png" 2>&1 |
    grep -o 'pts_time:[0-9.]*' | cut -d: -f2 > "$WORKDIR/scene_times.txt" || true
}

extract_frames 0.1
NFRAMES="$(ls "$WORKDIR/frames" 2>/dev/null | wc -l | tr -d ' ')"

if [ "$NFRAMES" -gt 60 ]; then
  echo "Too many changes ($NFRAMES) — raising threshold..."
  extract_frames 0.25
  NFRAMES="$(ls "$WORKDIR/frames" | wc -l | tr -d ' ')"
fi

if [ "$NFRAMES" -lt 5 ]; then
  # Static screen recording: fall back to interval sampling (1 frame / 15s).
  echo "Few scene changes detected ($NFRAMES) — sampling every 15s instead..."
  rm -f "$WORKDIR/frames/"*.png
  : > "$WORKDIR/scene_times.txt"
  t=0
  while [ "$t" -lt "$DURATION" ]; do
    echo "$t" >> "$WORKDIR/scene_times.txt"
    t=$((t + 15))
  done
  i=1
  while read -r ts; do
    ffmpeg -y -v error -ss "$ts" -i "$VIDEO" -frames:v 1 \
      "$(printf "%s/frames/raw_%04d.png" "$WORKDIR" "$i")"
    i=$((i + 1))
  done < "$WORKDIR/scene_times.txt"
fi

# Always include the first and last second of the video.
FIRST_LAST_TIMES="0
$((DURATION > 1 ? DURATION - 1 : 0))"
n_existing="$(ls "$WORKDIR/frames" | wc -l | tr -d ' ')"
i=$((n_existing + 1))
while read -r ts; do
  ffmpeg -y -v error -ss "$ts" -i "$VIDEO" -frames:v 1 \
    "$(printf "%s/frames/raw_%04d.png" "$WORKDIR" "$i")"
  echo "$ts" >> "$WORKDIR/scene_times.txt"
  i=$((i + 1))
done <<< "$FIRST_LAST_TIMES"

# --- 4. Rename frames to timestamped names, ordered by time ---------------
paste -d' ' <(ls "$WORKDIR/frames"/raw_*.png | sort) "$WORKDIR/scene_times.txt" |
while read -r png ts; do
  [ -n "$ts" ] || continue
  secs="${ts%%.*}"
  mm=$((secs / 60)); ss=$((secs % 60))
  dest="$(printf "%s/frames/frame_%02dm%02ds.png" "$WORKDIR" "$mm" "$ss")"
  mv "$png" "$dest" 2>/dev/null || true
done
rm -f "$WORKDIR/frames"/raw_*.png "$WORKDIR/scene_times.txt"

# --- 5. Summary -----------------------------------------------------------
NFRAMES="$(ls "$WORKDIR/frames" | wc -l | tr -d ' ')"
{
  echo "video: $VIDEO"
  echo "duration_seconds: $DURATION"
  echo "frames: $NFRAMES"
  echo "captions: $([ -f "$WORKDIR/captions.vtt" ] && echo yes || echo no)"
} | tee "$WORKDIR/meta.txt"
