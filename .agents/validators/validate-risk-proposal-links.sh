#!/usr/bin/env bash
set -u
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v python3 >/dev/null 2>&1; then
  printf '%s\n' 'FATAL|TOOLING|.|python3 is required by the risk/proposal validator.'
  exit 2
fi

if [ "$#" -eq 0 ]; then
  VALIDATION_ROOT="$PWD"
elif [ "$#" -eq 2 ] && [ "$1" = "--root" ]; then
  VALIDATION_ROOT="$2"
else
  printf '%s\n' 'FATAL|USAGE|.|usage: bash .agents/validators/validate-risk-proposal-links.sh [--root PATH]'
  exit 2
fi

exec python3 "$SCRIPT_DIR/validate-risk-proposal-links.py" "$VALIDATION_ROOT"
