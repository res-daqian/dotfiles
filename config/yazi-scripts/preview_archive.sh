#!/usr/bin/env bash

set -euo pipefail

archive="${1:-}"

if [ -z "$archive" ]; then
  printf 'Usage: preview_archive.sh <archive>\n'
  exit 0
fi

if command -v 7zz >/dev/null 2>&1; then
  exec 7zz l "$archive"
fi

if command -v 7z >/dev/null 2>&1; then
  exec 7z l "$archive"
fi

if command -v bsdtar >/dev/null 2>&1; then
  exec bsdtar -tf "$archive"
fi

if command -v tar >/dev/null 2>&1; then
  exec tar -tf "$archive"
fi

if command -v unzip >/dev/null 2>&1; then
  exec unzip -l "$archive"
fi

printf 'Archive preview requires 7-Zip or a compatible archive tool.\n'
printf 'Install it with: brew install sevenzip\n'
