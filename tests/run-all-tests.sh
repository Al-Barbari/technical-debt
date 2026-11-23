#!/usr/bin/env bash
set -euo pipefail

echo "================================================="
echo "  Running Technical Debt Plugin & Skill Tests    "
echo "================================================="

bash tests/test-repo-structure.sh
bash tests/test-manifest-and-rules.sh
bash tests/test-debt-format-spec.sh
bash tests/test-skill-definition.sh
bash tests/test-helper-scripts.sh

# Verify README and LICENSE exist
if [ ! -f "README.md" ]; then
  echo "FAIL: README.md missing"
  exit 1
fi

if [ ! -f "LICENSE" ]; then
  echo "FAIL: LICENSE missing"
  exit 1
fi

echo "================================================="
echo "              ALL TESTS PASSED!                  "
echo "================================================="
