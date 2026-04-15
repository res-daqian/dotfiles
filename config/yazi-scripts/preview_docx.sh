#!/usr/bin/env bash

set -euo pipefail

if ! command -v textutil >/dev/null 2>&1; then
  printf 'DOCX preview requires textutil, which is built into macOS.\n'
  exit 0
fi

textutil -stdout -convert txt "$1"
