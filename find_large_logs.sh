#!/usr/bin/env bash
set -euo pipefail

# Default values
SEARCH_PATH="/var/log"
SIZE_THRESHOLD="500M"

# Αν δώσει arguments
if [[ $# -ge 1 ]]; then
  SEARCH_PATH="$1"
fi

if [[ $# -ge 2 ]]; then
  SIZE_THRESHOLD="$2"
fi

# Help message
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  echo "Usage: $0 [path] [size]"
  echo "Example:"
  echo "  $0 /var/log 500M"
  echo "  $0 /home/user 1G"
  exit 0
fi

echo "🔍 Searching in: $SEARCH_PATH"
echo "📦 Size threshold: $SIZE_THRESHOLD"
echo ""

find "$SEARCH_PATH" -type f -size +"$SIZE_THRESHOLD" 2>/dev/null \
  | xargs -r du -h \
  | sort -hr
