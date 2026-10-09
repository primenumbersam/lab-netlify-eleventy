#!/usr/bin/env bash
set -e

./typst/scripts/ensure-typst.sh
./typst/scripts/ensure-fonts.sh
export PATH="$(pwd)/bin:$PATH"
export TYPST_FONT_PATHS="$(pwd)/typst/fonts"

mkdir -p _site/pdf

count=0
for f in content/*.typ; do
  [ -e "$f" ] || continue
  filename=$(basename -- "$f")
  basename="${filename%.*}"
  echo "==> Compiling Typst: $f -> _site/pdf/${basename}.pdf"
  typst compile --root . --font-path "$TYPST_FONT_PATHS" "$f" "_site/pdf/${basename}.pdf"
  count=$((count + 1))
done

echo "==> Typst build finished: ${count} PDF(s) generated."
