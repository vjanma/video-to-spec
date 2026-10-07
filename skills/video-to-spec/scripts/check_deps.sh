#!/usr/bin/env bash
# check_deps.sh: one-shot preflight for the video-to-spec toolchain.
#
# Reports every missing dependency in a single pass (instead of failing one at a
# time mid-run), and can install the missing ones via Homebrew on --install.
#
# Usage:
#   check_deps.sh                    report status; exit 0 if all present, 1 if missing
#   check_deps.sh --install [pkg…]   install the named brew packages (or, with no
#                                    names, just the missing REQUIRED ones), then re-report
#
# Only the caller (with the user's consent) should pass --install; the report
# mode never modifies the system. --install never touches optional tools unless
# they are named explicitly, so approval for one tool can't install another.
set -euo pipefail

MODE="${1:-report}"
[ $# -gt 0 ] && shift
APPROVED=("$@")

# tool→package→why. `python3` and `curl` ship with almost every system; the
# three media tools are the ones users actually need to install. yt-dlp and
# whisper-cpp are each only needed on one path, so they're marked optional.
#   ffmpeg      : always needed (audio + keyframes)
#   python3     : always needed (frame selection, caption cleanup)
#   curl        : always needed (whisper model download)
#   yt-dlp      : only for YouTube/URL input
#   whisper-cpp : only for videos without captions (local transcription)
check_one() {  # $1=command  $2=brew-package  $3=required|optional  $4=note
  local cmd="$1" pkg="$2" req="$3" note="$4"
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '  ✅ %-12s %s\n' "$cmd" "$note"
    return 0
  fi
  if [ "$req" = required ]; then
    printf '  ❌ %-12s MISSING (required): %s  [brew install %s]\n' "$cmd" "$note" "$pkg"
  else
    printf '  ⚠️  %-12s missing (optional): %s  [brew install %s]\n' "$cmd" "$note" "$pkg"
  fi
  return 1
}

# Space-separated "cmd:pkg:required|optional:note" records.
DEPS=(
  "ffmpeg:ffmpeg:required:audio extraction + keyframes"
  "ffprobe:ffmpeg:required:duration + stream probing (ships with ffmpeg)"
  "python3:python:required:frame selection + caption cleanup"
  "curl:curl:required:one-time whisper model download"
  "yt-dlp:yt-dlp:optional:needed only for YouTube / URL input"
  "whisper-cli:whisper-cpp:optional:needed only when a video has no captions"
)

missing_required=()
missing_optional=()

echo "video-to-spec dependency check:"
for rec in "${DEPS[@]}"; do
  IFS=: read -r cmd pkg req note <<<"$rec"
  if ! check_one "$cmd" "$pkg" "$req" "$note"; then
    if [ "$req" = required ]; then missing_required+=("$pkg"); else missing_optional+=("$pkg"); fi
  fi
done

# Combined set of things we'd install. The `+"..."` guards keep this working
# under `set -u` on bash 3.2 (macOS), where expanding an empty array errors.
to_install=(
  ${missing_required[@]+"${missing_required[@]}"}
  ${missing_optional[@]+"${missing_optional[@]}"}
)

if [ "${#to_install[@]}" -eq 0 ]; then
  echo
  echo "All dependencies present."
  exit 0
fi

if [ "$MODE" != "--install" ]; then
  echo
  if [ "${#missing_required[@]}" -gt 0 ]; then
    echo "Missing required: ${missing_required[*]}"
  fi
  if [ "${#missing_optional[@]}" -gt 0 ]; then
    echo "Missing optional (install only if you'll use that path): ${missing_optional[*]}"
  fi
  if command -v brew >/dev/null 2>&1; then
    echo "Install all with: brew install ${to_install[*]}"
    echo "Or re-run this script with --install to install the missing tools."
  else
    # Linux package names differ from Homebrew's (python -> python3, and
    # whisper-cpp isn't packaged; it's built from source).
    linux_pkgs="${to_install[*]}"
    linux_pkgs="${linux_pkgs//whisper-cpp/}"
    linux_pkgs="${linux_pkgs//python/python3}"
    echo "Homebrew not found."
    echo "  • macOS: install Homebrew from https://brew.sh, then: brew install ${to_install[*]}"
    echo "  • Debian/Ubuntu: sudo apt install ${linux_pkgs}  (whisper.cpp: build from https://github.com/ggerganov/whisper.cpp)"
    echo "  • Fedora: sudo dnf install ${linux_pkgs}"
  fi
  exit 1
fi

# --- --install mode -------------------------------------------------------
# Install only what was approved: the explicitly named packages, or (with no
# names) just the missing required set. Optional tools are never implied.
if [ "${#APPROVED[@]}" -gt 0 ]; then
  install_set=("${APPROVED[@]}")
else
  install_set=(${missing_required[@]+"${missing_required[@]}"})
  if [ "${#missing_optional[@]}" -gt 0 ]; then
    echo
    echo "Note: not installing optional tools (${missing_optional[*]}): name them explicitly to include them."
  fi
fi

if [ "${#install_set[@]}" -eq 0 ]; then
  echo
  echo "Nothing to install."
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  echo
  echo "ERROR: --install requires Homebrew, which isn't installed." >&2
  echo "Install Homebrew from https://brew.sh, or install these manually: ${install_set[*]}" >&2
  exit 1
fi

echo
echo "Installing via Homebrew: ${install_set[*]}"
brew install "${install_set[@]}"

echo
echo "Re-checking..."
exec "$0"   # re-run in report mode to confirm
