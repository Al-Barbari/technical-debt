#!/usr/bin/env bash
set -euo pipefail

echo "=== Linting Shell Scripts ==="
for file in scripts/*.sh tests/*.sh; do
  if [ -f "$file" ]; then
    bash -n "$file"
    echo "OK: $file"
  fi
done

echo "=== Linting JSON Manifests ==="
node -e '
  JSON.parse(require("fs").readFileSync("plugin.json", "utf8"));
  console.log("OK: plugin.json");
  JSON.parse(require("fs").readFileSync("package.json", "utf8"));
  console.log("OK: package.json");
'

echo "=== All Lint Checks Passed ==="
