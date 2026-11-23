---
name: technical-debt
description: Use when capturing deferred work, logging technical shortcuts or debt, or paying down items listed in TECHDEBT.md.
---

# Technical Debt & Deferred Work

Actively manage technical debt and deferred tasks as you build. This skill ensures that technical compromises, temporary mocks, and postponed features are captured immediately in `TECHDEBT.md` without interrupting your active workflow, and surfaced proactively when relevant code is touched later.

## 1. When to Trigger

### Explicit User Cues
Trigger immediately whenever the developer indicates that something should be postponed:
- *"we'll implement this later"* / *"let's do this later"*
- *"postpone this"* / *"defer for now"*
- *"skip for now"* / *"out of scope for now"*
- *"we'll fix this after"* / *"handle this in next phase"*
- *"note this as technical debt"*

### Implicit Agent Discoveries
Trigger whenever you make or observe a technical compromise:
- **Temporary Mocks/Stubs**: Creating a mock service or dummy response to unblock happy path development.
- **Skipped Test Coverage**: Skipping integration or edge-case tests to maintain development velocity.
- **Code Smells**: Spotting complex duplication, tight coupling, or fragile logic in touched files.
- **Security / Config Shortcuts**: Hardcoding test credentials, tokens, or temporary configurations.

---

## 2. Immediate Inline Capture

When triggered, execute the capture sequence immediately:

### Step 1: Initialize `TECHDEBT.md` (if not present)
If `TECHDEBT.md` does not exist in the project root, create it using the canonical template from [DEBT-FORMAT.md](./DEBT-FORMAT.md):
```markdown
# Technical Debt & Deferred Work

> Maintained by the `technical-debt` agent skill. Review and pay down items during refactors.

## Pending Debt

## Resolved Debt
```

### Step 2: Determine Next Sequential ID
Search `TECHDEBT.md` for existing `[DEBT-XXX]` IDs. Find the highest integer and increment by 1. For example, if `[DEBT-002]` exists, the next ID is `[DEBT-003]`. If none exist, start with `[DEBT-001]`.

### Step 3: Append the Entry
Append the item under `## Pending Debt` following the exact schema:
```markdown
- [ ] **[DEBT-003]** <Action-oriented summary>
  - **Location**: [`path/to/file.ext#L10-L20`](path/to/file.ext#L10-L20)
  - **Category**: `Prudent Shortcut` | `Missing Tests` | `Code Smell` | `Architecture` | `Deferred Feature`
  - **Severity**: `Low` | `Medium` | `High` | `Critical`
  - **Why Deferred**: <1-2 sentences explaining why this was deferred>
  - **Logged**: YYYY-MM-DD by <Agent or Developer>
```
*Note: If the item is architectural or global, use `Location: N/A (Global / Architectural)`.*

### Step 4: One-Line Acknowledgment (Zero Interruption)
Acknowledge the log in **at most one sentence** and resume your active task immediately:
> *"Noted in `TECHDEBT.md` ([DEBT-003]) — continuing with the current task."*

**Strict Rule**: Never interrupt the developer with multi-question interviews or confirmation requests. Capture and continue.

---

## 3. Active Debt Inquiries

Technical debt is only useful if it gets paid down. Agents must act as proactive stewards:

1. **Before Touching a File**: When you are about to edit or refactor a file, search `TECHDEBT.md` for entries referencing that file path.
2. **Contextual Offer**: If pending debt is found, surface it briefly:
   > *"Note: `src/auth/login.ts` has open technical debt ([DEBT-001]: Refactor auth error handling). Would you like to resolve it while we edit this file?"*
3. **Respect Developer Priority**:
   - If the developer says **yes**: incorporate the debt resolution into the current task.
   - If the developer says **no** or ignores it: proceed with the original request without nagging.

---

## 4. Debt Paydown Workflow

When paying down an item from `TECHDEBT.md`:

1. **Implement & Test**: Write the fix or feature following `superpowers:test-driven-development`.
2. **Move to Resolved**: Move the item from `## Pending Debt` to `## Resolved Debt`.
3. **Mark Complete**: Change `- [ ]` to `- [x]` and append resolution context:
   ```markdown
   - [x] **[DEBT-001]** Refactor auth error handling (Resolved on 2026-11-23 in commit `c8d1e2f`)
   ```

---

## 5. Anti-Patterns & Red Flags

| Anti-Pattern | Why It Fails | What to Do Instead |
| :--- | :--- | :--- |
| **Over-interrogating** | Asking 5 questions when the user said "do this later" ruins focus. | Infer reasonable defaults from context, log, and confirm in 1 sentence. |
| **Silent omission** | Thinking "I'll remember this later" without writing it down. | Memory does not survive context resets. Write to `TECHDEBT.md` immediately. |
| **Deleting resolved items** | Erasing history destroys the audit trail of what was fixed. | Move to `## Resolved Debt` with date and commit hash. |
| **Vague summaries** | Writing "fix stuff" gives zero context to future agents. | Write specific summaries: "Replace in-memory mock with Stripe API client". |
