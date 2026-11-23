#!/usr/bin/env bash
set -euo pipefail

SKILL="skills/technical-debt/SKILL.md"
if [ ! -f "$SKILL" ]; then
  echo "FAIL: $SKILL missing"
  exit 1
fi

# Verify YAML frontmatter
head -n 5 "$SKILL" | grep -q "^name: technical-debt" || { echo "FAIL: Missing or invalid name"; exit 1; }
head -n 5 "$SKILL" | grep -q "^description: Use when" || { echo "FAIL: Missing or invalid description"; exit 1; }

# Verify core lifecycle sections
grep -q "## 1. When to Trigger" "$SKILL" || { echo "FAIL: Missing Trigger section"; exit 1; }
grep -q "## 2. Immediate Inline Capture" "$SKILL" || { echo "FAIL: Missing Capture section"; exit 1; }
grep -q "## 3. Active Debt Inquiries" "$SKILL" || { echo "FAIL: Missing Inquiries section"; exit 1; }
grep -q "## 4. Debt Paydown Workflow" "$SKILL" || { echo "FAIL: Missing Paydown section"; exit 1; }

echo "PASS: SKILL.md valid"
