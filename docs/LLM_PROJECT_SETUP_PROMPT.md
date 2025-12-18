# LLM Project Setup Prompt

> A reusable prompt for any local-filesystem LLM (Claude Code, Gemini CLI, Aider, etc.) to help users establish a centralized project configuration system with templates and automation.

---

## Prompt

You are helping a developer set up a **centralized local configuration system** for managing multiple projects with consistent tooling, credentials, and templates. This system allows any LLM assistant with filesystem access to quickly configure new projects using pre-defined templates.

### Your Task

Help the user create and maintain the following structure:

```
~/Documents/Projects/<workspace>/src/docs/
├── README.md                    # Overview of the docs system
├── <PLATFORM>_SETUP.md          # Platform-specific setup guide
├── LLM_PROJECT_SETUP_PROMPT.md  # This prompt (meta/bootstrap)
├── templates/
│   ├── env.template             # Generic .env with {{PLACEHOLDERS}}
│   ├── env.<username>           # User's personal credentials
│   ├── claude.json.template     # MCP server configuration
│   ├── settings.json.template   # Global LLM settings
│   ├── settings.local.json.template  # Project permissions
│   ├── CLAUDE.md.template       # Project context file
│   ├── agent.md.template        # Custom agent definition
│   └── command.md.template      # Custom slash command
└── scripts/
    └── setup-project.sh         # Automation script
```

### Step-by-Step Process

#### 1. Identify the Central Docs Location

Ask the user where they want their central docs folder. Common patterns:
- `~/Documents/Projects/<workspace>/src/docs/`
- `~/.config/llm-templates/`
- `~/dotfiles/llm/`

#### 2. Create the Directory Structure

```bash
mkdir -p <docs_path>/templates
mkdir -p <docs_path>/scripts
```

#### 3. Create the Generic Environment Template

Create `templates/env.template` with common variables using `{{PLACEHOLDER}}` syntax:

```bash
# ===========================================
# {{PROJECT_NAME}} Environment Configuration
# ===========================================

# Application
ENVIRONMENT={{ENVIRONMENT}}
DEBUG={{DEBUG}}
HOST={{HOST}}
PORT={{PORT}}

# Database
DATABASE_URL={{DATABASE_URL}}

# API Services (ZeroDB/AINative)
ZERODB_PROJECT_ID={{ZERODB_PROJECT_ID}}
ZERODB_API_KEY={{ZERODB_API_KEY}}
ZERODB_API_URL={{ZERODB_API_URL}}

# AI Providers
OPENAI_API_KEY={{OPENAI_API_KEY}}
ANTHROPIC_API_KEY={{ANTHROPIC_API_KEY}}

# Authentication
JWT_SECRET_KEY={{JWT_SECRET_KEY}}

# OAuth (optional)
LINKEDIN_CLIENT_ID={{LINKEDIN_CLIENT_ID}}
LINKEDIN_CLIENT_SECRET={{LINKEDIN_CLIENT_SECRET}}
```

#### 4. Create User's Personal Credentials File

Create `templates/env.<username>` with the user's actual credentials. This file:
- Contains real API keys and secrets
- Should NEVER be committed to version control
- Can be copied to any project's `.env`

Ask the user for their credentials or help them locate existing ones in:
- `~/.claude.json` (MCP server configs)
- Existing project `.env` files
- Environment variables (`env | grep -i api`)

#### 5. Create Platform-Specific Templates

**For Claude Code** - `templates/claude.json.template`:
```json
{
  "mcpServers": {
    "github": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_TOKEN": "{{GITHUB_TOKEN}}" }
    },
    "zerodb": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "ainative-zerodb-mcp-server"],
      "env": {
        "ZERODB_API_URL": "{{ZERODB_API_URL}}",
        "ZERODB_USERNAME": "{{ZERODB_USERNAME}}",
        "ZERODB_PASSWORD": "{{ZERODB_PASSWORD}}",
        "ZERODB_PROJECT_ID": "{{ZERODB_PROJECT_ID}}"
      }
    }
  }
}
```

**Project Context** - `templates/CLAUDE.md.template`:
```markdown
# {{PROJECT_NAME}}

**Tech Stack**: {{TECH_STACK}}
**Last Updated**: {{DATE}}

## Architecture
{{ARCHITECTURE_NOTES}}

## Coding Conventions
{{CONVENTIONS}}

## Critical Files
{{CRITICAL_FILES}}
```

**Project Permissions** - `templates/settings.local.json.template`:
```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(npm:*)",
      "mcp__github__*",
      "mcp__zerodb__*"
    ],
    "deny": [],
    "ask": ["Bash(sudo:*)"]
  }
}
```

#### 6. Create Setup Script

Create `scripts/setup-project.sh`:

```bash
#!/bin/bash
# Project Setup Script
# Usage: ./setup-project.sh <project-path> [username]

set -e

PROJECT_PATH="${1:-.}"
USERNAME="${2:-$(whoami)}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$(dirname "$SCRIPT_DIR")/templates"

echo "Setting up project at: $PROJECT_PATH"

# Create project directories
mkdir -p "$PROJECT_PATH/.claude"

# Copy and configure .env
if [ -f "$TEMPLATES_DIR/env.$USERNAME" ]; then
    cp "$TEMPLATES_DIR/env.$USERNAME" "$PROJECT_PATH/.env"
    echo "Created .env from $USERNAME's template"
else
    cp "$TEMPLATES_DIR/env.template" "$PROJECT_PATH/.env"
    echo "Created .env from generic template - please configure"
fi

# Copy permissions template
cp "$TEMPLATES_DIR/settings.local.json.template" "$PROJECT_PATH/.claude/settings.local.json"
sed -i "s|{{PROJECT_PATH}}|$PROJECT_PATH|g" "$PROJECT_PATH/.claude/settings.local.json"

# Create CLAUDE.md if it doesn't exist
if [ ! -f "$PROJECT_PATH/CLAUDE.md" ]; then
    cp "$TEMPLATES_DIR/CLAUDE.md.template" "$PROJECT_PATH/CLAUDE.md"
    echo "Created CLAUDE.md - please customize"
fi

echo "Project setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env with any missing credentials"
echo "2. Customize CLAUDE.md with project details"
echo "3. Review .claude/settings.local.json permissions"
```

Make executable: `chmod +x scripts/setup-project.sh`

#### 7. Create the Setup Guide

Create `<PLATFORM>_SETUP.md` documenting:
- All configuration file locations (global and project-level)
- Template descriptions and usage
- MCP server installation commands
- Verification commands
- Troubleshooting tips

### Usage Patterns

**Setting up a new project:**
```bash
# Using the script
./docs/scripts/setup-project.sh /path/to/new/project quaid

# Or manually
cp docs/templates/env.quaid /path/to/new/project/.env
cp docs/templates/CLAUDE.md.template /path/to/new/project/CLAUDE.md
```

**Updating credentials across projects:**
```bash
# Edit the central credentials file
vim docs/templates/env.quaid

# Copy to projects that need updating
cp docs/templates/env.quaid project1/.env
cp docs/templates/env.quaid project2/.env
```

**Adding a new template:**
1. Create the template in `docs/templates/`
2. Use `{{PLACEHOLDER}}` syntax for configurable values
3. Document in the setup guide
4. Update the setup script if needed

### Key Principles

1. **Centralization**: One place for all templates and credentials
2. **Separation**: Generic templates vs. user-specific credentials
3. **Portability**: Works across different LLM tools (Claude, Gemini, etc.)
4. **Security**: Credentials files never committed to git
5. **Automation**: Scripts reduce manual setup errors

### Placeholder Convention

Use double curly braces for all configurable values:
- `{{PROJECT_NAME}}` - Will be replaced during setup
- `{{ZERODB_API_KEY}}` - Credentials from user's env file
- `{{DATE}}` - Auto-populated by script

### For Other LLM Platforms

This system works with any LLM that has filesystem access:

| Platform | Config Location | Notes |
|----------|-----------------|-------|
| Claude Code | `~/.claude.json`, `~/.claude/` | Full MCP support |
| Gemini CLI | `~/.gemini/` | Adapt templates as needed |
| Aider | `~/.aider/` | Uses .env natively |
| Continue | `~/.continue/` | JSON config format |

Adapt the templates to each platform's configuration format while keeping the central docs structure consistent.

---

## Quick Start for New Users

If you're setting this up for the first time:

1. **Tell me where you want the docs folder**
2. **I'll create the directory structure**
3. **Share your existing credentials** (or I'll help find them)
4. **I'll create your personal env file**
5. **We'll test with a sample project**

What's your preferred location for the central docs folder?
