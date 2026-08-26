#!/bin/bash
# Cody CLI Project Setup Script
# Usage: ./setup.sh [project-path]

set -e

PROJECT_PATH="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Setting up Cody CLI project at: $PROJECT_PATH"
echo ""

# Create .cody directory structure
mkdir -p "$PROJECT_PATH/.cody/rules"
mkdir -p "$PROJECT_PATH/.cody/agents"
mkdir -p "$PROJECT_PATH/.cody/commands"
echo -e "${GREEN}Created .cody/ directory structure${NC}"

# Copy rules
if [ -d "$TEMPLATE_DIR/.cody/rules" ]; then
    cp "$TEMPLATE_DIR/.cody/rules/"*.md "$PROJECT_PATH/.cody/rules/" 2>/dev/null || true
    echo -e "${GREEN}Copied rules to .cody/rules/${NC}"
fi

# Copy agents
if [ -d "$TEMPLATE_DIR/.cody/agents" ]; then
    cp "$TEMPLATE_DIR/.cody/agents/"*.md "$PROJECT_PATH/.cody/agents/" 2>/dev/null || true
    echo -e "${GREEN}Copied agents to .cody/agents/${NC}"
fi

# Copy commands
if [ -d "$TEMPLATE_DIR/.cody/commands" ]; then
    cp "$TEMPLATE_DIR/.cody/commands/"*.md "$PROJECT_PATH/.cody/commands/" 2>/dev/null || true
    echo -e "${GREEN}Copied commands to .cody/commands/${NC}"
fi

# Copy CODY.md if it doesn't exist
if [ ! -f "$PROJECT_PATH/CODY.md" ]; then
    cp "$TEMPLATE_DIR/CODY.md.template" "$PROJECT_PATH/CODY.md"
    echo -e "${GREEN}Created CODY.md${NC}"
else
    echo -e "${YELLOW}CODY.md already exists — skipping${NC}"
fi

# Copy MCP config
if [ ! -f "$PROJECT_PATH/.mcp.json" ]; then
    cp "$TEMPLATE_DIR/mcp.json.template" "$PROJECT_PATH/.mcp.json"
    echo -e "${GREEN}Created .mcp.json${NC}"
else
    echo -e "${YELLOW}.mcp.json already exists — skipping${NC}"
fi

# Copy settings
if [ ! -f "$PROJECT_PATH/.cody/settings.json" ]; then
    cp "$TEMPLATE_DIR/settings.json.template" "$PROJECT_PATH/.cody/settings.json"
    echo -e "${GREEN}Created .cody/settings.json${NC}"
else
    echo -e "${YELLOW}.cody/settings.json already exists — skipping${NC}"
fi

# Copy .env.example
if [ ! -f "$PROJECT_PATH/.env.example" ] && [ ! -f "$PROJECT_PATH/.env" ]; then
    cp "$TEMPLATE_DIR/env.example" "$PROJECT_PATH/.env.example"
    echo -e "${GREEN}Created .env.example${NC}"
fi

echo ""
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Edit CODY.md — replace {{PLACEHOLDER}} values with your project details"
echo "  2. Edit .mcp.json — add your ZERODB_API_KEY and GITHUB_TOKEN"
echo "  3. Copy .env.example to .env and configure credentials"
echo "  4. Run: cody (to start Cody CLI)"
