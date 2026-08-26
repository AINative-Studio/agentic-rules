# Code Review

Review the current diff against this checklist:

## Correctness
- [ ] Code accomplishes the intended purpose
- [ ] Edge cases handled (null, empty, boundaries)
- [ ] Error handling is appropriate and specific

## Security
- [ ] No hardcoded secrets or credentials
- [ ] Input validation at system boundaries
- [ ] No injection vulnerabilities (SQL, XSS, command)
- [ ] Auth/authz checks in place

## Quality
- [ ] Readable and self-documenting (good names, no unnecessary comments)
- [ ] No dead code, unused imports, or commented-out blocks
- [ ] DRY without premature abstraction
- [ ] Functions have single responsibility

## Testing
- [ ] Tests exist for new/changed behavior
- [ ] Tests cover edge cases
- [ ] Tests are deterministic

## Performance
- [ ] No obvious N+1 queries or unbounded loops
- [ ] No memory leaks (unclosed resources, growing caches)
