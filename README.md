# Agentic Rules

IDE-agnostic coding standards, agent rules, and project templates for AI-assisted development. Built by [AINative Studio](https://ainative.studio) for the Cody ecosystem and compatible with all major agentic IDEs.

## Supported IDEs

| IDE | Config Location | Template |
|-----|----------------|----------|
| **Cody CLI** | `.cody/rules/`, `.cody/agents/`, `.cody/commands/` | `templates/cody-cli/` |
| **Claude Code** | `.claude/`, `CLAUDE.md` | `templates/claude-code/` |
| **Cursor** | `.cursorrules`, `.cursor/mcp.json` | `templates/cursor/` |
| **Windsurf** | `.windsurfrules`, `.windsurf/mcp.json` | `templates/windsurf/` |
| **VS Code** | `.vscode/settings.json`, snippets | `templates/vscode/` |
| **Gemini CLI** | `GEMINI.md`, `.gemini/settings.json` | `templates/gemini-cli/` |

## Quick Start

### Cody CLI

```bash
cp -r templates/cody-cli/.cody ./.cody
cp templates/cody-cli/CODY.md.template ./CODY.md
cp templates/cody-cli/mcp.json.template ./.mcp.json
# Replace {{PLACEHOLDER}} values with your project values
```

### Cursor

```bash
cp templates/cursor/.cursorrules ./.cursorrules
mkdir -p .cursor && cp templates/cursor/.cursor/mcp.json.template ./.cursor/mcp.json
```

### Windsurf

```bash
cp templates/windsurf/.windsurfrules ./.windsurfrules
mkdir -p .windsurf && cp templates/windsurf/.windsurf/mcp.json.template ./.windsurf/mcp.json
```

### Claude Code

```bash
cp -r templates/claude-code/.claude ./.claude
cp templates/claude-code/CLAUDE.md.template ./CLAUDE.md
```

### Gemini CLI

```bash
cp templates/gemini-cli/GEMINI.md.template ./GEMINI.md
mkdir -p .gemini && cp templates/gemini-cli/.gemini/settings.json.template ./.gemini/settings.json
```

## Repository Structure

```
agentic-rules/
├── templates/
│   ├── cody-cli/                  # Cody CLI project templates
│   │   ├── .cody/
│   │   │   ├── rules/             # Auto-loaded coding standards
│   │   │   ├── agents/            # Specialized agent definitions
│   │   │   └── commands/          # Slash command workflows
│   │   ├── CODY.md.template       # Project context template
│   │   ├── mcp.json.template      # MCP server configuration
│   │   └── settings.json.template # Permissions (allow/deny)
│   ├── claude-code/               # Claude Code templates
│   │   ├── .claude/               # Commands, agents, settings
│   │   ├── CLAUDE.md.template     # Project context template
│   │   └── scripts/               # Setup automation
│   ├── cursor/                    # Cursor IDE rules
│   │   ├── .cursorrules           # Agent behavior rules
│   │   └── .cursor/mcp.json.template
│   ├── windsurf/                  # Windsurf IDE rules
│   │   ├── .windsurfrules         # Agent behavior rules
│   │   └── .windsurf/mcp.json.template
│   ├── vscode/                    # VS Code configuration
│   │   ├── .vscode/settings.json.template
│   │   └── ainative-rules.code-snippets
│   └── gemini-cli/                # Google Gemini CLI
│       ├── GEMINI.md.template     # Project context
│       └── .gemini/settings.json.template
├── docs/
│   ├── LLM_PROJECT_SETUP_PROMPT.md  # Universal LLM setup guide
│   └── reports/                     # Automated scan reports
├── globalrules.md                 # Universal agentic behavior rules
├── MVP-GlobalRules.md             # Minimal viable rules for MVPs
├── meta-rules.md                  # Rules about creating rules
├── strict-rules-how-to.md        # Making rules stick
├── Agent-Personas.md              # 25 specialized agent personas
├── Agentic-Prompts-Library.md     # Curated LLM prompts
├── Enhanced-Agentic-Prompts-Library.md
├── agent-reasoning-planning-execution.md
├── OSS-Contributor-GlobalRules.md # External repo contribution rules
├── chat-completion-api.md         # AINative Chat Completion API guide
├── zerodb-userguide.md            # ZeroDB platform developer guide
└── CLAUDE.md                      # Project context for this repo
```

## Rule Documents

| Document | Purpose |
|----------|---------|
| `globalrules.md` | Full XP-oriented coding standards: backlog management, TDD/BDD, CI/CD, code style, security |
| `MVP-GlobalRules.md` | Lightweight rules for rapid prototyping with HyperScaler APIs |
| `meta-rules.md` | Framework for creating and enforcing agent rules (7-section structure) |
| `strict-rules-how-to.md` | Techniques for making critical rules stick in agentic environments |
| `Agent-Personas.md` | 25 specialized agent personas with invocation examples |
| `OSS-Contributor-GlobalRules.md` | Rules for contributing to repos you don't own |

## AINative Platform Integration

All templates include MCP server configuration for AINative services:

- **ZeroDB** — Vector storage, semantic search, embeddings, persistent memory
- **Chat Completion API** — Multi-provider LLM access (30+ models) with tool calling
- **API Gateway** — APISIX at `api.ainative.studio` with OAuth 2.1 + PKCE

### MCP Configuration

Every IDE template includes an MCP config pointing to:

```json
{
  "zerodb": {
    "type": "sse",
    "url": "https://api.ainative.studio/v1/mcp/zerodb-mcp/messages",
    "headers": { "x-api-key": "{{ZERODB_API_KEY}}" }
  }
}
```

Get your API key at [ainative.studio](https://ainative.studio).

## Core Standards

These standards are consistent across all IDE templates:

### Code Quality
- camelCase for variables/functions, PascalCase for classes/types
- 4-space indentation, target <= 80 chars per line
- Comments only when the WHY is non-obvious
- No dead code, no premature abstraction

### Testing
- TDD/BDD: write failing tests first, implement, refactor
- Minimum 80% coverage for new code
- BDD-style `describe/it` blocks with behavior-specification names

### Security
- Never log secrets or PII
- Validate input at system boundaries
- No hardcoded credentials — use environment variables
- API keys use `sk_` prefix for AINative platform

### Git — Zero Tolerance
- No AI attribution in commits, PRs, issues, or code comments
- Clean conventional commits: describe what and why
- Keep PRs under 300 LOC when possible

## Developer Guides

| Guide | Description |
|-------|-------------|
| `chat-completion-api.md` | BYOK developer guide for `/v1/chat/completions` — authentication, tool calling, 30+ tools, code examples |
| `zerodb-userguide.md` | ZeroDB platform guide — vectors, embeddings, tables, multi-dimension support |
| `docs/LLM_PROJECT_SETUP_PROMPT.md` | Universal prompt for any LLM to set up project configuration |

## Contributing

1. Fork and create a feature branch (`feature/<description>`)
2. Follow the coding standards in this repo
3. No AI attribution in commits or PRs
4. No secrets, personal data, or hardcoded paths — use `{{PLACEHOLDER}}` syntax
5. Submit a PR with a clear description of changes

## License

MIT License. See [LICENSE](LICENSE) for details.
