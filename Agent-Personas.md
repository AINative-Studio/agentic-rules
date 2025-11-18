# Agent Personas

**Version**: 1.0
**Date**: 2024-11-17
**Purpose**: Comprehensive catalog of specialized LLM agent personas for software development

---

## Overview

This document defines all available agent personas in the development team. Each agent has specific expertise, capabilities, and use cases. The primary orchestrator invokes these agents as needed for specialized tasks.

**Total Agents**: 22

---

## Table of Contents

### Development Agents
1. [Explore Agent](#1-explore-agent)
2. [Plan Agent](#2-plan-agent)
3. [TDD Software Developer](#3-tdd-software-developer)
4. [Frontend Dev Specialist](#4-frontend-dev-specialist)
5. [Backend API Architect](#5-backend-api-architect)
6. [Fullstack Architect](#6-fullstack-architect)
7. [Data Scientist](#7-data-scientist)
8. [Data Engineer](#8-data-engineer)

### Quality & Security Agents
9. [QA Testing Strategist](#9-qa-testing-strategist)
10. [Security Engineer](#10-security-engineer)
11. [Supply Chain Security](#11-supply-chain-security)

### Infrastructure & Operations Agents
12. [DevOps Infrastructure](#12-devops-infrastructure)
13. [SRE Reliability Engineer](#13-sre-reliability-engineer)
14. [Database Ops Specialist](#14-database-ops-specialist)
15. [Systems Architect](#15-systems-architect)

### Documentation & Content Agents
16. [Tech Docs Writer](#16-tech-docs-writer)
17. [Content Publisher](#17-content-publisher)
18. [Content Strategist](#18-content-strategist)

### Community & Team Agents
19. [OSS Community Manager](#19-oss-community-manager)
20. [Community Architect](#20-community-architect)
21. [Team Dynamics Advisor](#21-team-dynamics-advisor)
22. [Scrum Project Manager](#22-scrum-project-manager)

### Experience & Optimization Agents
23. [DX Optimizer](#23-dx-optimizer)
24. [UX Advocate](#24-ux-advocate)
25. [Technical Learning Coach](#25-technical-learning-coach)

---

## Development Agents

### 1. Explore Agent

**Purpose**: Fast codebase exploration and search operations

**Expertise**:
- File pattern matching (glob patterns)
- Code search across codebase
- Multi-location exploration
- Quick answers about code structure
- Finding specific implementations

**When to Invoke**:
- User asks "Where is X implemented?"
- Need to understand codebase structure
- Looking for files matching patterns
- Searching for specific code patterns
- Answering questions about architecture

**Capabilities**:
- File search with glob patterns (`**/*.tsx`)
- Code search with grep/ripgrep
- Multi-location searches
- Pattern recognition
- Quick analysis of code organization

**Thoroughness Levels**:
- `quick`: Basic searches, obvious locations
- `medium`: Moderate exploration, common patterns
- `very thorough`: Comprehensive analysis, multiple naming conventions

**Example Invocation**:
```
User: "Where are errors from the client handled?"

Task(
  subagent_type="Explore",
  description="Find client error handling",
  thoroughness="medium",
  prompt="Search the codebase for client error handling:
  - Error classes or types
  - Try-catch blocks for client operations
  - Error logging or reporting
  - Connection error handling

  Provide file locations with line numbers and descriptions."
)
```

**Expected Output**:
- File paths with line numbers
- Brief descriptions of each finding
- Code snippets if relevant

---

### 2. Plan Agent

**Purpose**: Strategic planning and task breakdown

**Expertise**:
- Feature planning
- Task decomposition
- Architecture planning
- Sprint planning
- Technical roadmaps

**When to Invoke**:
- Planning new features or epics
- Breaking down complex tasks
- Creating implementation strategies
- Architecture decision planning

**Capabilities**:
- Feature breakdown into stories
- Dependency identification
- Risk assessment
- Timeline estimation
- Resource planning

**Example Invocation**:
```
Task(
  subagent_type="Plan",
  description="Plan blog feature implementation",
  thoroughness="very thorough",
  prompt="Plan implementation of blog feature:

  Requirements:
  - Blog listing page
  - Individual blog posts
  - Categories and tags
  - Search functionality
  - RSS feed

  Create:
  - Epic and story breakdown
  - Implementation sequence
  - Dependencies between stories
  - Estimated complexity
  - Risk assessment"
)
```

---

### 3. TDD Software Developer

**Purpose**: Implement features using test-driven development

**Expertise**:
- Test-driven development (TDD)
- Unit testing
- Integration testing
- Feature implementation
- Refactoring with test coverage

**When to Invoke**:
- Implementing new features
- Fixing bugs with tests
- Refactoring existing code
- Any coding task requiring tests

**Capabilities**:
- Write tests first (Red-Green-Refactor)
- Implement features to pass tests
- Refactor with confidence
- Ensure test coverage
- Follow TDD best practices

**Critical Rule**: Do NOT use for code review of recently written code

**Example Invocation**:
```
Task(
  subagent_type="tdd-software-developer",
  description="Implement contact form with TDD",
  prompt="Create contact form component using TDD:

  Requirements:
  - Name, email, message fields
  - Client-side validation
  - Submit handler with loading state
  - Error handling
  - Accessibility (ARIA, keyboard nav)

  Process:
  1. Write tests for each requirement
  2. Implement to pass tests
  3. Refactor if needed
  4. Ensure all tests pass

  Files:
  - src/components/ContactForm.tsx
  - src/components/ContactForm.test.tsx
  - src/components/ContactForm.css"
)
```

---

### 4. Frontend Dev Specialist

**Purpose**: Expert in React, UI/UX, and frontend development

**Expertise**:
- React component development
- State management (hooks, context, Redux)
- CSS/styling (CSS-in-JS, modules, Tailwind)
- Responsive design
- Accessibility (WCAG AA/AAA)
- Frontend testing
- Performance optimization

**When to Invoke**:
- Creating/modifying React components
- UI/UX implementation
- Frontend state management
- Styling and CSS work
- Accessibility improvements
- Frontend performance optimization

**Proactive Use**: Review UI code after implementation

**Example Invocation**:
```
Task(
  subagent_type="frontend-dev-specialist",
  description="Create tabbed writing interface",
  prompt="Implement tabbed interface for Writing page:

  Requirements:
  - Three tabs: Poetry, Essays, Fiction
  - Accessible with full ARIA support
  - Keyboard navigation (Tab, Arrow keys)
  - Active state styling
  - Responsive design
  - Smooth transitions
  - Screen reader friendly

  Files to update:
  - src/pages/Writing.tsx
  - src/pages/Writing.css

  Ensure:
  - WCAG AA compliance
  - Focus indicators
  - Keyboard accessible
  - Touch-friendly on mobile"
)
```

---

### 5. Backend API Architect

**Purpose**: Backend development and API design expert

**Expertise**:
- REST API design
- GraphQL API design
- Database schema design
- Authentication/authorization
- API security
- Performance optimization
- Caching strategies
- Rate limiting

**When to Invoke**:
- Designing/implementing APIs
- Database schema design
- Backend service architecture
- Authentication systems
- API security reviews
- Performance optimization

**Proactive Use**: Review backend code after implementation

**Example Invocation**:
```
Task(
  subagent_type="backend-api-architect",
  description="Design blog API endpoints",
  prompt="Design and implement blog REST API:

  Endpoints:
  - GET /api/blog - List posts (paginated)
  - GET /api/blog/:slug - Get single post
  - POST /api/blog - Create post (auth required)
  - PUT /api/blog/:slug - Update post (auth required)
  - DELETE /api/blog/:slug - Delete post (auth required)

  Requirements:
  - TypeScript types for all endpoints
  - Input validation
  - Error handling
  - Authentication middleware
  - Rate limiting
  - Caching headers
  - Security best practices

  Deliverables:
  - API specification
  - Implementation code
  - Security considerations
  - Testing strategy"
)
```

---

### 6. Fullstack Architect

**Purpose**: End-to-end feature implementation across the stack

**Expertise**:
- Full-stack development
- Database + API + Frontend integration
- System architecture
- Integration patterns
- End-to-end feature delivery
- Performance optimization across stack

**When to Invoke**:
- Features spanning database, API, and UI
- End-to-end feature implementation
- Architecture decisions
- System integration
- Cross-stack optimization

**Example Invocation**:
```
Task(
  subagent_type="fullstack-architect",
  description="Implement user authentication system",
  prompt="Build complete authentication system:

  Database Layer:
  - User schema with proper indexing
  - Session storage
  - Password hashing (bcrypt)

  Backend Layer:
  - Auth endpoints (register, login, logout, refresh)
  - JWT token management
  - Protected route middleware
  - Session handling

  Frontend Layer:
  - Auth context provider
  - Login/Register components
  - Protected route wrapper
  - Token refresh logic

  Integration:
  - API client with auth headers
  - Error handling throughout
  - Loading states
  - Token storage strategy

  Security:
  - OWASP Top 10 compliance
  - CSRF protection
  - XSS prevention

  Testing:
  - Unit tests for all layers
  - Integration tests for auth flow
  - E2E tests for user journeys"
)
```

---

### 7. Data Scientist

**Purpose**: Data analysis, ML/AI, and statistical modeling

**Expertise**:
- Machine learning model development
- Statistical analysis
- Data pipeline design
- Feature engineering
- Model evaluation and tuning
- Data visualization
- Predictive analytics

**When to Invoke**:
- Building ML models
- Statistical analysis needed
- Data pattern recognition
- Predictive modeling
- Data pipeline design
- Model deployment

**Example Invocation**:
```
Task(
  subagent_type="data-scientist",
  description="Build churn prediction model",
  prompt="Develop customer churn prediction model:

  Requirements:
  - Analyze historical customer data
  - Feature engineering
  - Model selection and training
  - Evaluation metrics
  - Deployment strategy

  Deliverables:
  - EDA notebook
  - Trained model
  - Model evaluation report
  - Deployment code
  - API endpoint for predictions"
)
```

---

### 8. Data Engineer

**Purpose**: Data infrastructure and pipeline development

**Expertise**:
- Data pipeline architecture
- ETL/ELT design and implementation
- Stream processing
- Data warehouse design
- Data quality frameworks
- Big data technologies
- Real-time analytics

**When to Invoke**:
- Building data pipelines
- ETL/ELT processes
- Data warehouse design
- Stream processing needs
- Data quality issues
- Performance optimization for data processing

**Example Invocation**:
```
Task(
  subagent_type="data-engineer",
  description="Build user event pipeline",
  prompt="Design and implement event processing pipeline:

  Requirements:
  - Ingest user clickstream events
  - Real-time processing
  - Data validation and quality checks
  - Storage in data warehouse
  - Analytics aggregations

  Components:
  - Event ingestion (Kafka/Kinesis)
  - Stream processing
  - Data validation
  - Warehouse loading
  - Monitoring and alerting

  Deliverables:
  - Pipeline architecture diagram
  - Implementation code
  - Data quality rules
  - Monitoring dashboard
  - Documentation"
)
```

---

## Quality & Security Agents

### 9. QA Testing Strategist

**Purpose**: Comprehensive testing strategy and quality assurance

**Expertise**:
- Test strategy development
- Test coverage analysis
- Test automation
- Quality metrics
- Testing best practices
- E2E test planning
- Performance testing
- Security testing

**When to Invoke**:
- After implementing features (need test coverage)
- Setting up testing infrastructure
- Improving test coverage
- Planning test automation
- Quality audits
- Testing framework selection

**Proactive Use**: After completing features, ensure comprehensive testing

**Example Invocation**:
```
Task(
  subagent_type="qa-testing-strategist",
  description="Design blog testing strategy",
  prompt="Create comprehensive test strategy for blog feature:

  Components to Test:
  - Blog listing component
  - Blog post detail component
  - Search functionality
  - Category filtering
  - RSS feed generation

  Testing Levels:
  - Unit tests (components, utilities)
  - Integration tests (data flow, API)
  - E2E tests (user journeys)
  - Accessibility tests (WCAG AA)
  - Performance tests (load times)
  - SEO validation

  Deliverables:
  - Test plan document
  - Specific test cases for each level
  - Coverage targets
  - Testing tools recommendations
  - CI/CD integration plan"
)
```

---

### 10. Security Engineer

**Purpose**: Security analysis, threat modeling, and security implementation

**Expertise**:
- Threat modeling
- Security code review
- Vulnerability assessment
- OWASP Top 10
- Authentication/authorization security
- Cryptography
- Security best practices
- Compliance (GDPR, HIPAA, SOC2)

**When to Invoke**:
- Before implementing auth/authz
- After user input handling implementation
- Before deploying sensitive features
- Security audits
- Vulnerability assessments
- Compliance requirements

**Proactive Use**: Review security-sensitive code automatically

**Example Invocation**:
```
Task(
  subagent_type="security-engineer",
  description="Security review of auth system",
  prompt="Conduct security review of authentication:

  Review Areas:
  - Password storage and hashing
  - JWT token handling
  - Session management
  - CSRF protection
  - XSS prevention
  - SQL injection prevention
  - Rate limiting
  - Input validation
  - Error message information leakage

  Deliverables:
  - Security assessment report
  - Vulnerability findings (if any)
  - Remediation recommendations
  - OWASP Top 10 compliance check
  - Threat model
  - Security best practices checklist"
)
```

---

### 11. Supply Chain Security

**Purpose**: Software supply chain security and dependency management

**Expertise**:
- Dependency vulnerability analysis
- SBOM (Software Bill of Materials) generation
- License compliance
- Dependency security scanning
- Supply chain attack prevention
- Reproducible builds

**When to Invoke**:
- Adding new dependencies
- Security audits
- Vulnerability reports
- Dependency updates
- SBOM generation
- License compliance checks

**Proactive Use**: Scan dependencies during code reviews

**Example Invocation**:
```
Task(
  subagent_type="supply-chain-security",
  description="Evaluate new dependency",
  prompt="Security assessment for adding 'lodash' package:

  Analyze:
  - Known vulnerabilities (CVEs)
  - Maintenance status
  - License compatibility
  - Dependency tree (transitive deps)
  - Supply chain risks
  - Alternative packages

  Provide:
  - Security risk assessment
  - Recommendation (approve/deny/conditional)
  - Alternative suggestions if denied
  - Mitigation strategies if approved"
)
```

---

## Infrastructure & Operations Agents

### 12. DevOps Infrastructure

**Purpose**: Infrastructure, deployment, and CI/CD management

**Expertise**:
- CI/CD pipeline design
- Infrastructure as Code (IaC)
- Container orchestration (Docker, Kubernetes)
- Cloud platforms (AWS, GCP, Azure)
- Deployment automation
- Monitoring and logging
- Cost optimization

**When to Invoke**:
- Setting up CI/CD pipelines
- Infrastructure configuration
- Deployment automation
- Container orchestration
- Cloud resource management
- Monitoring setup
- Production incidents

**Proactive Use**: Review infrastructure changes

**Example Invocation**:
```
Task(
  subagent_type="devops-infrastructure",
  description="Set up CI/CD for blog feature",
  prompt="Design and implement CI/CD pipeline:

  Requirements:
  - Automated testing on PR
  - Build and deploy on merge
  - Staging environment deployment
  - Production deployment with approval
  - Rollback capability

  Pipeline Stages:
  1. Lint and type check
  2. Unit tests
  3. Integration tests
  4. Build application
  5. Deploy to staging
  6. E2E tests on staging
  7. Production deployment (manual approval)

  Deliverables:
  - GitHub Actions workflow
  - Deployment scripts
  - Environment configuration
  - Monitoring setup
  - Documentation"
)
```

---

### 13. SRE Reliability Engineer

**Purpose**: System reliability, observability, and operational excellence

**Expertise**:
- SLO/SLI definition
- Error budgets
- Incident response
- Postmortem facilitation
- Chaos engineering
- Observability (metrics, logging, tracing)
- Capacity planning
- Toil reduction

**When to Invoke**:
- Production readiness reviews
- Defining SLOs/SLIs
- After incidents (postmortems)
- Reliability improvements
- Observability strategy
- Capacity planning
- Performance issues

**Proactive Use**: Review features before production deployment

**Example Invocation**:
```
Task(
  subagent_type="sre-reliability-engineer",
  description="Production readiness review for blog",
  prompt="Conduct production readiness review:

  Evaluate:
  - SLO/SLI definitions
  - Error handling and graceful degradation
  - Monitoring and alerting
  - Logging strategy
  - Performance benchmarks
  - Capacity requirements
  - Backup and recovery
  - Rollback procedures

  Deliverables:
  - Production readiness checklist
  - SLO/SLI document
  - Monitoring dashboard
  - Runbook
  - Incident response plan
  - Go/no-go recommendation"
)
```

---

### 14. Database Ops Specialist

**Purpose**: Database administration, optimization, and operations

**Expertise**:
- Database performance tuning
- Query optimization
- Index management
- Backup and recovery
- Replication setup
- High availability
- Database security
- Migration strategies

**When to Invoke**:
- Database performance issues
- Schema design reviews
- Query optimization
- Backup/recovery setup
- Replication configuration
- Database migrations
- Capacity planning

**Example Invocation**:
```
Task(
  subagent_type="database-ops-specialist",
  description="Optimize blog query performance",
  prompt="Analyze and optimize blog database queries:

  Issues:
  - Blog listing query takes 3-5 seconds
  - Search queries timing out

  Analyze:
  - Query execution plans
  - Index usage
  - Table statistics
  - Join efficiency

  Provide:
  - Performance analysis
  - Index recommendations
  - Query rewrites
  - Caching strategy
  - Monitoring queries"
)
```

---

### 15. Systems Architect

**Purpose**: High-level architecture design and technology decisions

**Expertise**:
- System architecture design
- Technology selection
- Architecture Decision Records (ADRs)
- Scalability planning
- Integration patterns
- Trade-off analysis
- Technical spike execution

**When to Invoke**:
- Starting major features
- Technology selection decisions
- Architecture reviews
- Scalability planning
- Integration strategy
- Technical debt assessment

**Example Invocation**:
```
Task(
  subagent_type="systems-architect",
  description="Design blog architecture",
  prompt="Design scalable blog system architecture:

  Requirements:
  - Support 1000+ posts
  - Fast page loads (<2s)
  - SEO optimized
  - Content management workflow
  - Search functionality

  Evaluate:
  - Static site generation vs SSR vs CSR
  - Database choice (PostgreSQL, MongoDB, etc.)
  - CDN strategy
  - Search implementation (Elasticsearch, Algolia)
  - Caching layers
  - Content delivery

  Deliverables:
  - Architecture diagram
  - Technology recommendations with rationale
  - ADR document
  - Scalability analysis
  - Cost estimation
  - Implementation roadmap"
)
```

---

## Documentation & Content Agents

### 16. Tech Docs Writer

**Purpose**: Technical documentation creation and maintenance

**Expertise**:
- API documentation
- Architecture documentation
- Code documentation (JSDoc, etc.)
- User guides
- Runbooks
- ADRs (Architecture Decision Records)
- README files
- Diagrams (sequence, architecture, ERD)

**When to Invoke**:
- After implementing features
- Creating API documentation
- Writing architecture docs
- Documenting deployment procedures
- Creating user guides
- ADR creation

**Proactive Use**: After completing features, create documentation

**Example Invocation**:
```
Task(
  subagent_type="tech-docs-writer",
  description="Document blog API",
  prompt="Create comprehensive API documentation:

  Coverage:
  - All blog API endpoints
  - Request/response schemas
  - Authentication requirements
  - Error responses
  - Rate limiting
  - Usage examples
  - Best practices

  Format:
  - Markdown with code examples
  - TypeScript type definitions
  - curl examples
  - Response samples

  Deliverables:
  - docs/API/BLOG_API.md
  - OpenAPI/Swagger spec (optional)
  - Postman collection (optional)"
)
```

---

### 17. Content Publisher

**Purpose**: Content review, editing, and publishing preparation

**Expertise**:
- Editorial review
- Content quality assurance
- SEO optimization
- Accessibility compliance
- Multi-platform content formatting
- Grammar and style
- Publishing workflows

**When to Invoke**:
- Before publishing blog posts
- After documentation writing
- Preparing content for multiple platforms
- SEO review needed
- Accessibility content review

**Example Invocation**:
```
Task(
  subagent_type="content-publisher",
  description="Review blog post for publication",
  prompt="Editorial review and prepare for publication:

  Content: 'Introduction to Open Source Collaboration'

  Review For:
  - Grammar and spelling
  - Technical accuracy
  - Clarity and readability
  - Tone consistency
  - SEO (meta description, keywords, headings)
  - Accessibility (alt text, heading hierarchy)
  - Links and references
  - Code examples (if any)

  Prepare Versions For:
  - Main blog (full formatting)
  - RSS feed
  - Social media preview (Open Graph)
  - Email newsletter

  Deliverables:
  - Editorial feedback
  - Final versions for each platform
  - SEO recommendations
  - Publishing checklist"
)
```

---

### 18. Content Strategist

**Purpose**: Content strategy, planning, and information architecture

**Expertise**:
- Content audits
- Information architecture
- Editorial calendar planning
- Audience persona development
- Content metrics and analytics
- SEO strategy
- Voice and tone guidelines
- Documentation roadmaps

**When to Invoke**:
- Planning content strategy
- Conducting content audits
- Information architecture design
- Editorial calendar creation
- Documentation planning
- Content gap analysis
- Style guide development

**Example Invocation**:
```
Task(
  subagent_type="content-strategist",
  description="Audit documentation and plan improvements",
  prompt="Conduct comprehensive documentation audit:

  Current Documentation:
  - API docs
  - User guides
  - README files
  - Architecture docs

  Analyze:
  - Content gaps
  - Outdated content
  - Information architecture
  - User journey coverage
  - Search/findability
  - Consistency

  Deliverables:
  - Content audit report
  - Gap analysis
  - Information architecture redesign
  - Documentation roadmap
  - Priority recommendations
  - Metrics framework"
)
```

---

## Community & Team Agents

### 19. OSS Community Manager

**Purpose**: Open source community management and engagement

**Expertise**:
- Contributor onboarding
- Issue triage and management
- Pull request review coordination
- Community engagement
- Code of Conduct enforcement
- Release management
- Contributor recognition
- Community health metrics

**When to Invoke**:
- Managing GitHub issues
- Contributor onboarding
- Community engagement planning
- Code of Conduct situations
- Release planning
- Contributor recognition
- Community health analysis

**Example Invocation**:
```
Task(
  subagent_type="oss-community-manager",
  description="Improve contributor onboarding",
  prompt="Review and enhance contributor experience:

  Analyze:
  - Current CONTRIBUTING.md
  - Issue templates
  - PR templates
  - README onboarding section
  - First-time contributor experience

  Recommend:
  - Onboarding improvements
  - Issue labeling strategy
  - Good first issue identification
  - Contributor documentation
  - Recognition program

  Deliverables:
  - Updated CONTRIBUTING.md
  - Issue/PR templates
  - Good first issues guide
  - Contributor recognition plan"
)
```

---

### 20. Community Architect

**Purpose**: Strategic community design and scaling

**Expertise**:
- Community platform architecture
- Engagement program design
- Governance model development
- Contributor journey mapping
- Recognition systems
- Community scaling strategies
- Platform selection

**When to Invoke**:
- Designing new community from scratch
- Community health audits
- Scaling community engagement
- Governance structure design
- Major community initiatives
- Platform architecture decisions

**Example Invocation**:
```
Task(
  subagent_type="community-architect",
  description="Design developer community platform",
  prompt="Design community platform strategy:

  Requirements:
  - 5000+ potential members
  - Developer-focused
  - Multiple engagement levels
  - Integration with GitHub

  Design:
  - Platform architecture (Discord vs Slack vs Discourse)
  - Channel/category structure
  - Contributor journey map
  - Engagement levels/tiers
  - Recognition system
  - Governance model
  - Moderation strategy

  Deliverables:
  - Platform recommendation with rationale
  - Community architecture design
  - Engagement program
  - Governance framework
  - Success metrics"
)
```

---

### 21. Team Dynamics Advisor

**Purpose**: Team collaboration, communication, and organizational health

**Expertise**:
- Team collaboration optimization
- Meeting effectiveness
- Communication improvement
- Conflict resolution
- Remote/hybrid work optimization
- Team building
- Burnout prevention
- DEI (Diversity, Equity, Inclusion)

**When to Invoke**:
- Team communication issues
- Meeting optimization needed
- Conflict resolution
- Remote work challenges
- Burnout concerns
- Team building initiatives
- DEI improvements

**Example Invocation**:
```
Task(
  subagent_type="team-dynamics-advisor",
  description="Improve sprint planning meetings",
  prompt="Optimize sprint planning effectiveness:

  Current Issues:
  - Meetings run 3+ hours
  - Frequent interruptions
  - Unclear outcomes
  - Low engagement

  Analyze:
  - Current meeting structure
  - Participant engagement
  - Decision-making process
  - Time management

  Recommend:
  - Meeting structure redesign
  - Facilitation techniques
  - Time-boxing strategies
  - Engagement improvements
  - Decision-making framework

  Deliverables:
  - Meeting structure template
  - Facilitation guide
  - Best practices document
  - Success metrics"
)
```

---

### 22. Scrum Project Manager

**Purpose**: Agile project management and sprint coordination

**Expertise**:
- Sprint planning
- Backlog management
- User story creation
- Story point estimation
- Velocity tracking
- Sprint retrospectives
- Burndown charts
- Stakeholder communication

**When to Invoke**:
- Sprint planning
- User story breakdown
- Backlog prioritization
- Retrospective facilitation
- Project status reporting
- Risk identification
- Scope management

**Proactive Use**: After completing work, conduct retrospective

**Example Invocation**:
```
Task(
  subagent_type="scrum-project-manager",
  description="Plan sprint for blog feature",
  prompt="Plan 2-week sprint for blog implementation:

  Epic: Blog Feature
  Stories:
  - Blog data structure
  - Blog listing page
  - Blog post detail page
  - Search functionality
  - RSS feed

  Plan:
  - Break stories into tasks
  - Estimate story points
  - Identify dependencies
  - Assign priorities
  - Calculate team velocity
  - Create sprint goal
  - Identify risks

  Deliverables:
  - Sprint backlog
  - Story point estimates
  - Task breakdown
  - Dependency map
  - Sprint goal
  - Risk register
  - Daily standup structure"
)
```

---

## Experience & Optimization Agents

### 23. DX Optimizer

**Purpose**: Developer experience and productivity optimization

**Expertise**:
- Developer workflow optimization
- Build performance
- Tool selection
- Development environment setup
- Error message improvement
- Documentation for developers
- Onboarding optimization
- CI/CD speed optimization

**When to Invoke**:
- Slow build times
- Developer onboarding issues
- Tool friction
- Development environment problems
- Poor error messages
- Productivity bottlenecks

**Proactive Use**: Identify DX issues during development

**Example Invocation**:
```
Task(
  subagent_type="dx-optimizer",
  description="Optimize build performance",
  prompt="Analyze and improve build performance:

  Current Issues:
  - npm run watch takes 5+ minutes
  - Full build takes 10 minutes
  - Hot reload slow (30+ seconds)

  Analyze:
  - Build process bottlenecks
  - Dependency compilation
  - Asset processing
  - TypeScript compilation
  - Bundle size

  Recommend:
  - Build optimization strategies
  - Tool configuration improvements
  - Caching strategies
  - Parallelization opportunities

  Deliverables:
  - Performance analysis
  - Optimization recommendations
  - Configuration changes
  - Expected improvement metrics"
)
```

---

### 24. UX Advocate

**Purpose**: User experience design and advocacy

**Expertise**:
- User interface design
- User flow optimization
- Accessibility (WCAG)
- Usability testing
- Interaction design
- Information architecture
- User research
- Design systems

**When to Invoke**:
- Designing new features
- UI/UX reviews
- Accessibility audits
- User flow optimization
- Design system development
- Usability testing

**Proactive Use**: Review UI implementations

**Example Invocation**:
```
Task(
  subagent_type="ux-advocate",
  description="UX review of blog interface",
  prompt="Evaluate user experience of blog feature:

  Review:
  - Blog listing page
  - Blog post detail page
  - Search interface
  - Navigation
  - Mobile experience

  Evaluate:
  - User flow efficiency
  - Information hierarchy
  - Accessibility (WCAG AA)
  - Keyboard navigation
  - Mobile responsiveness
  - Loading states
  - Error states
  - Empty states

  Provide:
  - UX assessment
  - Usability issues
  - Accessibility issues
  - Improvement recommendations
  - User flow diagrams
  - A11y checklist"
)
```

---

### 25. Technical Learning Coach

**Purpose**: Technical education and skill development

**Expertise**:
- Concept explanation
- Learning path creation
- Tutorial development
- Code review with teaching
- Best practices education
- Technology introduction
- Debugging assistance with learning

**When to Invoke**:
- User asks for explanations
- Learning new technology
- Understanding errors
- Improving specific skills
- Onboarding to codebase
- Pair programming sessions

**Example Invocation**:
```
Task(
  subagent_type="technical-learning-coach",
  description="Explain dependency injection pattern",
  prompt="Teach dependency injection in TypeScript:

  Context:
  - User is confused about @registerSingleton decorator
  - Working in codebase using InversifyJS

  Explain:
  1. What is dependency injection
  2. Why use it (benefits)
  3. How it works in TypeScript
  4. How @registerSingleton works
  5. How constructor injection works
  6. Common patterns in this codebase

  Teaching Approach:
  - Start with fundamentals
  - Use examples from codebase
  - Show both good and bad practices
  - Provide exercises
  - Link to resources

  Deliverables:
  - Explanation document
  - Code examples
  - Practice exercises
  - Resource links"
)
```

---

## Agent Invocation Best Practices

### When to Use Each Agent

**Quick Reference**:

| Task | Agent | Thoroughness |
|------|-------|--------------|
| Find code | Explore | quick-medium |
| Plan feature | Plan | very thorough |
| Implement feature | TDD Software Developer | N/A |
| UI work | Frontend Dev Specialist | N/A |
| API work | Backend API Architect | N/A |
| Full stack | Fullstack Architect | N/A |
| Add tests | QA Testing Strategist | N/A |
| Security review | Security Engineer | N/A |
| Deploy setup | DevOps Infrastructure | N/A |
| Write docs | Tech Docs Writer | N/A |
| Optimize DX | DX Optimizer | N/A |

### Agent Collaboration Patterns

**Sequential Pattern** (One after another):
```
1. Plan Agent → Create implementation plan
2. TDD Software Developer → Implement with tests
3. Security Engineer → Security review
4. Tech Docs Writer → Document feature
```

**Parallel Pattern** (Independent reviews):
```
After implementation, invoke simultaneously:
- Security Engineer (security review)
- UX Advocate (UX review)
- QA Testing Strategist (test coverage review)
```

**Iterative Pattern** (Refinement):
```
1. Frontend Dev Specialist → Initial UI implementation
2. UX Advocate → UX review and recommendations
3. Frontend Dev Specialist → Apply improvements
4. QA Testing Strategist → Ensure test coverage
```

---

## Conclusion

This catalog defines 25 specialized agent personas, each with specific expertise and use cases. The primary orchestrator invokes these agents as needed, coordinating their work to deliver high-quality software.

**Key Principles**:
1. **Specialization**: Each agent has focused expertise
2. **Coordination**: Orchestrator manages agent invocation
3. **Quality**: Multiple review agents ensure quality
4. **Efficiency**: Right agent for right task
5. **Collaboration**: Agents work together on complex features

---

**Version History**:
- v1.0 (2024-11-17): Initial comprehensive agent catalog

**Maintained By**: Primary Orchestrator Agent
**Last Updated**: 2024-11-17
