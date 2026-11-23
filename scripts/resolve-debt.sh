#!/usr/bin/env bash
set -euo pipefail

DEBT_ID=""
RESOLUTION_NOTE="manual resolution"
FILE="TECHDEBT.md"

# Parse arguments
if [ $# -ge 1 ]; then
  DEBT_ID="$1"
fi
if [ $# -ge 2 ]; then
  RESOLUTION_NOTE="$2"
fi
if [ $# -ge 3 ]; then
  FILE="$3"
fi

if [ -z "$DEBT_ID" ]; then
  echo "Usage: $0 <DEBT-ID> [RESOLUTION_NOTE] [FILE]"
  exit 1
fi

# Normalize ID (strip brackets if provided)
DEBT_ID=$(echo "$DEBT_ID" | tr -d '[]')

if [ ! -f "$FILE" ]; then
  echo "Error: $FILE does not exist"
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo "Error: Node.js is required to execute resolve-debt.sh"
  exit 1
fi

DATE=$(date +%Y-%m-%d)

node -e '
const fs = require("fs");
const filePath = process.argv[1];
const id = process.argv[2];
const note = process.argv[3];
const date = process.argv[4];

const content = fs.readFileSync(filePath, "utf8");
const lines = content.split("\n");

// Check if already resolved
for (const line of lines) {
  if (line.includes("**[" + id + "]**") && /^\s*- \[[xX]\]/.test(line)) {
    console.log("Debt item [" + id + "] is already resolved.");
    process.exit(0);
  }
}

let targetIndex = -1;
let title = "";

for (let i = 0; i < lines.length; i++) {
  const line = lines[i];
  if (line.includes("**[" + id + "]**") && /^\s*- \[[ ]\]/.test(line)) {
    targetIndex = i;
    const match = line.match(/\*\*\[.*?\]\*\*\s*(.*)$/);
    title = match ? match[1].trim() : id;
    break;
  }
}

if (targetIndex === -1) {
  console.error("Error: Debt item [" + id + "] not found in pending list.");
  process.exit(1);
}

// Find extent of this item lines (until next "- [" or "## " or EOF)
let endIndex = targetIndex + 1;
while (endIndex < lines.length) {
  const line = lines[endIndex];
  if (/^\s*- \[[ xX]\]/.test(line) || /^##\s/.test(line)) {
    break;
  }
  endIndex++;
}

// Remove the item lines
lines.splice(targetIndex, endIndex - targetIndex);

// Find "## Resolved Debt"
let resolvedHeaderIndex = lines.findIndex(l => /^##\s+Resolved Debt/i.test(l));
if (resolvedHeaderIndex === -1) {
  lines.push("", "## Resolved Debt");
  resolvedHeaderIndex = lines.length - 1;
}

const resolvedLine = "- [x] **[" + id + "]** " + title + " (Resolved on " + date + " in " + note + ")";
lines.splice(resolvedHeaderIndex + 1, 0, resolvedLine);

fs.writeFileSync(filePath, lines.join("\n"), "utf8");
console.log("Successfully resolved [" + id + "] in " + filePath);
' "$FILE" "$DEBT_ID" "$RESOLUTION_NOTE" "$DATE"
