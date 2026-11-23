#!/usr/bin/env bash
set -euo pipefail

if [ ! -f "plugin.json" ]; then
  echo "FAIL: plugin.json missing"
  exit 1
fi

if [ ! -f "rules/AGENTS.md" ]; then
  echo "FAIL: rules/AGENTS.md missing"
  exit 1
fi

# Validate plugin.json contains valid JSON and required fields
node -e '
  const p = JSON.parse(require("fs").readFileSync("plugin.json", "utf8"));
  if (p.name !== "technical-debt") process.exit(1);
  if (!p.description || !p.version) process.exit(1);
' || { echo "FAIL: plugin.json invalid"; exit 1; }

# Validate rules/AGENTS.md contains debt trigger rules
grep -q "TECHDEBT.md" rules/AGENTS.md || { echo "FAIL: rules missing TECHDEBT.md mention"; exit 1; }
grep -q "Trigger Phrases" rules/AGENTS.md || { echo "FAIL: rules missing Trigger Phrases"; exit 1; }

echo "PASS: Manifest and rules valid"
