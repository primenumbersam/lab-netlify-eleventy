#!/usr/bin/env bash
set -e

./scripts/ensure-typst.sh
export PATH="$(pwd)/bin:$PATH"

mkdir -p _site/pdf

count=0
for f in typst/*.typ; do
  [ -e "$f" ] || continue
  filename=$(basename -- "$f")
  basename="${filename%.*}"
  echo "==> Compiling Typst: $f -> _site/pdf/${basename}.pdf"
  typst compile "$f" "_site/pdf/${basename}.pdf"
  count=$((count + 1))
done

echo "==> Typst build finished: ${count} PDF(s) generated."
