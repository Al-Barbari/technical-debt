# Canonical Format Specification: `TECHDEBT.md`

This document defines the official schema and formatting rules for `TECHDEBT.md` files managed by the `technical-debt` agent skill.

---

## 1. Overview

`TECHDEBT.md` is a single, git-tracked Markdown file residing in the root of a repository. It provides human developers and autonomous AI agents with an unambiguous, unified record of:
1. **Deferred Work**: Features, edge cases, and requirements intentionally postponed during active development.
2. **Technical Debt**: Deliberate shortcuts, missing tests, code smells, and architectural compromises.
3. **Resolution History**: An audit trail of resolved debt items.

---

## 2. File Template

```markdown
# Technical Debt & Deferred Work

> Maintained by the `technical-debt` agent skill. Review and pay down items during refactors.

## Pending Debt

- [ ] **[DEBT-001]** Refactor authentication error handling
  - **Location**: [`src/auth/login.ts#L45-L60`](src/auth/login.ts#L45-L60)
  - **Category**: `Prudent Shortcut`
  - **Severity**: `High`
  - **Why Deferred**: Postponed during initial MVP login flow to validate happy path first.
  - **Logged**: 2026-11-23 by Developer

## Resolved Debt

- [x] **[DEBT-000]** Initial mock database configuration (Resolved on 2026-11-23 in commit `a1b2c3d`)
```

---

## 3. Field Specifications

### 3.1 Item Header
```markdown
- [ ] **[DEBT-XXX]** <Action-Oriented Summary>
```
- **ID Format**: `[DEBT-XXX]` where `XXX` is a sequential 3-digit zero-padded integer starting from `001`.
- **Summary**: Concise title describing what needs to be fixed or built.

### 3.2 Metadata Fields

#### **Location**
- Path and line number range relative to repository root: [`src/api/routes.ts#L12-L30`](src/api/routes.ts#L12-L30)
- For repository-wide or architectural debt with no single file: `N/A (Global / Architectural)`

#### **Category**
Must be one of the canonical categories:
- `Prudent Shortcut`: Deliberate interim compromise taken to ship or test quickly.
- `Missing Tests`: Skipped unit, integration, or regression test cases.
- `Code Smell`: Duplication, high cyclomatic complexity, tight coupling, or poor naming.
- `Architecture`: Subsystem boundary leak, scalability constraint, or missing abstraction.
- `Deferred Feature`: Secondary capability postponed for later phases.

#### **Severity**
- `Low`: Cosmetic, minor documentation omission, non-blocking cleanup.
- `Medium`: Localized technical debt that does not affect system stability.
- `High`: Fragile logic, missing test coverage on critical path, or performance risk.
- `Critical`: Security vulnerability, potential data loss risk, or breaking blocker.

#### **Why Deferred**
- 1 to 2 clear sentences explaining the rationale for deferral, contextual assumptions, or dependencies required before remediation.

#### **Logged**
- `YYYY-MM-DD by <Developer | Agent>`

---

## 4. Resolution Protocol

When a debt item is resolved:
1. Move the entry from `## Pending Debt` to `## Resolved Debt`.
2. Convert checkbox from `- [ ]` to `- [x]`.
3. Collapse description into a single resolution line:
   ```markdown
   - [x] **[DEBT-001]** Refactor authentication error handling (Resolved on YYYY-MM-DD in commit `<commit-hash-or-PR>`)
   ```
