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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# --- 3. Keyframe selection ------------------------------------------------
# Screen recordings transition subtly and unevenly: a busy stretch (e.g. a
# slide deck) fires many scene changes while a content-rich intro barely trips
# the detector. We detect scene changes at a low threshold, drop adjacent
# near-duplicates with mpdecimate, then hand the timestamps to select_frames.py
# — which guarantees timeline coverage, caps frames per bucket, and offsets each
# capture past the transition so frames land on the settled screen, not a
# motion-blurred crossfade.
echo "Detecting screen changes..."
detect_scenes() {   # $1=output file  $2=scene threshold
  ffmpeg -v info -i "$VIDEO" \
    -vf "select='gt(scene,$2)',mpdecimate,showinfo" -fps_mode vfr -f null - 2>&1 |
    grep -o 'pts_time:[0-9.]*' | cut -d: -f2 > "$1" || true
}

CAND="$WORKDIR/cand_times.txt"
detect_scenes "$CAND" 0.1
NCAND="$(grep -c . "$CAND" 2>/dev/null || echo 0)"
if [ "$NCAND" -gt 120 ]; then
  echo "Very busy video ($NCAND changes) — raising threshold..."
  detect_scenes "$CAND" 0.25
fi

# Turn raw candidates into a well-distributed, deduplicated, settled set.
# select_frames.py also guarantees coverage when there are few/no scene
# changes (a static recording), so no separate interval-sampling fallback.
SEL="$WORKDIR/sel_times.txt"
python3 "$SCRIPT_DIR/select_frames.py" "$DURATION" < "$CAND" > "$SEL"

# --- 4. Extract one settled frame per selected timestamp ------------------
while read -r ts; do
  [ -n "$ts" ] || continue
  secs="${ts%%.*}"
  mm=$((secs / 60)); ss=$((secs % 60))
  dest="$(printf "%s/frames/frame_%02dm%02ds.png" "$WORKDIR" "$mm" "$ss")"
  ffmpeg -y -v error -ss "$ts" -i "$VIDEO" -frames:v 1 "$dest"
done < "$SEL"
rm -f "$CAND" "$SEL"

# --- 5. Summary -----------------------------------------------------------
NFRAMES="$(ls "$WORKDIR/frames" | wc -l | tr -d ' ')"
{
  echo "video: $VIDEO"
  echo "duration_seconds: $DURATION"
  echo "frames: $NFRAMES"
  echo "captions: $([ -f "$WORKDIR/captions.vtt" ] && echo yes || echo no)"
} | tee "$WORKDIR/meta.txt"
