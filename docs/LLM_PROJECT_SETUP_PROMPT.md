# LLM Project Setup Prompt

> A reusable prompt for any local-filesystem LLM (Cody CLI, Claude Code, Gemini CLI, Cursor, Aider, etc.) to help users establish a centralized project configuration system with templates and automation.

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
│   ├── mcp.json.template        # MCP server configuration
│   ├── settings.json.template   # Project permissions
│   ├── CODY.md.template         # Project context file (Cody CLI)
│   ├── CLAUDE.md.template       # Project context file (Claude Code)
│   ├── .cursorrules.template    # Agent rules (Cursor)
│   ├── .windsurfrules.template  # Agent rules (Windsurf)
│   ├── GEMINI.md.template       # Project context file (Gemini CLI)
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
ZERODB_API_URL=https://api.ainative.studio

# AI Providers
OPENAI_API_KEY={{OPENAI_API_KEY}}
ANTHROPIC_API_KEY={{ANTHROPIC_API_KEY}}

# Authentication
JWT_SECRET_KEY={{JWT_SECRET_KEY}}
```

#### 4. Create User's Personal Credentials File

Create `templates/env.<username>` with the user's actual credentials. This file:
- Contains real API keys and secrets
- Should NEVER be committed to version control
- Can be copied to any project's `.env`

Ask the user for their credentials or help them locate existing ones in:
- Existing project `.env` files
- Environment variables (`env | grep -i api`)

#### 5. Create Platform-Specific Templates

**MCP Configuration** — `templates/mcp.json.template` (works with Cody CLI, Claude Code, Cursor, Windsurf):
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
      "type": "sse",
      "url": "https://api.ainative.studio/v1/mcp/zerodb-mcp/messages",
      "headers": { "x-api-key": "{{ZERODB_API_KEY}}" }
    }
  }
}
```

**Project Context** — use the appropriate template for your IDE:

| IDE | Template | File Name |
|-----|----------|-----------|
| Cody CLI | `CODY.md.template` | `CODY.md` |
| Claude Code | `CLAUDE.md.template` | `CLAUDE.md` |
| Cursor | `.cursorrules.template` | `.cursorrules` |
| Windsurf | `.windsurfrules.template` | `.windsurfrules` |
| Gemini CLI | `GEMINI.md.template` | `GEMINI.md` |

**Project Permissions** — `templates/settings.json.template`:
```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(npm:*)",
      "Bash(bun:*)",
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
# Usage: ./setup-project.sh <project-path> [ide] [username]
# IDE options: cody, claude, cursor, windsurf, gemini

set -e

PROJECT_PATH="${1:-.}"
IDE="${2:-cody}"
USERNAME="${3:-$(whoami)}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$(dirname "$SCRIPT_DIR")/templates"

echo "Setting up $IDE project at: $PROJECT_PATH"

# Copy and configure .env
if [ -f "$TEMPLATES_DIR/env.$USERNAME" ]; then
    cp "$TEMPLATES_DIR/env.$USERNAME" "$PROJECT_PATH/.env"
    echo "Created .env from $USERNAME's template"
else
    cp "$TEMPLATES_DIR/env.template" "$PROJECT_PATH/.env"
    echo "Created .env from generic template - please configure"
fi

# IDE-specific setup
case "$IDE" in
    cody)
        mkdir -p "$PROJECT_PATH/.cody/rules" "$PROJECT_PATH/.cody/agents" "$PROJECT_PATH/.cody/commands"
        [ ! -f "$PROJECT_PATH/CODY.md" ] && cp "$TEMPLATES_DIR/CODY.md.template" "$PROJECT_PATH/CODY.md"
        cp "$TEMPLATES_DIR/settings.json.template" "$PROJECT_PATH/.cody/settings.json"
        cp "$TEMPLATES_DIR/mcp.json.template" "$PROJECT_PATH/.mcp.json"
        echo "Created CODY.md, .cody/, .mcp.json"
        ;;
    claude)
        mkdir -p "$PROJECT_PATH/.claude"
        [ ! -f "$PROJECT_PATH/CLAUDE.md" ] && cp "$TEMPLATES_DIR/CLAUDE.md.template" "$PROJECT_PATH/CLAUDE.md"
        cp "$TEMPLATES_DIR/settings.json.template" "$PROJECT_PATH/.claude/settings.local.json"
        cp "$TEMPLATES_DIR/mcp.json.template" "$PROJECT_PATH/.mcp.json"
        echo "Created CLAUDE.md, .claude/, .mcp.json"
        ;;
    cursor)
        mkdir -p "$PROJECT_PATH/.cursor"
        [ ! -f "$PROJECT_PATH/.cursorrules" ] && cp "$TEMPLATES_DIR/.cursorrules.template" "$PROJECT_PATH/.cursorrules"
        cp "$TEMPLATES_DIR/mcp.json.template" "$PROJECT_PATH/.cursor/mcp.json"
        echo "Created .cursorrules, .cursor/mcp.json"
        ;;
    windsurf)
        mkdir -p "$PROJECT_PATH/.windsurf"
        [ ! -f "$PROJECT_PATH/.windsurfrules" ] && cp "$TEMPLATES_DIR/.windsurfrules.template" "$PROJECT_PATH/.windsurfrules"
        cp "$TEMPLATES_DIR/mcp.json.template" "$PROJECT_PATH/.windsurf/mcp.json"
        echo "Created .windsurfrules, .windsurf/mcp.json"
        ;;
    gemini)
        mkdir -p "$PROJECT_PATH/.gemini"
        [ ! -f "$PROJECT_PATH/GEMINI.md" ] && cp "$TEMPLATES_DIR/GEMINI.md.template" "$PROJECT_PATH/GEMINI.md"
        cp "$TEMPLATES_DIR/mcp.json.template" "$PROJECT_PATH/.gemini/settings.json"
        echo "Created GEMINI.md, .gemini/"
        ;;
    *)
        echo "Unknown IDE: $IDE (use: cody, claude, cursor, windsurf, gemini)"
        exit 1
        ;;
esac

echo ""
echo "Setup complete! Next steps:"
echo "1. Edit .env with any missing credentials"
echo "2. Customize the project context file with project details"
echo "3. Replace all {{PLACEHOLDER}} values"
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
# Using the script (defaults to Cody CLI)
./docs/scripts/setup-project.sh /path/to/new/project cody

# For Cursor
./docs/scripts/setup-project.sh /path/to/new/project cursor

# For Claude Code
./docs/scripts/setup-project.sh /path/to/new/project claude
```

**Adding a new template:**
1. Create the template in `docs/templates/`
2. Use `{{PLACEHOLDER}}` syntax for configurable values
3. Document in the setup guide
4. Update the setup script if needed

### Key Principles

1. **Centralization**: One place for all templates and credentials
2. **Separation**: Generic templates vs. user-specific credentials
3. **Portability**: Works across different LLM tools and IDEs
4. **Security**: Credentials files never committed to git
5. **Automation**: Scripts reduce manual setup errors

### IDE Configuration Reference

| IDE | Context File | Config Dir | MCP Config | Rules |
|-----|-------------|------------|------------|-------|
| Cody CLI | `CODY.md` | `.cody/` | `.mcp.json` | `.cody/rules/` |
| Claude Code | `CLAUDE.md` | `.claude/` | `.mcp.json` | `.claude/rules/` |
| Cursor | `.cursorrules` | `.cursor/` | `.cursor/mcp.json` | `.cursorrules` |
| Windsurf | `.windsurfrules` | `.windsurf/` | `.windsurf/mcp.json` | `.windsurfrules` |
| Gemini CLI | `GEMINI.md` | `.gemini/` | `.gemini/settings.json` | `GEMINI.md` |
| Aider | — | `~/.aider/` | — | `.aider.conf.yml` |
| Continue | — | `~/.continue/` | `.continue/config.json` | — |

Adapt the templates to each platform's configuration format while keeping the central docs structure consistent.

---

## Quick Start for New Users

If you're setting this up for the first time:

1. **Tell me where you want the docs folder**
2. **I'll create the directory structure**
3. **Share your existing credentials** (or I'll help find them)
4. **I'll create your personal env file**
5. **Which IDE(s) do you use?** (I'll create the right templates)
6. **We'll test with a sample project**

What's your preferred location for the central docs folder?
