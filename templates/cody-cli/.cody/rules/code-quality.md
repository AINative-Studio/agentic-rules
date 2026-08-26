## Code Quality Standards

- **Naming**: camelCase for vars/functions, PascalCase for classes/types, UPPER_SNAKE_CASE for constants
- **Indentation**: 4 spaces, target <= 80 chars per line
- **Comments**: Only when the WHY is non-obvious — hidden constraints, workarounds, surprising behavior
- **Security**: Never log secrets/PII, validate inputs at system boundaries, least privilege
- **Errors**: Explicit error types, structured logs, actionable messages
- **No dead code**: Remove unused imports, variables, and functions — don't comment them out
- **No premature abstraction**: Three similar lines is better than a helper nobody needs yet
