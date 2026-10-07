#!/usr/bin/env bash
# spec_target.sh: decide where the spec goes and which template to follow.
#
# Usage: spec_target.sh <short-name> [start-dir]
#
# Inside a Spec Kit repository (nearest ancestor with .specify/, stopping at the
# git root), mirrors /speckit-specify: specs/<prefix>-<short-name>/ with a
# sequential NNN or timestamp prefix per .specify/init-options.json, the spec
# template resolved through the repo's override stack, and the directory
# recorded in .specify/feature.json. Otherwise uses ./spec-<short-name>/ and the
# bundled template. Creates the directory; never touches an existing spec.md.
#
# Prints key=value lines: mode, feature_dir, spec_file, ui_file, template.
set -euo pipefail

SHORT="${1:-}"
START="${2:-.}"
if ! printf '%s' "$SHORT" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
  echo "ERROR: short name must be lowercase words joined by hyphens, got '$SHORT'" >&2
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUNDLED="$(cd "$SCRIPT_DIR/../references" && pwd)/spec-template.md"
START="$(cd "$START" && pwd)"

# Nearest ancestor holding .specify/, not crossing the git root.
ROOT=""
d="$START"
while :; do
  if [ -d "$d/.specify" ]; then ROOT="$d"; break; fi
  if [ -e "$d/.git" ] || [ "$d" = "/" ]; then break; fi
  d="$(dirname "$d")"
done

if [ -z "$ROOT" ]; then
  dir="$START/spec-$SHORT"
  n=2
  while [ -e "$dir/spec.md" ]; do dir="$START/spec-$SHORT-$n"; n=$((n + 1)); done
  mkdir -p "$dir"
  printf 'mode=standalone\nfeature_dir=%s\nspec_file=%s/spec.md\nui_file=%s/ui-evidence.md\ntemplate=%s\n' \
    "$dir" "$dir" "$dir" "$BUNDLED"
  exit 0
fi

# Numbering mode: feature_numbering, else the deprecated branch_numbering.
numbering="sequential"
opts="$ROOT/.specify/init-options.json"
if [ -f "$opts" ]; then
  numbering="$(python3 -c '
import json, sys
try:
    o = json.load(open(sys.argv[1]))
except Exception:
    o = {}
print(o.get("feature_numbering") or o.get("branch_numbering") or "sequential")
' "$opts")"
fi

mkdir -p "$ROOT/specs"
if [ "$numbering" = "timestamp" ]; then
  prefix="$(date +%Y%m%d-%H%M%S)"
else
  max=0
  for p in "$ROOT"/specs/*/; do
    name="$(basename "$p")"
    if printf '%s' "$name" | grep -Eq '^[0-9]{3,}-' && ! printf '%s' "$name" | grep -Eq '^[0-9]{8}-[0-9]{6}-'; then
      num=$((10#${name%%-*}))
      [ "$num" -gt "$max" ] && max=$num
    fi
  done
  prefix="$(printf '%03d' $((max + 1)))"
fi
rel="specs/$prefix-$SHORT"
while [ -e "$ROOT/$rel/spec.md" ]; do # only reachable with a clock collision
  sleep 1; prefix="$(date +%Y%m%d-%H%M%S)"; rel="specs/$prefix-$SHORT"
done
mkdir -p "$ROOT/$rel"

# Template: the repo's own resolver when present, else overrides, core, bundled.
template=""
common="$ROOT/.specify/scripts/bash/common.sh"
if [ -f "$common" ]; then
  template="$( (set +eu; source "$common" >/dev/null 2>&1; resolve_template spec-template "$ROOT") 2>/dev/null || true)"
fi
if [ -z "$template" ]; then
  for t in "$ROOT/.specify/templates/overrides/spec-template.md" "$ROOT/.specify/templates/spec-template.md" "$BUNDLED"; do
    if [ -f "$t" ]; then template="$t"; break; fi
  done
fi

printf '{"feature_directory": "%s"}\n' "$rel" > "$ROOT/.specify/feature.json"

printf 'mode=speckit\nfeature_dir=%s\nspec_file=%s/spec.md\nui_file=%s/ui-evidence.md\ntemplate=%s\n' \
  "$ROOT/$rel" "$ROOT/$rel" "$ROOT/$rel" "$template"
