# Create Pull Request

Create a pull request for the current branch.

## Pre-PR Checklist

1. All tests pass (`bun test` or project test command)
2. Linting passes (if configured)
3. Build succeeds
4. Branch is pushed to remote
5. No AI attribution in commit messages or PR body

## PR Format

```markdown
## Summary
Brief description of what changed and why.

## Related Issue
Closes #{{ISSUE_NUMBER}}

## Changes
- Change 1
- Change 2

## Test Plan
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project style guidelines
- [ ] No secrets, PII, or AI attribution in diff
- [ ] No breaking changes (or documented)
```
