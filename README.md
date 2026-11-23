# Technical Debt & Deferred Work (`technical-debt`)

A universal agent skill and plugin designed to capture, track, and pay down technical debt and deferred work directly within codebases.

This skill equips AI coding assistants to manage `TECHDEBT.md` with zero friction to the developer.

---

## Why Technical Debt Skill?

During rapid development and prototyping, developers and AI agents regularly postpone non-critical items:
- Secondary edge cases and input sanitization
- Integration and regression test coverage
- Temporary mocks, stubs, and shortcuts
- Refactoring opportunities and code smells

Instead of scattering untracked `// TODO` comments or forcing context switches into external issue trackers, the `technical-debt` skill records debt immediately into a root-level `TECHDEBT.md` file and proactively surfaces it when the affected code is edited later.

---

## Key Features

1. **Zero-Friction In-Session Capture**: Whenever the developer says *"we'll do this later"* or an agent writes a temporary shortcut, the agent appends it to `TECHDEBT.md` and acknowledges it in one line without interrupting the developer's train of thought.
2. **Git-Native Storage**: Stored in standard, human-readable Markdown (`TECHDEBT.md`) in the repository root. No SaaS, databases, or third-party accounts required.
3. **Structured Schema**: Follows the canonical format defined in `skills/technical-debt/DEBT-FORMAT.md`, tracking category, severity, file and line anchors, and deferral rationale.
4. **Active Debt Inquiries**: Before modifying a file listed in `TECHDEBT.md`, the agent surfaces the pending debt and offers to resolve it.
5. **Resolution Audit Trail**: Moving resolved items from `## Pending Debt` to `## Resolved Debt` preserves a permanent log of paid-down debt with dates and commit hashes.

---

## Directory Structure

```
technical-debt/
├── plugin.json                 # Cross-runtime plugin manifest
├── rules/
│   └── AGENTS.md               # Global instructions for automatic detection & challenge
├── skills/
│   └── technical-debt/
│       ├── SKILL.md            # Agent skill instructions, triggers, and workflow
│       └── DEBT-FORMAT.md      # Canonical specification for TECHDEBT.md
├── scripts/
│   ├── check-debt.sh           # CLI summary report for pending/critical debt
│   ├── resolve-debt.sh         # CLI utility to resolve debt items
│   └── lint.sh                 # Script and JSON validation
├── tests/                      # Automated compliance and structure test suite
│   └── run-all-tests.sh
└── README.md
```

---

## Installation Across Runtimes

### Antigravity (`agy`)
Clone or link into your plugins directory:
```bash
git clone https://github.com/Al-Barbari/technical-debt.git ~/.gemini/config/plugins/technical-debt
```

### Claude Code
Install or link into your personal skills directory:
```bash
git clone https://github.com/Al-Barbari/technical-debt.git ~/.claude/skills/technical-debt
```

### Universal Agent Runtimes (Gemini CLI, Codex, Cursor)
Reference the rules in your workspace or global agent instructions:
```markdown
@~/.agents/plugins/technical-debt/rules/AGENTS.md
```

---

## CLI Utilities

### Check Debt Summary
Inspect open debt, severity counts, and pending items:
```bash
bash scripts/check-debt.sh [PATH_TO_TECHDEBT.md] [--strict]
```

### Resolve a Debt Item
Move a pending item to resolved with an audit note:
```bash
bash scripts/resolve-debt.sh DEBT-001 "commit-abc123" [PATH_TO_TECHDEBT.md]
```

---

## License

MIT License. See [LICENSE](LICENSE) for details.
