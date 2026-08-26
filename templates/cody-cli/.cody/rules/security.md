## Security Standards

- No real credentials in code, tests, configs, or screenshots
- Use `{{PLACEHOLDER}}` syntax in templates, test fixtures for secrets
- Validate all user input and external API responses at system boundaries
- Never log secrets, PII, or tokens — even in debug mode
- API keys use `sk_` prefix for AINative platform tokens
- Follow least-privilege: request only the permissions you need
- Redact sensitive fields before sending to analytics or external services
- Document threat considerations in PR descriptions when touching auth or data flows
