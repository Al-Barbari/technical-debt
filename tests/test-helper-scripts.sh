#!/usr/bin/env bash
set -euo pipefail

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Create a sample TECHDEBT.md in temp directory
cat << 'EOF' > "$TMP_DIR/TECHDEBT.md"
# Technical Debt & Deferred Work

## Pending Debt
- [ ] **[DEBT-001]** Refactor auth token refresh
  - **Location**: `src/auth.ts#L20`
  - **Category**: `Prudent Shortcut`
  - **Severity**: `High`
  - **Why Deferred**: Postponed for MVP
  - **Logged**: 2026-11-23 by Developer

- [ ] **[DEBT-002]** Add unit tests for payment webhook
  - **Location**: `src/pay.ts#L45`
  - **Category**: `Missing Tests`
  - **Severity**: `Critical`
  - **Why Deferred**: Awaiting webhook sandbox credentials
  - **Logged**: 2026-11-23 by Agent

## Resolved Debt
- [x] **[DEBT-000]** Initial setup
EOF

# Test check-debt.sh reports 2 pending items
OUTPUT=$(cd "$TMP_DIR" && bash /root/development/fixflow/scripts/check-debt.sh || true)
echo "$OUTPUT" | grep -q "Pending items: 2" || { echo "FAIL: check-debt did not report 2 pending items"; exit 1; }
echo "$OUTPUT" | grep -q "Critical items: 1" || { echo "FAIL: check-debt did not report 1 critical item"; exit 1; }

# Test check-debt.sh --strict without specifying filename should catch Critical debt and exit 1
if (cd "$TMP_DIR" && bash /root/development/fixflow/scripts/check-debt.sh --strict); then
  echo "FAIL: check-debt --strict should have exited with code 1 due to critical debt"
  exit 1
fi

# Test resolve-debt.sh resolves DEBT-001
(cd "$TMP_DIR" && bash /root/development/fixflow/scripts/resolve-debt.sh "DEBT-001" "commit-abc123")
grep -q "\- \[x\] \*\*\[DEBT-001\]\*\*" "$TMP_DIR/TECHDEBT.md" || { echo "FAIL: resolve-debt failed to mark DEBT-001 resolved"; exit 1; }

# Test resolve-debt.sh on already resolved item is idempotent
RESOLVE_AGAIN=$(cd "$TMP_DIR" && bash /root/development/fixflow/scripts/resolve-debt.sh "DEBT-001" "commit-xyz" || true)
echo "$RESOLVE_AGAIN" | grep -q "already resolved" || { echo "FAIL: resolve-debt was not idempotent for already resolved item"; exit 1; }

echo "PASS: Helper scripts working properly"
