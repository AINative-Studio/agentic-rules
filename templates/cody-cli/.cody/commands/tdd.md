# TDD Workflow

Start a TDD (Test-Driven Development) workflow for: $ARGUMENTS

## Steps

1. **Understand**: Analyze the requirement and identify test cases
2. **Red**: Write failing tests that define expected behavior
3. **Green**: Implement minimal code to make tests pass
4. **Refactor**: Clean up while keeping tests green
5. **Commit**: Atomic commit for each red-green-refactor cycle

## Rules

- One test at a time, simplest case first
- Keep implementations minimal — no speculative features
- Refactor only when tests are green
- Use descriptive test names that read as behavior specifications
- Minimum 80% coverage before declaring done
- Run `bun test` (or project test command) after each step
