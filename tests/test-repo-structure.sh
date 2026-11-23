#!/usr/bin/env bash
set -euo pipefail

# Verify that legacy VS Code artifacts are removed
if [ -d "src" ]; then
  echo "FAIL: src/ still exists"
  exit 1
fi

if [ -f "esbuild.js" ]; then
  echo "FAIL: esbuild.js still exists"
  exit 1
fi

if [ -f "vsc-extension-quickstart.md" ]; then
  echo "FAIL: quickstart MD still exists"
  exit 1
fi

echo "PASS: Repository structure clean"
