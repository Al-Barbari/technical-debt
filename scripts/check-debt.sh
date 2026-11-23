#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-TECHDEBT.md}"

if [ ! -f "$FILE" ]; then
  echo "No $FILE found in current directory."
  exit 0
fi

PENDING=$(grep -c '^[[:space:]]*- \[ \] \*\*\[DEBT-' "$FILE" || true)
RESOLVED=$(grep -c '^[[:space:]]*- \[x\] \*\*\[DEBT-' "$FILE" || true)

# Count pending severities
CRITICAL=$(grep -i -c 'Severity.*Critical' "$FILE" || true)
HIGH=$(grep -i -c 'Severity.*High' "$FILE" || true)
MEDIUM=$(grep -i -c 'Severity.*Medium' "$FILE" || true)
LOW=$(grep -i -c 'Severity.*Low' "$FILE" || true)

echo "=== Technical Debt Summary ==="
echo "File: $FILE"
echo "Pending items: $PENDING"
echo "  - Critical items: $CRITICAL"
echo "  - High items: $HIGH"
echo "  - Medium items: $MEDIUM"
echo "  - Low items: $LOW"
echo "Resolved items: $RESOLVED"

if [[ "${2:-}" == "--strict" && "$CRITICAL" -gt 0 ]]; then
  echo "WARNING: Strict check failed due to $CRITICAL Critical debt item(s)."
  exit 1
fi

exit 0
