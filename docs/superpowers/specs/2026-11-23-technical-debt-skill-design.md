# Design Spec: Technical Debt & Deferred Work Agent Skill (`technical-debt`)

> **Spec Path**: `docs/superpowers/specs/2026-11-23-technical-debt-skill-design.md`  
> **Status**: Proposed / Under Builder Review  
> **Target Release**: Universal Open-Source Plugin & Skill (AgentSkills / Superpowers ecosystem)  
> **Author**: Antigravity Pair-Programming Session  
> **Date**: 2026-11-23

---

## 1. Intent & Context

During AI-assisted software development, developers and autonomous agents frequently make deliberate compromises to maintain momentum—such as deferring secondary features, writing temporary mocks, postponing edge-case validation, or accepting technical shortcuts to validate happy paths.

In practice, these items either get scattered into forgotten source code `// TODO` comments or require heavyweight context-switching into issue trackers (Jira, Linear, GitHub Issues), which disrupts flow.

The **`technical-debt`** skill transforms technical debt and deferred work into a **first-class, active agent discipline**. Modeled after proven agent plugins like **`grill-me`** and **`superpowers`**, it provides a universal, zero-friction, git-native mechanism for developers and agents to capture, track, challenge, and pay down debt in any codebase.

---

## 2. Goals, Non-Goals & Anti-Goals

### Goals
- **Universal Cross-Platform Standard**: Compatible with all major agent runtimes (Antigravity, Claude Code, Codex, Copilot CLI, Gemini CLI) following the open [Agent Skills specification](https://agentskills.io/specification).
- **Maximum Simplicity & Clarity**: Single-file standard (`TECHDEBT.md` in project root) with a human-readable checklist format (`- [ ]`).
- **Immediate Inline Capture**: Agents log items in real-time the moment a user says *"we'll implement this later"* or when the agent applies a temporary shortcut, responding with a concise 1-line confirmation.
- **Active Agent Inquiries & Paydown**: When an agent works on a file referenced in `TECHDEBT.md`, it proactively checks if the user wants to pay down related debt during the task.
- **Zero External Dependencies**: 100% git-tracked Markdown; requires no external SaaS, databases, or API keys.

### Non-Goals
- Not an issue tracker replacement for project sprints or agile ticket management.
- Not a proprietary IDE plugin (pivoted away from VS Code GUI extension).
- Not a complex multi-database synchronization tool.

### Anti-Goals
- **Zero Interruption Overhead**: The agent MUST NOT interrogate the user with extensive forms or confirmation dialogues when debt is logged. It logs and continues.
- **No Rigid Over-Categorization**: Avoiding 15-field forms; keeping capture down to Title, File/Line Anchor, Rationale/Trigger, and Severity.

---

## 3. Architecture & Repository Structure

The repository is restructured to match the canonical plugin architecture seen in `grill-me` and `superpowers`:

```
technical-debt/
├── plugin.json                     # Cross-runtime plugin manifest
├── rules/
│   └── AGENTS.md                   # Global system instructions for agents
├── skills/
│   └── technical-debt/
│       ├── SKILL.md                # Core agent skill instructions and triggers
│       └── DEBT-FORMAT.md          # Canonical format specification for TECHDEBT.md
├── scripts/                        # Optional developer / agent helper scripts
│   ├── check-debt.sh               # Quick CLI script to report pending debt count & severity
│   └── resolve-debt.sh             # Helper to mark debt items resolved
├── tests/                          # Pressure test scenarios verifying agent compliance
│   └── test-debt-capture.sh
├── docs/                           # Documentation, specs, and design history
│   └── superpowers/
├── README.md                       # Public open-source guide and installation instructions
├── LICENSE                         # MIT License
└── package.json                    # Project metadata & npm scripts
```

---

## 4. Detailed Component Design

### 4.1 Manifest (`plugin.json`)
Standard cross-runtime manifest:
- `name`: `"technical-debt"`
- `displayName`: `"Technical Debt & Deferred Work"`
- `version`: `"1.0.0"`
- `description`: `"Zero-friction agent protocol to capture, track, and pay down technical debt and deferred work directly in TECHDEBT.md"`
- `author`, `license`: `"MIT"`, `repository`: `"https://github.com/Al-Barbari/technical-debt"`

### 4.2 System Rules (`rules/AGENTS.md`)
Defines the automatic triggering behavior for any agent in a repository where this plugin/rule is installed:
1. **Trigger Phrases**: Activates when user says *"later"*, *"postpone"*, *"skip for now"*, *"we'll fix this after"*, *"out of scope"*, or *"technical debt"*.
2. **Proactive Agent Discovery**: Activates when the agent creates temporary stubs, skips test cases, uses hardcoded test credentials, or notices code smells during refactoring.
3. **Active Challenge**: When modifying a file listed in `TECHDEBT.md`, the agent notes: *"Note: This file has pending technical debt ([DEBT-001]). Would you like to resolve it while we edit this file?"*

### 4.3 Skill Specification (`skills/technical-debt/SKILL.md`)
- **Frontmatter**:
  - `name`: `technical-debt`
  - `description`: `Use when capturing deferred work, logging technical shortcuts or debt, or paying down items listed in TECHDEBT.md.`
- **Workflow**:
  1. *Detect / Capture*: Immediate append to `TECHDEBT.md`.
  2. *Acknowledge*: 1-line acknowledgment to user; resume active task immediately.
  3. *Review*: Surface relevant debt when entering a file or planning a feature.
  4. *Resolve*: Check off (`- [x]`) and record resolution summary when debt is paid down.

### 4.4 Format Specification (`skills/technical-debt/DEBT-FORMAT.md`)
Specifies the exact schema and layout of `TECHDEBT.md`:
```markdown
# Technical Debt & Deferred Work

> Auto-maintained by the `technical-debt` agent skill. Run debt paydown during refactors.

## Pending Debt

- [ ] **[DEBT-001]** <Title / Summary>
  - **Location**: [`path/to/file.ts#L45`](path/to/file.ts#L45)
  - **Category**: `Prudent Shortcut` | `Missing Tests` | `Code Smell` | `Architecture` | `Deferred Feature`
  - **Severity**: `Low` | `Medium` | `High` | `Critical`
  - **Why Deferred**: <1-2 sentences on why it was postponed or created>
  - **Logged**: 2026-11-23 by Developer / Agent

## Resolved Debt

- [x] **[DEBT-000]** <Title> (Resolved on YYYY-MM-DD in commit `<hash>`)
```

---

## 5. What is Left to the Builder

1. **Repository Cleanup**: Cleanly transition the existing `/root/development/fixflow` workspace by archiving/removing the legacy VS Code extension files and populating the new plugin structure.
2. **ID Numbering Scheme**: Sequential IDs (`[DEBT-001]`, `[DEBT-002]`) generated by inspecting the highest existing number in `TECHDEBT.md`.
3. **Helper Scripts**: Simple zero-dependency Bash/Node script in `scripts/` to validate `TECHDEBT.md` syntax or quickly tally open debt.
4. **Automated Skill Tests**: TDD test cases following `writing-skills` to verify agent compliance on pressure scenarios.

---

## 6. Migration Plan for the Repository

1. Remove legacy VS Code extension artifacts (`dist/`, `out/`, old `vsc-extension-quickstart.md`, VS Code manifest contributions).
2. Establish the plugin root: `plugin.json`, `rules/AGENTS.md`, `skills/technical-debt/SKILL.md`, `skills/technical-debt/DEBT-FORMAT.md`.
3. Author comprehensive open-source `README.md` showcasing installation in Antigravity, Claude Code, Gemini CLI, Cursor, and Codex.
4. Author helper scripts (`scripts/check-debt.sh`).
5. Run lint and test suites to verify.
