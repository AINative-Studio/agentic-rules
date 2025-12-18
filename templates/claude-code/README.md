# Claude Code Project Templates

Standardized templates for setting up Claude Code projects with AINative services integration.

## Quick Start

```bash
# From your project root:
cp -r /path/to/agentic-rules/templates/claude-code/.claude ./.claude
cp /path/to/agentic-rules/templates/claude-code/CLAUDE.md.template ./CLAUDE.md
cp /path/to/agentic-rules/templates/claude-code/env.example ./.env

# Rename example files
mv .claude/settings.local.json.example .claude/settings.local.json

# Edit files to match your project
# Replace all {{PLACEHOLDER}} values with actual values
```

## Template Contents

### Project-Level Templates

| File | Purpose |
|------|---------|
| `CLAUDE.md.template` | Project context and memory file for Claude |
| `env.example` | Environment variables template |
| `claude.json.template` | MCP server configuration (copy to `~/.claude.json`) |
| `settings.json.template` | Global Claude settings (copy to `~/.claude/settings.json`) |

### .claude/ Directory Templates

| File | Purpose |
|------|---------|
| `.claude/settings.local.json.example` | Project-specific permissions |
| `.claude/agents/agent.md.template` | Custom agent definition template |
| `.claude/commands/command.md.template` | Custom slash command template |
| `.claude/commands/tdd.md` | TDD workflow command |
| `.claude/commands/pr.md` | Pull request creation command |
| `.claude/commands/review.md` | Code review checklist command |

## Configuration

### 1. Project Context (CLAUDE.md)

Copy `CLAUDE.md.template` to your project root as `CLAUDE.md` and customize:

```markdown
# {{PROJECT_NAME}}

**Tech Stack**: {{TECH_STACK}}
...
```

Replace all `{{PLACEHOLDER}}` values with your project specifics.

### 2. Environment Variables (.env)

Copy `env.example` to `.env` and configure:

```bash
# Required for AINative/ZeroDB
ZERODB_PROJECT_ID=your-project-id
ZERODB_API_KEY=your-api-key
ZERODB_API_URL=https://api.ainative.studio

# AI Providers
OPENAI_API_KEY=your-key
ANTHROPIC_API_KEY=your-key
```

### 3. MCP Servers (claude.json)

For AINative service integration, copy `claude.json.template` to `~/.claude.json`:

```json
{
  "mcpServers": {
    "zerodb": {
      "command": "npx",
      "args": ["-y", "ainative-zerodb-mcp-server"],
      "env": {
        "ZERODB_API_URL": "https://api.ainative.studio",
        "ZERODB_USERNAME": "your-email",
        "ZERODB_PASSWORD": "your-password",
        "ZERODB_PROJECT_ID": "your-project-id"
      }
    }
  }
}
```

### 4. Project Permissions

Copy `.claude/settings.local.json.example` to `.claude/settings.local.json` and customize the allowed commands for your project.

## Slash Commands

The template includes ready-to-use slash commands:

- `/tdd <feature>` - Start a TDD workflow
- `/pr` - Create a pull request with proper formatting
- `/review` - Run through code review checklist

## Creating Custom Commands

Use `.claude/commands/command.md.template` as a starting point:

```markdown
# {{COMMAND_NAME}}

{{COMMAND_DESCRIPTION}}

## Arguments
- `$ARGUMENTS` - {{ARGUMENTS_DESCRIPTION}}
```

Save as `.claude/commands/your-command.md`

## Creating Custom Agents

Use `.claude/agents/agent.md.template` as a starting point:

```markdown
---
name: {{AGENT_NAME}}
description: {{AGENT_DESCRIPTION}}
model: {{MODEL}}
---

# {{AGENT_NAME}}
...
```

Save as `~/.claude/agents/your-agent.md`

## Placeholder Reference

All templates use `{{PLACEHOLDER}}` syntax for easy find-and-replace:

| Placeholder | Description |
|-------------|-------------|
| `{{PROJECT_NAME}}` | Your project name |
| `{{TECH_STACK}}` | e.g., "React, TypeScript, FastAPI" |
| `{{ZERODB_PROJECT_ID}}` | From AINative dashboard |
| `{{ZERODB_API_KEY}}` | From AINative dashboard |
| `{{PORT}}` | Dev server port (e.g., 8000) |

## Related Documentation

- [LLM Project Setup Prompt](../docs/LLM_PROJECT_SETUP_PROMPT.md) - Universal setup guide for any LLM
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [AINative Studio](https://ainative.studio)

## License

MIT - See repository LICENSE file.
