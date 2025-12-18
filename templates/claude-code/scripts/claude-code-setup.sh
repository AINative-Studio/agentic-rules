#!/bin/bash
#
# Claude Code Agentic Development Setup Script
# Configures MCP servers, custom agents, and persistent memory
#
# Usage: ./claude-code-setup.sh [--check | --install | --agents-only | --mcp-only]
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CLAUDE_DIR="$HOME/.claude"
CLAUDE_JSON="$HOME/.claude.json"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MERGED_PERMISSIONS="$SCRIPT_DIR/merged-permissions.json"

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# ============================================================================
# Check Functions
# ============================================================================

check_claude_installed() {
    if command -v claude &> /dev/null; then
        local version=$(claude --version 2>/dev/null | head -1)
        print_success "Claude Code installed: $version"
        return 0
    else
        print_error "Claude Code not installed"
        echo "  Install: npm install -g @anthropic-ai/claude-code"
        return 1
    fi
}

check_directories() {
    print_header "Directory Structure"

    local dirs=(
        "$CLAUDE_DIR"
        "$CLAUDE_DIR/agents"
        "$CLAUDE_DIR/commands"
        "$CLAUDE_DIR/plugins"
    )

    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            local count=$(ls -1 "$dir" 2>/dev/null | wc -l)
            print_success "$dir ($count items)"
        else
            print_warning "$dir (missing)"
        fi
    done
}

check_config_files() {
    print_header "Configuration Files"

    if [ -f "$CLAUDE_JSON" ]; then
        print_success "~/.claude.json exists"

        # Check for MCP servers
        local mcp_count=$(cat "$CLAUDE_JSON" | jq '.mcpServers | keys | length' 2>/dev/null || echo "0")
        print_info "  MCP servers configured: $mcp_count"
    else
        print_warning "~/.claude.json missing"
    fi

    if [ -f "$CLAUDE_DIR/settings.json" ]; then
        print_success "~/.claude/settings.json exists"
        cat "$CLAUDE_DIR/settings.json" | jq '.' 2>/dev/null | sed 's/^/  /'
    else
        print_warning "~/.claude/settings.json missing"
    fi
}

check_mcp_servers() {
    print_header "MCP Server Status"

    if command -v claude &> /dev/null; then
        claude mcp list 2>/dev/null | while read line; do
            if [[ "$line" == *"✓ Connected"* ]]; then
                print_success "$line"
            elif [[ "$line" == *"✗ Failed"* ]]; then
                print_error "$line"
            else
                echo "  $line"
            fi
        done
    else
        print_warning "Cannot check MCP servers - Claude not installed"
    fi
}

check_agents() {
    print_header "Custom Agents"

    if [ -d "$CLAUDE_DIR/agents" ]; then
        for agent in "$CLAUDE_DIR/agents"/*.md; do
            if [ -f "$agent" ]; then
                local name=$(basename "$agent" .md)
                local desc=$(grep -m1 "^description:" "$agent" 2>/dev/null | cut -d: -f2- | head -c 60)
                print_success "$name"
                [ -n "$desc" ] && echo "      ${desc}..."
            fi
        done
    else
        print_warning "No agents directory"
    fi
}

check_commands() {
    print_header "Custom Slash Commands"

    if [ -d "$CLAUDE_DIR/commands" ]; then
        local count=$(ls -1 "$CLAUDE_DIR/commands"/*.md 2>/dev/null | wc -l)
        print_success "$count custom commands available"

        # Group by prefix
        echo ""
        for prefix in memory vector table rlhf quantum event file project; do
            local pcount=$(ls -1 "$CLAUDE_DIR/commands"/${prefix}*.md 2>/dev/null | wc -l)
            [ "$pcount" -gt 0 ] && print_info "  /${prefix}-* : $pcount commands"
        done
    else
        print_warning "No commands directory"
    fi
}

check_environment() {
    print_header "Environment Variables"

    local vars=(
        "GITHUB_TOKEN"
        "ZERODB_API_URL"
        "ZERODB_USERNAME"
        "ZERODB_PROJECT_ID"
        "STRAPI_URL"
        "ANTHROPIC_API_KEY"
    )

    for var in "${vars[@]}"; do
        if [ -n "${!var}" ]; then
            # Mask the value
            local val="${!var}"
            local masked="${val:0:4}...${val: -4}"
            print_success "$var = $masked"
        else
            print_warning "$var not set"
        fi
    done
}

check_project_permissions() {
    print_header "Project Permissions"

    local project_settings=".claude/settings.local.json"

    if [ -f "$project_settings" ]; then
        local count=$(cat "$project_settings" | jq '.permissions.allow | length' 2>/dev/null || echo "0")
        print_success "$project_settings exists ($count permissions)"
    else
        print_warning "$project_settings not found in current directory"
        print_info "  Run with --init-project to create with common permissions"
    fi

    if [ -f "$MERGED_PERMISSIONS" ]; then
        local merged_count=$(cat "$MERGED_PERMISSIONS" | jq '.permissions.allow | length' 2>/dev/null || echo "0")
        print_info "Merged permissions template available ($merged_count permissions)"
    else
        print_warning "Merged permissions template not found at $MERGED_PERMISSIONS"
    fi
}

# ============================================================================
# Install Functions
# ============================================================================

create_directories() {
    print_header "Creating Directories"

    mkdir -p "$CLAUDE_DIR/agents"
    mkdir -p "$CLAUDE_DIR/commands"
    mkdir -p "$CLAUDE_DIR/plugins"

    print_success "Directory structure created"
}

create_settings() {
    print_header "Creating Settings"

    if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
        cat > "$CLAUDE_DIR/settings.json" << 'EOF'
{
  "alwaysThinkingEnabled": true
}
EOF
        print_success "Created settings.json with thinking enabled"
    else
        print_info "settings.json already exists"
    fi
}

install_mcp_github() {
    print_header "Installing GitHub MCP Server"

    if [ -z "$GITHUB_TOKEN" ]; then
        print_warning "GITHUB_TOKEN not set - skipping GitHub MCP"
        echo "  Set GITHUB_TOKEN in your shell profile"
        return
    fi

    claude mcp add --scope user github -- npx -y @modelcontextprotocol/server-github 2>/dev/null || true
    print_success "GitHub MCP server configured"
}

install_mcp_zerodb() {
    print_header "Installing ZeroDB MCP Server"

    echo "ZeroDB provides persistent memory for Claude Code."
    echo ""

    # Prompt for credentials if not set
    if [ -z "$ZERODB_USERNAME" ]; then
        read -p "ZeroDB Username (email): " ZERODB_USERNAME
    fi
    if [ -z "$ZERODB_PASSWORD" ]; then
        read -sp "ZeroDB Password: " ZERODB_PASSWORD
        echo ""
    fi
    if [ -z "$ZERODB_PROJECT_ID" ]; then
        read -p "ZeroDB Project ID: " ZERODB_PROJECT_ID
    fi

    # Add server with environment
    ZERODB_API_URL="${ZERODB_API_URL:-https://api.ainative.studio}"

    # Update claude.json directly since env vars need to be in config
    if [ -f "$CLAUDE_JSON" ]; then
        local tmp=$(mktemp)
        jq --arg url "$ZERODB_API_URL" \
           --arg user "$ZERODB_USERNAME" \
           --arg pass "$ZERODB_PASSWORD" \
           --arg proj "$ZERODB_PROJECT_ID" \
           '.mcpServers.zerodb = {
               "type": "stdio",
               "command": "npx",
               "args": ["-y", "ainative-zerodb-mcp-server"],
               "env": {
                   "ZERODB_API_URL": $url,
                   "ZERODB_USERNAME": $user,
                   "ZERODB_PASSWORD": $pass,
                   "ZERODB_PROJECT_ID": $proj
               }
           }' "$CLAUDE_JSON" > "$tmp" && mv "$tmp" "$CLAUDE_JSON"
        print_success "ZeroDB MCP server configured"
    else
        print_error "~/.claude.json not found - run 'claude' first to initialize"
    fi
}

install_mcp_strapi() {
    print_header "Installing Strapi MCP Servers"

    echo "Strapi servers enable CMS management from Claude Code."
    echo ""

    read -p "Strapi URL (e.g., https://cms.example.com): " STRAPI_URL
    read -p "Strapi Admin Email: " STRAPI_ADMIN_EMAIL
    read -sp "Strapi Admin Password: " STRAPI_ADMIN_PASSWORD
    echo ""

    if [ -f "$CLAUDE_JSON" ]; then
        local tmp=$(mktemp)
        jq --arg url "$STRAPI_URL" \
           --arg email "$STRAPI_ADMIN_EMAIL" \
           --arg pass "$STRAPI_ADMIN_PASSWORD" \
           '.mcpServers["ainative-strapi"] = {
               "type": "stdio",
               "command": "npx",
               "args": ["-y", "strapi-mcp"],
               "env": {
                   "STRAPI_URL": $url,
                   "STRAPI_ADMIN_EMAIL": $email,
                   "STRAPI_ADMIN_PASSWORD": $pass
               }
           } | .mcpServers["ainative-strapi-new"] = {
               "type": "stdio",
               "command": "npx",
               "args": ["-y", "ainative-strapi-mcp-server"],
               "env": {
                   "STRAPI_URL": $url,
                   "STRAPI_ADMIN_EMAIL": $email,
                   "STRAPI_ADMIN_PASSWORD": $pass
               }
           }' "$CLAUDE_JSON" > "$tmp" && mv "$tmp" "$CLAUDE_JSON"
        print_success "Strapi MCP servers configured"
    else
        print_error "~/.claude.json not found"
    fi
}

create_sample_agent() {
    local agent_file="$CLAUDE_DIR/agents/project-helper.md"

    if [ ! -f "$agent_file" ]; then
        cat > "$agent_file" << 'EOF'
---
name: project-helper
description: General project assistance agent for common development tasks
model: sonnet
---

You are a helpful development assistant focused on practical, efficient solutions.

## Capabilities
- Code review and suggestions
- Bug investigation and fixes
- Documentation improvements
- Refactoring recommendations

## Guidelines
- Keep solutions simple and focused
- Prefer editing existing code over creating new files
- Follow project conventions from CLAUDE.md
- Test changes before committing
EOF
        print_success "Created sample agent: project-helper"
    fi
}

install_project_permissions() {
    print_header "Installing Project Permissions"

    local project_settings=".claude/settings.local.json"

    if [ ! -f "$MERGED_PERMISSIONS" ]; then
        print_error "Merged permissions template not found at $MERGED_PERMISSIONS"
        return 1
    fi

    # Create .claude directory if needed
    mkdir -p .claude

    if [ -f "$project_settings" ]; then
        print_warning "Project permissions already exist"
        read -p "Overwrite with common permissions? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Keeping existing permissions"
            return 0
        fi
        # Backup existing
        cp "$project_settings" "${project_settings}.backup"
        print_info "Backed up existing to ${project_settings}.backup"
    fi

    # Copy merged permissions
    cp "$MERGED_PERMISSIONS" "$project_settings"
    local count=$(cat "$project_settings" | jq '.permissions.allow | length' 2>/dev/null || echo "0")
    print_success "Installed $count common permissions to $project_settings"
}

create_sample_commands() {
    # Memory store command
    local cmd_file="$CLAUDE_DIR/commands/memory-store.md"
    if [ ! -f "$cmd_file" ]; then
        cat > "$cmd_file" << 'EOF'
# Store Memory

Store a memory in ZeroDB for persistent context.

**Content**: $ARGUMENTS
**Role**: assistant

Use `mcp__zerodb__zerodb_store_memory` with metadata:
- type: category (code_pattern, project_context, etc.)
- project: current project name
- date: current date
EOF
        print_success "Created command: /memory-store"
    fi

    # Memory search command
    cmd_file="$CLAUDE_DIR/commands/memory-search.md"
    if [ ! -f "$cmd_file" ]; then
        cat > "$cmd_file" << 'EOF'
# Search Memory

Search stored memories in ZeroDB.

**Query**: $ARGUMENTS

Use `mcp__zerodb__zerodb_search_memory` to find relevant memories.
Return the top 5 results with their content and metadata.
EOF
        print_success "Created command: /memory-search"
    fi
}

# ============================================================================
# Main
# ============================================================================

main() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════════╗"
    echo "║          Claude Code Agentic Development Setup                    ║"
    echo "╚═══════════════════════════════════════════════════════════════════╝"
    echo ""

    case "${1:-}" in
        --check)
            check_claude_installed
            check_directories
            check_config_files
            check_mcp_servers
            check_agents
            check_commands
            check_environment
            check_project_permissions
            ;;
        --install)
            check_claude_installed || exit 1
            create_directories
            create_settings
            install_mcp_github
            install_mcp_zerodb
            install_mcp_strapi
            create_sample_agent
            create_sample_commands
            echo ""
            print_header "Installation Complete"
            print_info "Run './claude-code-setup.sh --check' to verify"
            print_info "Restart Claude Code for changes to take effect"
            ;;
        --init-project)
            install_project_permissions
            print_success "Project initialization complete"
            print_info "Common permissions installed to .claude/settings.local.json"
            ;;
        --agents-only)
            create_directories
            create_sample_agent
            print_success "Agent setup complete"
            ;;
        --mcp-only)
            check_claude_installed || exit 1
            install_mcp_github
            install_mcp_zerodb
            install_mcp_strapi
            print_success "MCP setup complete"
            ;;
        *)
            echo "Usage: $0 [--check | --install | --init-project | --agents-only | --mcp-only]"
            echo ""
            echo "Options:"
            echo "  --check        Check current configuration status"
            echo "  --install      Full installation (directories, MCP, agents)"
            echo "  --init-project Install common permissions to current project"
            echo "  --agents-only  Create sample agents only"
            echo "  --mcp-only     Configure MCP servers only"
            echo ""
            echo "Run --check first to see current status."
            ;;
    esac
}

main "$@"
