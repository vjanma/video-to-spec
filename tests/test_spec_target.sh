#!/usr/bin/env bash
# test_spec_target.sh: fixtures for scripts/spec_target.sh (SC-002, FR-006, FR-007, NFR-002).
# Run: bash tests/test_spec_target.sh
set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$HERE/../skills/video-to-spec/scripts/spec_target.sh"
BUNDLED="$(cd "$HERE/../skills/video-to-spec/references" && pwd)/spec-template.md"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fails=0
check() { # check <label> <expected> <actual>
  if [ "$2" = "$3" ]; then echo "ok   $1"; else echo "FAIL $1: expected [$2] got [$3]"; fails=$((fails + 1)); fi
}
field() { printf '%s\n' "$1" | sed -n "s/^$2=//p"; }

# 1. No .specify/: standalone folder in the start directory, bundled template.
mkdir -p "$TMP/plain"
out="$(bash "$SCRIPT" acme-board "$TMP/plain")"
check "standalone mode" "standalone" "$(field "$out" mode)"
check "standalone dir" "$TMP/plain/spec-acme-board" "$(field "$out" feature_dir)"
check "standalone spec" "$TMP/plain/spec-acme-board/spec.md" "$(field "$out" spec_file)"
check "standalone ui" "$TMP/plain/spec-acme-board/ui-evidence.md" "$(field "$out" ui_file)"
check "standalone template" "$BUNDLED" "$(field "$out" template)"
check "standalone dir created" "yes" "$([ -d "$TMP/plain/spec-acme-board" ] && echo yes)"

# 1b. Standalone never overwrites: an existing spec.md pushes to -2.
touch "$TMP/plain/spec-acme-board/spec.md"
out="$(bash "$SCRIPT" acme-board "$TMP/plain")"
check "standalone no overwrite" "$TMP/plain/spec-acme-board-2" "$(field "$out" feature_dir)"

# 2. .specify/ with sequential numbering, existing 001 and 002, an override template.
R="$TMP/seq"
mkdir -p "$R/.specify/templates/overrides" "$R/specs/001-first" "$R/specs/002-second"
echo "# override" > "$R/.specify/templates/overrides/spec-template.md"
echo "# core" > "$R/.specify/templates/spec-template.md"
git -C "$R" init -q
mkdir -p "$R/sub/dir"
out="$(bash "$SCRIPT" acme-board "$R/sub/dir")"
check "speckit mode" "speckit" "$(field "$out" mode)"
check "speckit next number" "$R/specs/003-acme-board" "$(field "$out" feature_dir)"
check "speckit override template" "$R/.specify/templates/overrides/spec-template.md" "$(field "$out" template)"
check "feature.json written" '{"feature_directory": "specs/003-acme-board"}' "$(tr -d '\n' < "$R/.specify/feature.json")"

# 2b. No override: falls back to the core template.
rm "$R/.specify/templates/overrides/spec-template.md"
out="$(bash "$SCRIPT" other-thing "$R")"
check "speckit core template" "$R/.specify/templates/spec-template.md" "$(field "$out" template)"
check "speckit next after created" "$R/specs/004-other-thing" "$(field "$out" feature_dir)"

# 3. .specify/ with timestamp numbering.
T="$TMP/ts"
mkdir -p "$T/.specify/templates"
echo '{"feature_numbering": "timestamp"}' > "$T/.specify/init-options.json"
git -C "$T" init -q
out="$(bash "$SCRIPT" acme-board "$T")"
dir="$(basename "$(field "$out" feature_dir)")"
check "timestamp prefix" "match" "$(printf '%s' "$dir" | grep -Eq '^[0-9]{8}-[0-9]{6}-acme-board$' && echo match)"
check "timestamp falls back to bundled template" "$BUNDLED" "$(field "$out" template)"

# 4. Bad short name is rejected.
if bash "$SCRIPT" "Bad Name!" "$TMP/plain" >/dev/null 2>&1; then
  check "rejects bad short name" "nonzero" "zero"
else
  check "rejects bad short name" "nonzero" "nonzero"
fi

echo
[ "$fails" -eq 0 ] && echo "all passed" || { echo "$fails failed"; exit 1; }
