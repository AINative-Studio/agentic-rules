# Claude Code Project Template

This template provides a standardized `.claude/` folder structure and `CLAUDE.md` project memory file for use with Claude Code (Anthropic's CLI for Claude).

## Quick Start

1. Copy the `CLAUDE.md` file to your project root
2. Copy the `.claude/` folder to your project root
3. Customize the templates for your project

```bash
# From your project root:
cp /path/to/agentic-rules/templates/claude-code/CLAUDE.md ./CLAUDE.md
cp -r /path/to/agentic-rules/templates/claude-code/.claude ./.claude

# Rename the example settings file
mv .claude/settings.local.json.example .claude/settings.local.json

# Edit CLAUDE.md to match your project
# Edit .claude/settings.local.json to add project-specific permissions
```

## Template Contents

### CLAUDE.md
Project memory file that Claude reads on every session. Contains:
- Project overview and tech stack
- Development conventions
- TDD/Red-Green workflow rules
- Branch naming and PR workflow
- Pre-commit checklist
- Architecture patterns

### .claude/settings.local.json.example
Local permissions template for Claude Code tools. Copy to `settings.local.json` and customize based on your project needs.

### .claude/commands/
Custom slash commands for common workflows:
- `/tdd` - Start TDD workflow for a feature
- `/pr` - Create a pull request with proper formatting
- `/review` - Code review checklist

## Customization Guide

### 1. Update CLAUDE.md

Replace placeholder values:
- `{{PROJECT_NAME}}` - Your project name
- `{{TECH_STACK}}` - Your tech stack
- `{{PORT}}` - Your dev server port
- `{{REPO_URL}}` - Your repository URL

### 2. Configure Permissions

Edit `.claude/settings.local.json` to add commands Claude can run without asking:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run test:*)",
      "Bash(npm run build:*)",
      "Bash(git commit:*)",
      "Bash(git push:*)"
    ]
  }
}
```

### 3. Add Project-Specific Commands

Create custom commands in `.claude/commands/`:

```markdown
<!-- .claude/commands/deploy.md -->
Deploy the application to staging:
1. Run tests
2. Build the project
3. Deploy using {{DEPLOY_COMMAND}}
```

## Attribution Note

By default, Claude Code adds co-authorship to commits. To customize:

- **Keep attribution** (recommended for showcasing AI collaboration): No changes needed
- **Remove attribution**: Configure in Claude Code settings

## License

MIT - See the main repository LICENSE file.
