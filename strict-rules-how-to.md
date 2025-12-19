# How to make Claude remember rules across sessions

Put critical rules at the TOP of CLAUDE.md - this file is:
- Read at session start
- Re-read after context compression
- The first thing Claude sees about your project

All rules are put in .claude/rules/ but you also want to make sure any critical rules are copied into the top of the CLAUDE.md file, too.

What to include in the CLAUDE.md file:

1. Add "CRITICAL RULES - READ FIRST" section at the very top of CLAUDE.md
2. Put the content directly there (not just a reference to another file)
3. Explicitly list any details to avoid probablistic results

Pattern for strict rules:

## CRITICAL RULES - READ FIRST

**Before doing X, you MUST check Y**

| Thing | Value |
|-------|-------|
| ... | ... |

**Forbidden:** list of things never to do

Why this works better:

- Rules in .claude/rules/ require me to remember to check them
- Rules in CLAUDE.md are unavoidable - I see them every session
- Tables and bold text make them scannable
- "Forbidden" lists make violations obvious