# agentic-rules

**Repository**: https://github.com/AINative-Studio/agentic-rules
**Purpose**: IDE-agnostic agent rules, coding standards, and project templates for agentic development
**Last Updated**: 2026-08-26

## Project Overview

Reusable configuration templates and rule files for AI-assisted development environments. Supports Cody CLI, Claude Code, Cursor, Windsurf, VS Code, and Gemini CLI.

## Directory Structure

```
agentic-rules/
├── templates/
│   ├── cody-cli/              # Cody CLI templates (.cody/ rules, agents, commands)
│   ├── claude-code/           # Claude Code templates (.claude/ directory)
│   ├── cursor/                # Cursor rules (.cursorrules, .cursor/mcp.json)
│   ├── windsurf/              # Windsurf rules (.windsurfrules, .windsurf/mcp.json)
│   ├── vscode/                # VS Code settings and snippets
│   └── gemini-cli/            # Gemini CLI templates (GEMINI.md, .gemini/)
├── docs/                      # Documentation and reports
├── *.md                       # Global rule files and guides
└── CLAUDE.md                  # This file
```

## Key Files

| File | Purpose |
|------|---------|
| `globalrules.md` | Universal agentic behavior rules (XP-oriented) |
| `MVP-GlobalRules.md` | Minimal viable rules for rapid prototyping |
| `meta-rules.md` | Rules about creating and enforcing rules |
| `Agent-Personas.md` | 25 specialized agent personas |
| `chat-completion-api.md` | AINative Chat Completion API developer guide |
| `zerodb-userguide.md` | ZeroDB platform developer guide |
| `OSS-Contributor-GlobalRules.md` | Rules for external OSS contributions |

## Development Workflow

### Branch Naming
- `feature/<description>` — New features or templates
- `fix/<description>` — Bug fixes or corrections
- `docs/<description>` — Documentation updates

### Commit Convention
- Clean conventional commits: describe what and why
- No AI attribution — zero tolerance

### Security
- All templates use `{{PLACEHOLDER}}` syntax for configurable values
- Never commit API keys, tokens, passwords, or personal data
- When editing templates, preserve placeholder syntax
