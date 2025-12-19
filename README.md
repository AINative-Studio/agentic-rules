# Agentic Development Rules Repository

This repository hosts a collection of coding‐standards and workflow “rules” documents designed to guide agent‐driven, XP‐oriented development workflows. While originally tailored for **AINative Studio** and its embedded agent **Cody**, these rules can be reused or adapted in any popular IDE that supports agentic assistants (e.g., VS Code with AI extensions, IntelliJ IDEA with “IntelliCode,” or other environments that support Model Context Protocol–driven agents).

---

## Table of Contents

1. [Purpose & Overview](#purpose--overview)
2. [Repository Structure](#repository-structure)
3. [Getting Started](#getting-started)
   - [Cloning the Repo](#cloning-the-repo)
   - [Rule Document Formats](#rule-document-formats)
4. [Claude Code Templates](#claude-code-templates)
   - [Quick Start](#quick-start)
   - [Automated Setup](#automated-setup)
   - [Template Contents](#template-contents)
5. [Usage in AINative Studio](#usage-in-ainative-studio)
   - [Configuring Cody](#configuring-cody)
   - [MCP Integration](#mcp-integration)
6. [Usage in Other IDEs](#usage-in-other-ides)
   - [VS Code (with AI Extensions)](#vs-code-with-ai-extensions)
   - [IntelliJ IDEA / WebStorm](#intellij-idea--webstorm)
   - [Other Agentic‐Enabled IDEs](#other-agentic-enabled-ides)
7. [Documentation & Rule Sets](#documentation--rule-sets)
   - [Core "MVP‐Focused" Rules](#core-mvp-focused-rules)
   - [Prototype Mode vs. Full Standards](#prototype-mode-vs-full-standards)
8. [Contributing Guidelines](#contributing-guidelines)
9. [Versioning & Releases](#versioning--releases)
10. [License](#license)

---

## Purpose & Overview

When building software in an XP (Extreme Programming) style with heavy reliance on agentic AI (Model Context Protocol–driven assistants), developers need **machine‐readable, prescriptive guidelines** that codify:

- **Backlog Management** (using GitHub Issues + MCP)  
- **Branching & Naming Conventions**  
- **Minimal‐Code Prototyping** (leveraging HyperScaler Functions, Storage, Compute)  
- **Test-Driven & Behavior-Driven Development** (TDD/BDD)  
- **CI/CD Pipelines** (lightweight, rapid MVP deployments)  
- **Version Control Best Practices**

These rule sets empower any agentic assistant—whether “Cody” in AINative Studio or an AI plugin in VS Code—to automatically:

1. **Fetch, classify, and update backlog items** in real time via MCP.  
2. **Generate failing tests (Red)**, implement minimal code (Green), and refactor.  
3. **Open and update pull requests** with automated comments, coverage reports, and deployment URLs.  
4. **Enforce naming, formatting, and minimal‐dependency guidelines** for rapid prototypes.  
5. **Trigger HyperScaler‐based deployments** (e.g., AWS Lambda, Azure Functions, GCP Functions) from a single code push.  

Even if your organization does **not** use AINative Studio, adopting these rule sets in any IDE that supports Model Context Protocol or similar agentic protocols will standardize your team’s rapid MVP workflows.

---

## Repository Structure

```
/agentic-rules
├── CLAUDE.md                    # Project context for AI assistants
├── README.md
├── .claude/
│   └── rules/
│       └── git-rules.md         # Git attribution policy
├── docs/
│   └── LLM_PROJECT_SETUP_PROMPT.md  # Universal LLM setup guide
├── templates/
│   └── claude-code/             # Claude Code project templates
│       ├── README.md            # Template usage guide
│       ├── CLAUDE.md.template   # Project context template
│       ├── claude.json.template # MCP server configuration
│       ├── settings.json.template
│       ├── env.example          # Environment variables
│       ├── .claude/
│       │   ├── settings.local.json.example
│       │   ├── agents/
│       │   │   └── agent.md.template
│       │   └── commands/
│       │       ├── command.md.template
│       │       ├── tdd.md
│       │       ├── pr.md
│       │       └── review.md
│       └── scripts/
│           ├── claude-code-setup.sh    # Interactive setup wizard
│           └── merged-permissions.json  # Comprehensive permissions
├── globalrules.md               # Universal agentic behavior rules
├── MVP-GlobalRules.md           # Minimal viable rules
├── meta-rules.md                # Rules about creating rules
├── strict-rules-how-to.md       # Guide for enforcing critical rules
├── Agent-Personas.md            # 25 specialized agent personas (pending)
├── Agentic-Prompts-Library.md
├── Enhanced-Agentic-Prompts-Library.md
├── agent-reasoning-planning-execution.md
└── LICENSE
```

### Key Directories

- **`templates/claude-code/`**: Complete project templates for Claude Code CLI
  - Configuration templates with `{{PLACEHOLDER}}` syntax
  - Slash commands for TDD, PR creation, and code review
  - Automated setup scripts for MCP servers

- **`docs/`**: Documentation and guides
  - **`LLM_PROJECT_SETUP_PROMPT.md`**: Universal prompt for any LLM to set up projects

- **`.claude/rules/`**: Project-specific rules
  - **`git-rules.md`**: Git commit attribution policy

### Rule Documents

| File | Purpose |
|------|---------|
| `globalrules.md` | Universal agentic behavior rules |
| `MVP-GlobalRules.md` | Minimal viable rules for quick setup |
| `meta-rules.md` | Rules about creating rules |
| `strict-rules-how-to.md` | Guide for making rules stick |
| `Agent-Personas.md` | 25 specialized LLM agent personas |

---

## Getting Started

### Cloning the Repo

```bash
git clone https://github.com/AINative-Studio/agentic-rules.git
cd agentic-rules
```

### Rule Document Formats

All documents live under `docs/` in Markdown format. You can open them directly in any text editor or IDE. If your agentic plugin supports "live rule loading," point the plugin's "rules directory" to `/agentic-rules/docs/` to enable automated enforcement.

---

## Claude Code Templates

This repository includes ready-to-use templates for setting up Claude Code projects with AINative services integration.

### Quick Start

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

### Automated Setup

Use the interactive setup script for guided configuration:

```bash
cd templates/claude-code/scripts

# Check current configuration status
./claude-code-setup.sh --check

# Full installation (MCP servers, agents, commands)
./claude-code-setup.sh --install

# Apply permissions to current project
./claude-code-setup.sh --init-project

# Configure MCP servers only
./claude-code-setup.sh --mcp-only
```

The script prompts for credentials interactively - no secrets are hardcoded.

### Template Contents

| Template | Purpose |
|----------|---------|
| `CLAUDE.md.template` | Project context and memory file |
| `claude.json.template` | MCP server configuration (ZeroDB, Strapi, GitHub) |
| `settings.json.template` | Global Claude settings |
| `env.example` | Environment variables template |
| `.claude/settings.local.json.example` | Project-specific permissions |
| `.claude/commands/tdd.md` | TDD workflow slash command |
| `.claude/commands/pr.md` | Pull request creation command |
| `.claude/commands/review.md` | Code review checklist command |

### Placeholder Reference

All templates use `{{PLACEHOLDER}}` syntax for easy find-and-replace:

| Placeholder | Description |
|-------------|-------------|
| `{{PROJECT_NAME}}` | Your project name |
| `{{TECH_STACK}}` | e.g., "React, TypeScript, FastAPI" |
| `{{ZERODB_PROJECT_ID}}` | From AINative dashboard |
| `{{PROJECT_PATH}}` | Absolute path to project |

For detailed template documentation, see [`templates/claude-code/README.md`](templates/claude-code/README.md).

---

## Usage in AINative Studio

If you are using **AINative Studio** (which includes the **Cody** Agent), follow these steps:

1. **Open the Rules Directory**

   * In AINative Studio, go to **File → Open Folder** and select `/agentic-rules/docs/`.
   * Cody will automatically ingest all `.md` files as “guidelines” for each development phase.

2. **Configure MCP Endpoint**

   * Open `settings.json` (AINative Studio’s IDE settings) and add:

     ```jsonc
     {
       "cody.mcpEndpoint": "http://localhost:8000/mcp",
       "cody.rulesDir": "/absolute/path/to/agentic-rules/docs"
     }
     ```
   * Adjust `mcpEndpoint` to point to your local or hosted MCP service.

3. **Backlog Integration**

   * In AINative Studio’s “Backlog” panel, configure GitHub credentials and set “Rules Source” to use `docs/MVP-Focused-Rules.md` or `docs/Full-Coding-Standards.md`.
   * Cody will automatically read “LLM Prompts” from those docs to fetch and classify issues.

4. **Agentic Workflow**

   * When you create or update a GitHub Issue labeled `mvp-feature`, Cody will invoke the MCP snippet defined in `docs/Example-MCP-Scripts.md` to mark it “in progress,” generate a failing test, and open a new branch.
   * As you type code, Cody will reference the “Coding Style Guidelines” in `docs/Full-Coding-Standards.md` or “Minimal Code Guidelines” in `docs/MVP-Focused-Rules.md` to auto-suggest best practices.
   * On `git push`, Cody triggers the CI/CD pipeline (via `sample-workflow.vscode.json` tasks) and uses HyperScaler integration scripts from `docs/HyperScaler-Integration-Guide.md` to deploy the function.

---

## Usage in Other IDEs

These rules are IDE-agnostic as long as the IDE supports an agentic assistant or can run MCP scripts. Below are integration notes for popular environments:

### VS Code (with AI Extensions)

1. **Install an MCP-Capable Extension**

   * Examples:

     * “AI Codex” (supports MCP)
     * “GitHub Copilot Labs” (can be configured to forward prompts)
   * Configure extension to call your MCP endpoint (e.g., via `settings.json`):

     ```jsonc
     {
       "aiAssistant.mcpEndpoint": "http://localhost:8000/mcp",
       "aiAssistant.rulesDir": "${workspaceFolder}/agentic-rules/docs"
     }
     ```

2. **Task & Launch Configuration**

   * Copy `examples/sample-workflow.vscode.json` into your project’s `.vscode/` folder.
   * It defines tasks for:

     * Running a local MCP server.
     * Linting/Formatting according to rule docs.
     * Deploying to HyperScaler using CLI commands.

3. **Agentic Prompts**

   * Whenever you open an issue or create a PR in VS Code’s GitHub integration panel, your AI extension can fetch “LLM Prompts” directly from `docs/Agentic-Prompts-Library.md`.
   * Example: invoke a command “Fetch Next MVP Issue” to let the agent highlight the top GitHub Issue.

### IntelliJ IDEA / WebStorm

1. **Install an AI Assistant Plugin**

   * Examples:

     * “Tabnine Enterprise” (supports custom rule integration)
     * “CodeWhisperer” (with prompt customization)
   * In **Settings → Tools → AI Assistant**, set:

     ```
     MCP Endpoint: http://localhost:8000/mcp  
     Rules Directory: <path>/agentic-rules/docs
     ```

2. **File Watchers & Live Templates**

   * Use **Live Templates** to insert standardized MCP snippets (e.g., marking an issue “in progress”).
   * Copy `examples/mcp-snippet.yaml` into your project and reference it in **File Watchers** so that certain keywords (like `@MCP:StartIssue`) auto-expand to the full YAML.

3. **CI/CD Integration**

   * Use **Run Configurations** for “Deploy MVP Function.”
   * Follow instructions in `docs/HyperScaler-Integration-Guide.md` to set up Environment variables and service endpoints.

### Other Agentic-Enabled IDEs

* **Cursor, Windsurf, Augment, Tessl** (with community LLM/agent plugins):

  1. Configure your plugin’s “prompt library path” to `/agentic-rules/docs/`.
  2. Provide MCP endpoint in plugin settings.
* **Cloud-Based Editors** (GitHub Codespaces, Gitpod):

  1. Mount this repository into your codespace (e.g., via a `git submodule`).
  2. Set environment variable `MCP_RULES_PATH=/workspaces/agentic-rules/docs`.
  3. Agent processes and enforces rules in real time.

---

## Documentation & Rule Sets

### Core “MVP-Focused” Rules

File: `docs/MVP-Focused-Rules.md`

* **Backlog Management** (GitHub Issues + MCP)
* **Minimal TDD/BDD** (single-file functions, HyperScaler SDK calls)
* **MVP CI/CD** (GitHub Actions for functions)
* **Branch & Naming Conventions** (`feature/mvp-*`)

### Full “XP-Oriented” Coding Standards

File: `docs/Full-Coding-Standards.md`

* **Comprehensive Backlog Workflows** (labels: `feature`, `bug`, `chore`)
* **Detailed TDD/BDD Practices** (unit, integration, functional tests)
* **CI/CD Pipelines** (multi-stage, staging→production)
* **Code Style & Security** (type annotations, static analysis tools)

### HyperScaler Integration Guide

File: `docs/HyperScaler-Integration-Guide.md`

* Walkthroughs for AWS, Azure, GCP:

  1. **Compute** (EC2, App Service, Cloud Run)
  2. **Functions** (AWS Lambda, Azure Functions, GCP Cloud Functions)
  3. **Storage** (S3, Blob Storage, Cloud Storage)
* **Terraform templates** (`deploy-function-template.tf`) for quick provisioning.
* **Example CLI commands** for deployment, environment management, and secret injection.

### Example MCP Scripts

File: `docs/Example-MCP-Scripts.md`

* YAML/JSON templates for:

  * Mark issue “in progress”
  * Post a failing-test comment
  * Annotate code coverage results
  * Close or transition issues upon merge
* Sample binds for both AINative “Cody” and generic MCP clients.

### Agentic Prompts Library

File: `docs/Agentic-Prompts-Library.md`

* Curated LLM prompts for each step:

  * **Backlog fetching / classification**
  * **Test scaffolding**
  * **Refactoring suggestions**
  * **CI/CD YAML generation**
  * **Rollback and monitoring scripts**

---

## Contributing Guidelines

If you’d like to suggest a new rule, update an existing one, or add an example for a new IDE:

1. **Fork the repository** and create a feature branch (`git checkout -b update-rule-xyz`).
2. **Modify or create** Markdown files under `docs/`.
3. **Add examples** under `examples/` (if applicable).
4. **Update** `CONTRIBUTING.md` with any new instructions for your change.
5. **Submit a Pull Request**, describing:

   * What was changed or added.
   * How it integrates with MCP or agentic workflows.
   * Any usage examples.

Reviewers (Cody or human maintainers) will verify the new rules, run through sample workflows, and merge.

---

## Versioning & Releases

This repository follows **Semantic Versioning** (MAJOR.MINOR.PATCH). Release tags appear as `v1.0.0`, `v1.1.0`, etc. Each release includes:

* Updated rule documents in `docs/`.
* New examples or templates in `examples/`.
* Changelog entries summarizing additions/fixes.

Use GitHub Releases to track major changes, new IDE integrations, or protocol updates.

---

## License

This repository is licensed under the **MIT License**. See [LICENSE](LICENSE) for full details.

---

**Happy Agentic Development!**
Empower your AI assistants (Cody, Copilot, TabNine, etc.) to enforce these rules automatically and accelerate your MVP and full-scale software delivery.
