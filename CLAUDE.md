# agentic-rules

**Repository**: https://github.com/AINative-Studio/agentic-rules
**Purpose**: IDE-agnostic agent rules, coding standards, and project templates for agentic development
**Last Updated**: 2026-08-26

## Critical Rules

- All templates use `{{PLACEHOLDER}}` syntax — never commit real API keys, tokens, or personal data
- No AI attribution in commits, PRs, or code comments — zero tolerance
- Preserve placeholder syntax when editing templates
- Test template changes with `bash tests/templates.test.sh` before committing

## Project Structure

```
agentic-rules/
├── templates/
│   ├── cody-cli/              # Cody CLI (.cody/ rules, agents, commands)
│   ├── claude-code/           # Claude Code (.claude/ directory)
│   ├── cursor/                # Cursor (.cursorrules, .cursor/mcp.json)
│   ├── windsurf/              # Windsurf (.windsurfrules, .windsurf/mcp.json)
│   ├── vscode/                # VS Code (settings, snippets)
│   └── gemini-cli/            # Gemini CLI (GEMINI.md, .gemini/)
├── tests/                     # Template validation tests
├── docs/                      # Documentation and reports
├── .github/                   # Issue templates, CI workflows
├── *.md                       # Global rule files and guides
└── CLAUDE.md                  # This file
```

## Common Tasks

### Adding a new IDE template
1. Create `templates/<ide-name>/` with the IDE's config files
2. Include MCP config for ZeroDB and GitHub
3. Apply AINative coding standards (code quality, TDD, security, git rules)
4. Add to the IDE support table in `README.md`
5. Run `bash tests/templates.test.sh`

### Editing existing templates
1. Preserve `{{PLACEHOLDER}}` syntax for all configurable values
2. Validate JSON with `python3 -c "import json; json.load(open('file.json'))"`
3. Run tests before committing

### Running tests
```bash
bash tests/templates.test.sh
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

- Branch: `feature/<description>`, `fix/<description>`, `docs/<description>`
- Commits: clean conventional format, no AI attribution
- Tests: `bash tests/templates.test.sh` must pass
- Security: never commit secrets, use `{{PLACEHOLDER}}` syntax
