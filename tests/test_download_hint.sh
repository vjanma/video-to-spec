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

echo
[ "$fails" -eq 0 ] && echo "all passed" || { echo "$fails failed"; exit 1; }
