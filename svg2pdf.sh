#!/usr/bin/env bash
# Convert every SVG in assets/ to a PDF alongside it (assets/<name>.pdf).
set -euo pipefail

cd "$(dirname "$0")"
ASSETS_DIR="assets"

shopt -s nullglob
svgs=("$ASSETS_DIR"/*.svg)
if [ ${#svgs[@]} -eq 0 ]; then
  echo "No SVG files found in $ASSETS_DIR/"
  exit 0
fi

for svg in "${svgs[@]}"; do
  pdf="${svg%.svg}.pdf"
  echo "Converting $svg -> $pdf"
  # Filter Inkscape's harmless "unsupported target 0" stderr noise while
  # preserving inkscape's own exit status (process substitution, not a pipe).
  inkscape "$svg" --export-type=pdf --export-filename="$pdf" \
    2> >(grep -vE 'unsupported target|^[[:space:]]*$' >&2 || true)
done

echo "Done: ${#svgs[@]} file(s) converted."
