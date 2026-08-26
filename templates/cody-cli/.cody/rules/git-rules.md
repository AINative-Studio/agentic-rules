## Git & PR Standards — ZERO TOLERANCE

### Forbidden in ALL commits, PRs, issues, and code comments

- "Claude", "Anthropic", "ChatGPT", "Copilot", "OpenAI"
- "Co-Authored-By" referencing any AI tool
- "Generated with [tool]", "AI-generated", "AI-assisted"
- Any emoji followed by "Generated with" or "Powered by"

### Commit format

Clean conventional commits — describe what and why, not which tool was used.

```
feat: add multi-dimension vector support

- Support for 384, 768, 1024, and 1536 dimensions
- Update validation logic
- Add test coverage
```

### PR standards

- Keep PRs under 300 LOC when possible
- Include summary, test plan, and related issue reference
- No AI branding or attribution anywhere in the description
