# Technical Debt & Deferred Work Agent Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform the repository into the canonical `technical-debt` universal plugin and skill for AI agents to capture, track, and pay down debt in `TECHDEBT.md`.

**Architecture:** Modeled directly after `grill-me` and `superpowers`. The repository contains a cross-runtime `plugin.json` manifest, system rules in `rules/AGENTS.md`, the core skill in `skills/technical-debt/SKILL.md`, the schema specification in `skills/technical-debt/DEBT-FORMAT.md`, CLI validation scripts in `scripts/`, and automated compliance tests in `tests/`.

**Tech Stack:** Markdown, Bash (POSIX compliant), JSON, Node.js (for testing and validation).

**Spec:** `docs/superpowers/specs/2026-11-23-technical-debt-skill-design.md`

## Global Constraints

- Must comply with the [Agent Skills specification](https://agentskills.io/specification) (YAML frontmatter with `name` and third-person `description` under 1024 characters).
- Storage must be 100% git-native pure Markdown in `TECHDEBT.md` in the project root with zero external SaaS dependencies.
- Agent response when capturing debt must be a single line of acknowledgment without interrupting the developer's focus.
- Helper scripts must be self-contained POSIX-compliant Bash with no external runtime requirements beyond standard Unix tools (`grep`, `sed`, `awk`).

## Review Focus

1. **Empty / Non-Existent `TECHDEBT.md`**: When `TECHDEBT.md` does not exist yet, the skill and helper scripts must initialize it cleanly without errors.
2. **Sequential ID Collision**: Sequential ID generation (`[DEBT-001]`, `[DEBT-002]`) must calculate the next ID from the maximum existing ID even if items are deleted or resolved.
3. **Missing File Anchor**: Items deferred at an architectural or feature level without a specific file line must support `Location: N/A (Global / Architectural)`.
4. **Duplicate Marker Protection**: Scanning or logging must not create duplicate debt entries for the same source code comment or trigger.
5. **Multi-Harness Skill Discovery**: The plugin manifest and directory layout must load cleanly across Antigravity, Claude Code, Gemini CLI, Cursor, and Codex.

---

### Task 1: Repository Cleanup & Foundation Setup

**Files:**
- Modify: `package.json`
- Modify: `.gitignore`
- Remove: Legacy VS Code extension files (`src/`, `esbuild.js`, `eslint.config.mjs`, `vsc-extension-quickstart.md`, `.cursorrules`, `DEVELOPMENT_PLAN.md`, `ROADMAP_AND_BRANCH_PLAN.md`)
- Test: `tests/test-repo-structure.sh`

**Interfaces:**
- Consumes: Existing repository structure
- Produces: Clean plugin repository root with test runner and lint commands

- [ ] **Step 1: Write the failing structure test in `tests/test-repo-structure.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail

# Verify that legacy VS Code artifacts are removed
test ! -d "src" || { echo "FAIL: src/ still exists"; exit 1; }
test ! -f "esbuild.js" || { echo "FAIL: esbuild.js still exists"; exit 1; }
test ! -f "vsc-extension-quickstart.md" || { echo "FAIL: quickstart MD still exists"; exit 1; }

# Verify that npm test works
npm test
echo "PASS: Repository structure clean"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-repo-structure.sh`  
Expected: FAIL with "src/ still exists"

- [ ] **Step 3: Remove legacy extension files and update `package.json` and `.gitignore`**

Remove legacy extension files:
- `rm -rf src dist out esbuild.js eslint.config.mjs vsc-extension-quickstart.md .cursorrules .vscode-test.mjs tsconfig.json DEVELOPMENT_PLAN.md ROADMAP_AND_BRANCH_PLAN.md`
Update `package.json`:
- `name`: `"technical-debt"`
- `description`: `"Zero-friction agent protocol to capture, track, and pay down technical debt and deferred work directly in TECHDEBT.md"`
- `scripts`: `{ "test": "bash tests/run-all-tests.sh", "lint": "bash scripts/lint.sh" }`
Update `.gitignore` to ignore temporary test files, OS artifacts, and `.fixflow/`.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-repo-structure.sh`  
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add package.json .gitignore tests/test-repo-structure.sh
git commit -m "chore: clean up legacy vscode extension artifacts and initialize plugin structure"
```

---

### Task 2: Plugin Manifest & Core System Rules

**Files:**
- Create: `plugin.json`
- Create: `rules/AGENTS.md`
- Test: `tests/test-manifest-and-rules.sh`

**Interfaces:**
- Consumes: Spec Sections 4.1 & 4.2
- Produces: `plugin.json` and `rules/AGENTS.md` for runtime auto-discovery

- [ ] **Step 1: Write the failing validation test in `tests/test-manifest-and-rules.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail

test -f "plugin.json" || { echo "FAIL: plugin.json missing"; exit 1; }
test -f "rules/AGENTS.md" || { echo "FAIL: rules/AGENTS.md missing"; exit 1; }

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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-manifest-and-rules.sh`  
Expected: FAIL with "plugin.json missing"

- [ ] **Step 3: Implement `plugin.json` and `rules/AGENTS.md`**

Create `plugin.json`:
- Standard plugin manifest matching `grill-me` format (`name`, `displayName`, `version`, `description`, `author`, `license`, `repository`).

Create `rules/AGENTS.md`:
- Active detection rules for any agent entering a repository.
- Explicit trigger phrases: *"later"*, *"postpone"*, *"skip for now"*, *"we'll fix this after"*, *"out of scope"*, *"technical debt"*.
- Implicit agent discovery triggers (stubs, temporary mocks, missing validations).
- Active inquiry protocol: When an agent edits a file with existing debt listed in `TECHDEBT.md`, it surfaces the debt item and asks if the developer wants to pay it down during the task.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-manifest-and-rules.sh`  
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add plugin.json rules/AGENTS.md tests/test-manifest-and-rules.sh
git commit -m "feat: add plugin.json manifest and rules/AGENTS.md system instructions"
```

---

### Task 3: Canonical Format Specification (`DEBT-FORMAT.md`)

**Files:**
- Create: `skills/technical-debt/DEBT-FORMAT.md`
- Test: `tests/test-debt-format-spec.sh`

**Interfaces:**
- Consumes: Spec Section 4.4
- Produces: Canonical specification for `TECHDEBT.md` structure

- [ ] **Step 1: Write the failing spec test in `tests/test-debt-format-spec.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail

FILE="skills/technical-debt/DEBT-FORMAT.md"
test -f "$FILE" || { echo "FAIL: $FILE missing"; exit 1; }

grep -q "## Pending Debt" "$FILE" || { echo "FAIL: Missing Pending Debt section"; exit 1; }
grep -q "## Resolved Debt" "$FILE" || { echo "FAIL: Missing Resolved Debt section"; exit 1; }
grep -q "Location" "$FILE" || { echo "FAIL: Missing Location specification"; exit 1; }
grep -q "Category" "$FILE" || { echo "FAIL: Missing Category specification"; exit 1; }
grep -q "Severity" "$FILE" || { echo "FAIL: Missing Severity specification"; exit 1; }

echo "PASS: DEBT-FORMAT.md valid"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-debt-format-spec.sh`  
Expected: FAIL with "skills/technical-debt/DEBT-FORMAT.md missing"

- [ ] **Step 3: Implement `skills/technical-debt/DEBT-FORMAT.md`**

Author `DEBT-FORMAT.md`:
- Clean schema definition for `TECHDEBT.md`.
- Sections: Header, `## Pending Debt`, `## Resolved Debt`.
- Item format:
  ```markdown
  - [ ] **[DEBT-XXX]** <Summary>
    - **Location**: [`file/path.ext#L10-L20`](file/path.ext#L10-L20) or `N/A (Global / Architectural)`
    - **Category**: `Prudent Shortcut` | `Missing Tests` | `Code Smell` | `Architecture` | `Deferred Feature`
    - **Severity**: `Low` | `Medium` | `High` | `Critical`
    - **Why Deferred**: <Context and rationale>
    - **Logged**: YYYY-MM-DD by <Agent or Developer>
  ```
- Resolution format:
  ```markdown
  - [x] **[DEBT-XXX]** <Summary> (Resolved on YYYY-MM-DD in `<commit-hash-or-PR>`)
  ```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-debt-format-spec.sh`  
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add skills/technical-debt/DEBT-FORMAT.md tests/test-debt-format-spec.sh
git commit -m "docs: add canonical DEBT-FORMAT.md specification"
```

---

### Task 4: Core Agent Skill (`SKILL.md`)

**Files:**
- Create: `skills/technical-debt/SKILL.md`
- Test: `tests/test-skill-definition.sh`

**Interfaces:**
- Consumes: Spec Section 4.3 and `DEBT-FORMAT.md`
- Produces: The executable agent skill instructions

- [ ] **Step 1: Write the failing skill validation test in `tests/test-skill-definition.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail

SKILL="skills/technical-debt/SKILL.md"
test -f "$SKILL" || { echo "FAIL: $SKILL missing"; exit 1; }

# Verify YAML frontmatter
head -n 5 "$SKILL" | grep -q "^name: technical-debt" || { echo "FAIL: Missing or invalid name"; exit 1; }
head -n 5 "$SKILL" | grep -q "^description: Use when" || { echo "FAIL: Missing or invalid description"; exit 1; }

# Verify core lifecycle sections
grep -q "## 1. When to Trigger" "$SKILL" || { echo "FAIL: Missing Trigger section"; exit 1; }
grep -q "## 2. Immediate Inline Capture" "$SKILL" || { echo "FAIL: Missing Capture section"; exit 1; }
grep -q "## 3. Active Debt Inquiries" "$SKILL" || { echo "FAIL: Missing Inquiries section"; exit 1; }
grep -q "## 4. Debt Paydown Workflow" "$SKILL" || { echo "FAIL: Missing Paydown section"; exit 1; }

echo "PASS: SKILL.md valid"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-definition.sh`  
Expected: FAIL with "skills/technical-debt/SKILL.md missing"

- [ ] **Step 3: Implement `skills/technical-debt/SKILL.md`**

Author `SKILL.md`:
- YAML Frontmatter conforming to Agent Skills spec (`name: technical-debt`, `description: Use when capturing deferred work, logging technical shortcuts or debt, or paying down items listed in TECHDEBT.md.`).
- Clear step-by-step agent instructions:
  - How to initialize `TECHDEBT.md` if not present.
  - How to determine the next sequential ID (`[DEBT-001]`, `[DEBT-002]`, etc.).
  - How to append items inline and acknowledge in 1 line without interrupting the user.
  - How to cross-reference `TECHDEBT.md` when opening/editing files.
  - How to transition items from Pending to Resolved when paying down debt.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-skill-definition.sh`  
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add skills/technical-debt/SKILL.md tests/test-skill-definition.sh
git commit -m "feat: implement technical-debt agent skill definition"
```

---

### Task 5: Helper Scripts (`scripts/check-debt.sh` & `scripts/resolve-debt.sh`)

**Files:**
- Create: `scripts/check-debt.sh`
- Create: `scripts/resolve-debt.sh`
- Create: `scripts/lint.sh`
- Test: `tests/test-helper-scripts.sh`

**Interfaces:**
- Consumes: `TECHDEBT.md` schema from Task 3
- Produces: Executable CLI utilities for developers, agents, and CI pipelines

- [ ] **Step 1: Write the failing helper script test in `tests/test-helper-scripts.sh`**

```bash
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

# Test resolve-debt.sh resolves DEBT-001
(cd "$TMP_DIR" && bash /root/development/fixflow/scripts/resolve-debt.sh "DEBT-001" "commit-abc123")
grep -q "\- \[x\] \*\*\[DEBT-001\]\*\*" "$TMP_DIR/TECHDEBT.md" || { echo "FAIL: resolve-debt failed to mark DEBT-001 resolved"; exit 1; }

echo "PASS: Helper scripts working properly"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-helper-scripts.sh`  
Expected: FAIL with "scripts/check-debt.sh: No such file or directory"

- [ ] **Step 3: Implement `scripts/check-debt.sh`, `scripts/resolve-debt.sh`, and `scripts/lint.sh`**

Implement `scripts/check-debt.sh`:
- Inspects `TECHDEBT.md`.
- Counts pending (`- [ ]`) and resolved (`- [x]`) items.
- Summarizes count by severity (Critical, High, Medium, Low).
- Returns exit code 1 if `--strict` or Critical items are found, 0 otherwise.

Implement `scripts/resolve-debt.sh`:
- Takes `<DEBT-ID>` and optional `<RESOLUTION-NOTE-OR-HASH>`.
- Moves the item from `## Pending Debt` to `## Resolved Debt` with `- [x]` and timestamp.

Implement `scripts/lint.sh`:
- Runs syntax checks on shell scripts (`bash -n`) and JSON validation on `plugin.json` and `package.json`.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-helper-scripts.sh`  
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add scripts/check-debt.sh scripts/resolve-debt.sh scripts/lint.sh tests/test-helper-scripts.sh
git commit -m "feat: add check-debt, resolve-debt, and lint helper scripts"
```

---

### Task 6: Open-Source Documentation & Master Test Runner

**Files:**
- Create: `README.md`
- Create: `LICENSE`
- Create: `tests/run-all-tests.sh`
- Test: `npm test`

**Interfaces:**
- Consumes: All deliverables from Tasks 1-5
- Produces: Public documentation and complete verification harness

- [ ] **Step 1: Write the failing master test runner in `tests/run-all-tests.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "=== Running Technical Debt Skill Test Suite ==="

bash tests/test-repo-structure.sh
bash tests/test-manifest-and-rules.sh
bash tests/test-debt-format-spec.sh
bash tests/test-skill-definition.sh
bash tests/test-helper-scripts.sh

# Verify README and LICENSE exist
test -f "README.md" || { echo "FAIL: README.md missing"; exit 1; }
test -f "LICENSE" || { echo "FAIL: LICENSE missing"; exit 1; }

echo "=== ALL TESTS PASSED ==="
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/run-all-tests.sh`  
Expected: FAIL with "README.md missing" (or test-repo-structure missing)

- [ ] **Step 3: Implement `README.md` and verify `LICENSE`**

Author `README.md`:
- Badges (License, AgentSkills compatible, Antigravity, Superpowers).
- Overview: What is `technical-debt` and why it replaces forgotten `TODO` comments.
- Installation: How to install in Antigravity (`agy`), Claude Code, Gemini CLI, Cursor, and Codex.
- How It Works: Inline capture examples, `TECHDEBT.md` schema, proactive paydown inquiries.
- CLI Helpers: Documentation for `scripts/check-debt.sh` and `scripts/resolve-debt.sh`.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/run-all-tests.sh`  
Expected: PASS with "=== ALL TESTS PASSED ==="

- [ ] **Step 5: Commit**

```bash
git add README.md LICENSE tests/run-all-tests.sh
git commit -m "docs: add open-source README and master test runner"
```

---

## Plan Self-Review Checklist

1. **Spec Coverage**:
   - `plugin.json` -> Task 2
   - `rules/AGENTS.md` -> Task 2
   - `skills/technical-debt/DEBT-FORMAT.md` -> Task 3
   - `skills/technical-debt/SKILL.md` -> Task 4
   - `scripts/check-debt.sh` & `scripts/resolve-debt.sh` -> Task 5
   - Open-source `README.md` -> Task 6
2. **Review Focus Coverage**:
   - Empty `TECHDEBT.md` handling -> Covered in Task 4 & Task 5 tests.
   - Sequential ID calculation -> Specified in Task 4.
   - Non-file anchors (`N/A`) -> Specified in Task 3.
   - Multi-harness discovery -> Validated in Task 2 & Task 6.
3. **Step Scan**: Every step has unambiguous inputs, exact test assertions, and verify commands.
