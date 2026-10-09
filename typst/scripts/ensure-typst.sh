#!/usr/bin/env bash
set -e

if ! command -v typst &> /dev/null; then
  if [ ! -f "./bin/typst" ]; then
    echo "==> Downloading Typst CLI..."
    mkdir -p bin
    curl -sL "https://github.com/typst/typst/releases/download/v0.15.1/typst-x86_64-unknown-linux-musl.tar.xz" | tar -xJ -C bin --strip-components=1
  fi
  export PATH="$(pwd)/bin:$PATH"
fi

echo "==> Using Typst: $(typst --version)"
