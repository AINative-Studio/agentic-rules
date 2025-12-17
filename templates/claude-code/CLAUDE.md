# {{PROJECT_NAME}}

## Overview
{{PROJECT_DESCRIPTION}}

## Tech Stack
- **Framework**: {{FRAMEWORK}}
- **Language**: {{LANGUAGE}}
- **Package Manager**: {{PACKAGE_MANAGER}}
- **Testing**: {{TEST_FRAMEWORK}}

## Development Workflow

### Getting Started
```bash
{{INSTALL_COMMAND}}
{{DEV_COMMAND}}
```

The dev server runs at: http://localhost:{{PORT}}

### TDD Red-Green-Refactor Workflow
1. **Red**: Write a failing test first
2. **Green**: Write minimal code to make the test pass
3. **Refactor**: Clean up code while keeping tests green

### Branch Naming Convention
- `feature/{issue-number}-{short-description}` - New features
- `bugfix/{issue-number}-{short-description}` - Bug fixes
- `chore/{issue-number}-{short-description}` - Maintenance tasks

### Pre-Commit Checklist
Before committing, ensure:
- [ ] All tests pass (`{{TEST_COMMAND}}`)
- [ ] Linting passes (`{{LINT_COMMAND}}`)
- [ ] Build succeeds (`{{BUILD_COMMAND}}`)
- [ ] No console.log or debug statements
- [ ] Types are properly annotated

### Pull Request Process
1. Create feature branch from `{{DEFAULT_BRANCH}}`
2. Make changes following TDD workflow
3. Push branch and create PR
4. Ensure CI checks pass
5. Request review and address feedback
6. Squash and merge when approved

## Project Structure
```
{{PROJECT_STRUCTURE}}
```

## Key Directories
- `{{SOURCE_DIR}}/` - Source code
- `{{TEST_DIR}}/` - Test files
- `{{CONFIG_DIR}}/` - Configuration files

## Environment Variables
Copy `.env.example` to `.env.local` and configure:
```
{{ENV_VARS}}
```

## Architecture Patterns
{{ARCHITECTURE_NOTES}}

## Important Notes
{{ADDITIONAL_NOTES}}
