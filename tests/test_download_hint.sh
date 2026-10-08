#!/usr/bin/env bash
# test_download_hint.sh: process_video.sh names the fix when yt-dlp is blocked.
# Uses a stub yt-dlp on PATH, so no network is needed.
# Run: bash tests/test_download_hint.sh
set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$HERE/../skills/video-to-spec/scripts/process_video.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fails=0
check() { # check <label> <pattern> <text>
  if printf '%s' "$3" | grep -q -- "$2"; then echo "ok   $1"; else echo "FAIL $1: no [$2] in output"; fails=$((fails + 1)); fi
}

stub() { # stub <stderr line>
  mkdir -p "$TMP/bin"
  cat > "$TMP/bin/yt-dlp" <<EOF
#!/usr/bin/env bash
[ "\${1:-}" = "--version" ] && { echo 2026.03.17; exit 0; }
echo "$1" >&2
exit 1
EOF
  chmod +x "$TMP/bin/yt-dlp"
}

# 1. YouTube refusal (the failure seen on 2026-10-07): names the upgrade.
stub "ERROR: unable to download video data: HTTP Error 403: Forbidden"
out="$(PATH="$TMP/bin:$PATH" bash "$SCRIPT" "https://www.youtube.com/watch?v=x" "$TMP/w1" 2>&1)"; code=$?
check "403 exits nonzero" "nonzero" "$([ $code -ne 0 ] && echo nonzero)"
check "403 names brew upgrade" "brew upgrade yt-dlp" "$out"
check "403 shows installed version" "2026.03.17" "$out"
check "403 keeps yt-dlp output" "HTTP Error 403" "$out"

# 2. Bot check wording also counts as a refusal.
stub "ERROR: [youtube] x: Sign in to confirm you're not a bot"
out="$(PATH="$TMP/bin:$PATH" bash "$SCRIPT" "https://www.youtube.com/watch?v=x" "$TMP/w2" 2>&1)"
check "bot check names brew upgrade" "brew upgrade yt-dlp" "$out"

# 3. Other failures get the generic message, not the upgrade hint.
stub "ERROR: [youtube] x: Video unavailable. This video is private"
out="$(PATH="$TMP/bin:$PATH" bash "$SCRIPT" "https://www.youtube.com/watch?v=x" "$TMP/w3" 2>&1)"
check "private video generic error" "download failed" "$out"
if printf '%s' "$out" | grep -q "brew upgrade"; then echo "FAIL private video: upgrade hint shown"; fails=$((fails + 1)); else echo "ok   private video: no upgrade hint"; fi

# 4. Caption languages skip machine-translated tracks (en-en-US), which
#    YouTube rate-limits with HTTP 429 (seen 2026-10-08), but keep en-US.
mkdir -p "$TMP/argbin"
cat > "$TMP/argbin/yt-dlp" <<'EOF2'
#!/usr/bin/env bash
[ "${1:-}" = "--version" ] && { echo 2026.08.19; exit 0; }
printf '%s\n' "$@" > "$ARGS_OUT"
exit 1
EOF2
chmod +x "$TMP/argbin/yt-dlp"
ARGS_OUT="$TMP/args.txt" PATH="$TMP/argbin:$PATH" bash "$SCRIPT" "https://www.youtube.com/watch?v=x" "$TMP/w4" >/dev/null 2>&1
langs="$(grep -A1 -- '--sub-langs' "$TMP/args.txt" | tail -1)"
check "sub-langs excludes translated tracks" "-en-en" "$langs"
match() { python3 -c "import re,sys;print(bool(re.compile(sys.argv[1],re.I).fullmatch(sys.argv[2])))" "$1" "$2"; }
picks() { # picks <lang>: would yt-dlp request this caption track?
  local want=False; IFS=',' read -ra pats <<< "$langs"
  for p in "${pats[@]}"; do
    if [[ "$p" == -* ]]; then [ "$(match "${p:1}" "$1")" = True ] && want=False
    else [ "$(match "$p" "$1")" = True ] && want=True; fi
  done; echo "$want"; }
check "keeps human en-US captions" "True" "$(picks en-US)"
check "keeps en" "True" "$(picks en)"
check "drops en-en-US translation" "False" "$(picks en-en-US)"

# 5. A caption-only failure retries the video without captions (whisper path).
mkdir -p "$TMP/subbin"
cat > "$TMP/subbin/yt-dlp" <<'EOF2'
#!/usr/bin/env bash
[ "${1:-}" = "--version" ] && { echo 2026.08.19; exit 0; }
out=""; prev=""
for a in "$@"; do [ "$prev" = "-o" ] && out="$a"; prev="$a"; done
if printf '%s\n' "$@" | grep -q -- '--write-subs'; then
  echo "ERROR: Unable to download video subtitles for 'en': HTTP Error 429: Too Many Requests" >&2
  exit 1
fi
ffmpeg -v error -f lavfi -i testsrc=duration=2:size=160x120 -f lavfi -i sine=duration=2 -shortest "${out%.%(ext)s}.mp4"
EOF2
chmod +x "$TMP/subbin/yt-dlp"
out="$(PATH="$TMP/subbin:$PATH" bash "$SCRIPT" "https://www.youtube.com/watch?v=x" "$TMP/w5" 2>&1)"; code=$?
check "caption failure retries without captions" "without captions" "$out"
check "caption failure still downloads video" "yes" "$([ -n "$(find "$TMP/w5" -maxdepth 1 -name 'video.mp4')" ] && echo yes)"
check "caption failure falls back to audio" "yes" "$([ -f "$TMP/w5/audio.wav" ] && echo yes)"

# 6. With several caption tracks, a region-coded one (often the human track)
#    wins over auto-generated en and en-orig.
mkdir -p "$TMP/vttbin"
cat > "$TMP/vttbin/yt-dlp" <<'EOF2'
#!/usr/bin/env bash
[ "${1:-}" = "--version" ] && { echo 2026.08.19; exit 0; }
out=""; prev=""
for a in "$@"; do [ "$prev" = "-o" ] && out="$a"; prev="$a"; done
base="${out%.%(ext)s}"
for l in en-orig en en-US; do printf 'WEBVTT\n\n00:00:00.000 --> 00:00:01.000\ntrack %s\n' "$l" > "$base.$l.vtt"; done
ffmpeg -v error -f lavfi -i testsrc=duration=2:size=160x120 "$base.mp4"
EOF2
chmod +x "$TMP/vttbin/yt-dlp"
PATH="$TMP/vttbin:$PATH" bash "$SCRIPT" "https://www.youtube.com/watch?v=x" "$TMP/w6" >/dev/null 2>&1
check "prefers region-coded captions" "track en-US" "$(cat "$TMP/w6/captions.vtt" 2>/dev/null)"

echo
[ "$fails" -eq 0 ] && echo "all passed" || { echo "$fails failed"; exit 1; }
