#!/usr/bin/env bash
set -euo pipefail

STRICT=0
FILE="TECHDEBT.md"

for arg in "$@"; do
  case "$arg" in
    --strict)
      STRICT=1
      ;;
    *)
      FILE="$arg"
      ;;
  esac
done

if [ ! -f "$FILE" ]; then
  echo "No $FILE found in current directory."
  exit 0
fi

# Count pending and resolved items
PENDING=$(grep -c '^[[:space:]]*- \[ \] \*\*\[DEBT-' "$FILE" || true)
RESOLVED=$(grep -E -c '^[[:space:]]*- \[[xX]\] \*\*\[DEBT-' "$FILE" || true)

# Isolate ## Pending Debt block to prevent false positives from resolved items or notes
PENDING_BLOCK=$(awk '/^## Pending Debt/{flag=1; next} /^## Resolved Debt/{flag=0} flag' "$FILE")

CRITICAL=$(echo "$PENDING_BLOCK" | grep -i -c 'Severity.*Critical' || true)
HIGH=$(echo "$PENDING_BLOCK" | grep -i -c 'Severity.*High' || true)
MEDIUM=$(echo "$PENDING_BLOCK" | grep -i -c 'Severity.*Medium' || true)
LOW=$(echo "$PENDING_BLOCK" | grep -i -c 'Severity.*Low' || true)

echo "=== Technical Debt Summary ==="
echo "File: $FILE"
echo "Pending items: $PENDING"
echo "  - Critical items: $CRITICAL"
echo "  - High items: $HIGH"
echo "  - Medium items: $MEDIUM"
echo "  - Low items: $LOW"
echo "Resolved items: $RESOLVED"

if [ "$STRICT" -eq 1 ] && [ "$CRITICAL" -gt 0 ]; then
  echo "ERROR: Strict check failed due to $CRITICAL Critical debt item(s)."
  exit 1
fi

exit 0
