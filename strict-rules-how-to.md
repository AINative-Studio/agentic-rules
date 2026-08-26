# How to Make Agent Rules Stick

Put critical rules at the TOP of your project context file. This file is read at session start, re-read after context compression, and is the first thing the agent sees about your project.

| IDE | Context File | Rules Directory |
|-----|-------------|-----------------|
| Cody CLI | `CODY.md` | `.cody/rules/` |
| Claude Code | `CLAUDE.md` | `.claude/rules/` |
| Cursor | `.cursorrules` | (inline) |
| Windsurf | `.windsurfrules` | (inline) |
| Gemini CLI | `GEMINI.md` | `.gemini/` |

## Strategy

1. Add a "CRITICAL RULES - READ FIRST" section at the very top of your context file
2. Put the actual content there — not just a reference to another file
3. Use tables, bold text, and "Forbidden" lists for scannability

## Pattern for strict rules

```markdown
## CRITICAL RULES - READ FIRST

**Before doing X, you MUST check Y**

| Thing | Value |
|-------|-------|
| ... | ... |

**Forbidden:** list of things never to do
```

## Why this works

- Rules in a subdirectory (`.cody/rules/`, `.claude/rules/`) require the agent to remember to check them
- Rules in the top-level context file are unavoidable — the agent sees them every session
- Tables and bold text make rules scannable even under context pressure
- "Forbidden" lists make violations immediately obvious
- Repeating critical rules in both locations provides defense in depth
