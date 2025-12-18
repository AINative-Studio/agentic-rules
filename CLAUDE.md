# agentic-rules

**Repository**: https://github.com/AINative-Studio/agentic-rules
**Purpose**: Markdown syntax rules and templates for agentic IDEs (Claude Code, Gemini CLI, etc.)
**Last Updated**: 2025-12-17

## Project Overview

This repository provides reusable configuration templates and rule files for AI-assisted development environments. It includes:

- Global rules for agentic behavior
- Project templates for Claude Code
- Setup scripts for MCP server configuration
- Permissions templates for common workflows

## Directory Structure

```
agentic-rules/
├── templates/
│   └── claude-code/           # Claude Code project templates
│       ├── .claude/           # Sample .claude directory
│       ├── scripts/           # Setup automation
│       └── *.template         # Configuration templates
├── docs/                      # Documentation
├── *.md                       # Global rule files
└── CLAUDE.md                  # This file
```

## Key Files

| File | Purpose |
|------|---------|
| `globalrules.md` | Universal agentic behavior rules |
| `MVP-GlobalRules.md` | Minimal viable rules for quick setup |
| `meta-rules.md` | Rules about creating rules |
| `templates/claude-code/` | Complete Claude Code project template |

## Development Workflow

### Branch Naming
- `feature/<description>` - New features or templates
- `fix/<description>` - Bug fixes or corrections
- `docs/<description>` - Documentation updates

### Commit Convention
- Keep commits focused and atomic
- Use descriptive commit messages
- Reference issues when applicable

### PR Process
1. Create feature branch from `main`
2. Make changes and test templates locally
3. Push and create PR
4. Ensure no secrets or personal data included
5. Merge when approved

## Testing Templates

To test templates locally:

```bash
# Create a test project
mkdir /tmp/test-project && cd /tmp/test-project

# Copy templates
cp -r templates/claude-code/.claude ./.claude
cp templates/claude-code/CLAUDE.md.template ./CLAUDE.md

# Replace placeholders
sed -i 's/{{PROJECT_NAME}}/Test Project/g' CLAUDE.md
```

## Security Guidelines

**NEVER include in commits:**
- API keys or tokens
- Passwords or secrets
- Personal email addresses
- User-specific file paths (use `{{PLACEHOLDER}}` syntax)

All templates must use `{{PLACEHOLDER}}` syntax for configurable values.

## Notes for Claude

- This repo contains templates - be careful not to confuse template placeholders with actual values
- When editing templates, preserve the `{{PLACEHOLDER}}` syntax
- Test changes don't accidentally include personal data
- The `templates/claude-code/scripts/` contains executable scripts - maintain their functionality
