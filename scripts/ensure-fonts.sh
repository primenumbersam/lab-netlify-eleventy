#!/usr/bin/env bash
set -e

FONT_DIR="$(pwd)/typst/fonts"
FONT_FILE="$FONT_DIR/NotoSansKR-Variable.ttf"
FONT_URL="https://raw.githubusercontent.com/google/fonts/main/ofl/notosanskr/NotoSansKR%5Bwght%5D.ttf"

mkdir -p "$FONT_DIR"

if [ ! -f "$FONT_FILE" ]; then
  echo "==> Downloading default Korean font (Noto Sans KR)..."
  curl -sSL "$FONT_URL" -o "$FONT_FILE"
fi

echo "==> Korean fonts ready in $FONT_DIR"
