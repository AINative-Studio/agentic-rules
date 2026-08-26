# Cody CLI Project Templates

Ready-to-use templates for setting up [Cody CLI](https://ainative.studio/cody) projects with AINative services.

## Quick Start

```bash
# From your project root:
cp -r /path/to/agentic-rules/templates/cody-cli/.cody ./.cody
cp /path/to/agentic-rules/templates/cody-cli/CODY.md.template ./CODY.md

# Replace all {{PLACEHOLDER}} values with your project values
```

## Template Contents

| Template | Purpose |
|----------|---------|
| `CODY.md.template` | Project context and memory file |
| `mcp.json.template` | MCP server configuration (ZeroDB, GitHub) |
| `settings.json.template` | Cody permissions (allow/deny) |
| `.cody/rules/` | Code quality, git, security, and testing rules |
| `.cody/commands/` | Slash commands for TDD, PR, and review workflows |
| `.cody/agents/` | Specialized agents (code reviewer, TDD coach, security auditor) |

## Placeholder Reference

| Placeholder | Description |
|-------------|-------------|
| `{{PROJECT_NAME}}` | Your project name |
| `{{TECH_STACK}}` | e.g., "TypeScript, React, Bun" |
| `{{REPOSITORY_URL}}` | GitHub repo URL |
| `{{GITHUB_TOKEN}}` | GitHub personal access token |
| `{{ZERODB_API_KEY}}` | AINative API key (sk_ prefix) |

## Rules

Rules in `.cody/rules/` are automatically loaded by Cody CLI. They enforce:

- **code-quality.md** — Naming, formatting, security, no dead code
- **git-rules.md** — Zero-tolerance AI attribution policy, conventional commits
- **testing.md** — TDD/BDD, 80% minimum coverage, edge case requirements
- **security.md** — No secrets in code, input validation, least privilege

## Agents

Custom agents in `.cody/agents/` provide specialized capabilities:

- **code-reviewer.md** — Reviews diffs for correctness, security, and quality
- **tdd-coach.md** — Enforces red-green-refactor discipline
- **security-auditor.md** — OWASP Top 10 scanning with severity scoring

## Commands

Slash commands in `.cody/commands/` add workflow shortcuts:

- `/tdd <feature>` — Start a TDD workflow
- `/pr` — Create a pull request with checklist
- `/review` — Run code review checklist
