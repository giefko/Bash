#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <access_log_file>"
  exit 1
fi

awk '{print $1}' "$1" | sort | uniq -c | sort -nr | head -10
6