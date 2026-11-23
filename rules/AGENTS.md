# Technical Debt & Deferred Work Agent Rules

The `technical-debt` protocol is an active discipline across all projects and agent sessions. Agents must proactively capture, track, and pay down technical debt and deferred tasks without breaking developer flow.

## 1. When to Trigger

### Explicit Trigger Phrases
Activate immediately whenever the developer uses phrases such as:
- *"we'll implement this later"* / *"do this later"*
- *"postpone this"* / *"defer for now"*
- *"skip for now"* / *"out of scope for now"*
- *"we'll fix this after"* / *"handle this in next sprint/phase"*
- *"note this as technical debt"*

### Implicit Agent Discoveries
Activate whenever the agent makes or spots a deliberate compromise:
- Writing temporary mocks, placeholders, or stubs to validate happy paths.
- Skipping edge-case validation or error handling to keep velocity high.
- Hardcoding temporary configuration, test values, or credentials.
- Identifying code smells, dead code, or missing test coverage in touched files.

---

## 2. Zero-Friction Inline Capture Protocol

When an item is identified, the agent must execute the capture protocol immediately:

1. **Inspect / Initialize `TECHDEBT.md`**:
   - If `TECHDEBT.md` does not exist in the project root, create it using the canonical template from `skills/technical-debt/DEBT-FORMAT.md`.
2. **Calculate Next Sequential ID**:
   - Scan `TECHDEBT.md` for existing `[DEBT-XXX]` IDs and increment the highest number (e.g., `[DEBT-001]`, `[DEBT-002]`).
3. **Append the Item Inline**:
   - Add the item under `## Pending Debt` following the exact format:
     ```markdown
     - [ ] **[DEBT-001]** <Clear action-oriented summary>
       - **Location**: [`path/to/file.ext#L10`](path/to/file.ext#L10) (or `N/A (Global / Architectural)`)
       - **Category**: `Prudent Shortcut` | `Missing Tests` | `Code Smell` | `Architecture` | `Deferred Feature`
       - **Severity**: `Low` | `Medium` | `High` | `Critical`
       - **Why Deferred**: <1-2 sentences on why it was postponed or created>
       - **Logged**: YYYY-MM-DD by <Agent or Developer>
     ```
4. **Single-Line Acknowledgment (Zero Interruption)**:
   - Acknowledge capture in **at most one sentence** and resume the active task immediately:
     > *"Noted in `TECHDEBT.md` ([DEBT-001]) — continuing with the current implementation."*
   - **Strict Rule**: DO NOT interrupt the user with questionnaires, confirmation prompts, or interactive forms. Log and continue.

---

## 3. Active Debt Inquiries & Proactive Surfacing

1. **On File Access**: When opening or modifying a file referenced in `TECHDEBT.md`, the agent should check for existing debt.
2. **Contextual Offer**: If relevant open debt exists in the file, briefly mention it:
   > *"Note: This file has pending technical debt ([DEBT-001]: <summary>). Would you like to pay it down while we are editing this file?"*
3. **Respect Rejection**: If the user declines, proceed with the original task without persisting.

---

## 4. Debt Paydown Protocol

When resolving debt:
1. Fix the underlying issue and verify with tests.
2. Move the item from `## Pending Debt` to `## Resolved Debt` in `TECHDEBT.md`:
   ```markdown
   - [x] **[DEBT-001]** <Summary> (Resolved on YYYY-MM-DD in commit `<hash>`)
   ```
