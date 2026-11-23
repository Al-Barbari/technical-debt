#!/usr/bin/env bash
set -euo pipefail

FILE="skills/technical-debt/DEBT-FORMAT.md"
if [ ! -f "$FILE" ]; then
  echo "FAIL: $FILE missing"
  exit 1
fi

grep -q "## Pending Debt" "$FILE" || { echo "FAIL: Missing Pending Debt section"; exit 1; }
grep -q "## Resolved Debt" "$FILE" || { echo "FAIL: Missing Resolved Debt section"; exit 1; }
grep -q "Location" "$FILE" || { echo "FAIL: Missing Location specification"; exit 1; }
grep -q "Category" "$FILE" || { echo "FAIL: Missing Category specification"; exit 1; }
grep -q "Severity" "$FILE" || { echo "FAIL: Missing Severity specification"; exit 1; }

echo "PASS: DEBT-FORMAT.md valid"
