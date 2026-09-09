#!/usr/bin/env bash
set -e

./scripts/ensure-typst.sh
./scripts/ensure-fonts.sh
export PATH="$(pwd)/bin:$PATH"
export TYPST_FONT_PATHS="$(pwd)/typst/fonts"

mkdir -p _site/pdf

count=0
for f in typst/*.typ; do
  [ -e "$f" ] || continue
  filename=$(basename -- "$f")
  basename="${filename%.*}"
  echo "==> Compiling Typst: $f -> _site/pdf/${basename}.pdf"
  typst compile --font-path "$TYPST_FONT_PATHS" "$f" "_site/pdf/${basename}.pdf"
  count=$((count + 1))
done

echo "==> Typst build finished: ${count} PDF(s) generated."
