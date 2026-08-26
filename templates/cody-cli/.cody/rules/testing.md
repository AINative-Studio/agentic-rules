## Testing Standards (Mandatory)

- **TDD/BDD**: Write failing tests first, then implement, then refactor
- **Minimum coverage**: 80% for all new code
- **Style**: BDD `describe/it` blocks with clear behavior descriptions
- **Tests must pass** with proof of passing before any commit or PR
- **No mocking internals**: Test behavior, not implementation details
- **Edge cases**: Always cover null/undefined, empty collections, boundary values
- **Integration tests**: Required for API endpoints and external service calls
- **Deterministic**: Tests must not depend on time, randomness, or execution order
