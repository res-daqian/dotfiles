#!/usr/bin/env bash

set -euo pipefail

if ! command -v pdftotext >/dev/null 2>&1; then
  printf 'PDF preview requires pdftotext from poppler.\n'
  printf 'Install it with: brew install poppler\n'
  exit 0
fi

pdftotext -q "$1" -
