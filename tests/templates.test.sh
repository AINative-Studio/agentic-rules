#!/bin/bash
# Template validation tests
# Usage: bash tests/templates.test.sh
# Exit code 0 = all pass, 1 = failures

set -e

PASS=0
FAIL=0
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }

echo "Running template validation tests..."
echo ""

# --- Test 1: All template directories exist ---
echo "1. Template directory structure"
for dir in cody-cli claude-code cursor windsurf vscode gemini-cli; do
    if [ -d "$REPO_ROOT/templates/$dir" ]; then
        pass "templates/$dir/ exists"
    else
        fail "templates/$dir/ missing"
    fi
done

# --- Test 2: JSON templates are valid JSON ---
echo ""
echo "2. JSON syntax validation"
for f in $(find "$REPO_ROOT/templates" -name '*.json' -o -name '*.json.template' -o -name '*.json.example'); do
    if python3 -c "import json; json.load(open('$f'))" 2>/dev/null; then
        pass "$(basename $f) is valid JSON"
    else
        fail "$(basename $f) has invalid JSON"
    fi
done

# --- Test 3: No real secrets in templates ---
echo ""
echo "3. Secret detection"
SECRETS_FOUND=$(grep -rn 'sk_[a-zA-Z0-9]\{10,\}\|ghp_[a-zA-Z0-9]\{10,\}\|npm_[a-zA-Z0-9]\{10,\}' "$REPO_ROOT/templates/" 2>/dev/null | wc -l)
if [ "$SECRETS_FOUND" -eq 0 ]; then
    pass "No real API keys found in templates"
else
    fail "Found $SECRETS_FOUND potential secrets in templates"
fi

# --- Test 4: No personal email addresses ---
echo ""
echo "4. PII detection"
PII_FOUND=$(grep -rn '@gmail\.\|@yahoo\.\|@hotmail\.' "$REPO_ROOT/templates/" 2>/dev/null | wc -l)
if [ "$PII_FOUND" -eq 0 ]; then
    pass "No personal email addresses in templates"
else
    fail "Found $PII_FOUND personal emails in templates"
fi

# --- Test 5: Cody CLI template completeness ---
echo ""
echo "5. Cody CLI template completeness"
for f in CODY.md.template mcp.json.template settings.json.template env.example; do
    if [ -f "$REPO_ROOT/templates/cody-cli/$f" ]; then
        pass "cody-cli/$f exists"
    else
        fail "cody-cli/$f missing"
    fi
done

for f in code-quality.md git-rules.md testing.md security.md; do
    if [ -f "$REPO_ROOT/templates/cody-cli/.cody/rules/$f" ]; then
        pass "cody-cli/.cody/rules/$f exists"
    else
        fail "cody-cli/.cody/rules/$f missing"
    fi
done

# --- Test 6: Cursor/Windsurf rules files exist ---
echo ""
echo "6. IDE rule files"
for f in templates/cursor/.cursorrules templates/windsurf/.windsurfrules; do
    if [ -f "$REPO_ROOT/$f" ]; then
        pass "$f exists"
    else
        fail "$f missing"
    fi
done

# --- Test 7: Setup script is executable ---
echo ""
echo "7. Script permissions"
if [ -x "$REPO_ROOT/templates/cody-cli/scripts/setup.sh" ]; then
    pass "cody-cli setup.sh is executable"
else
    fail "cody-cli setup.sh is not executable"
fi

# --- Test 8: Required repo files exist ---
echo ""
echo "8. Repository health"
for f in README.md LICENSE CODE_OF_CONDUCT.md SUPPORT.md CLAUDE.md; do
    if [ -f "$REPO_ROOT/$f" ]; then
        pass "$f exists"
    else
        fail "$f missing"
    fi
done

# --- Summary ---
echo ""
echo "==============================="
echo "Results: $PASS passed, $FAIL failed"
echo "==============================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
