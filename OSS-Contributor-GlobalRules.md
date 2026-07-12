# OSS-Contributor Global Rules (external-repo mode)

## Introduction

These rules govern the agent when it is **contributing to an external open-source repository
that the team does not own** — upstream projects like LMCache, vLLM, SGLang, or any repo
whose backlog, releases, and standards belong to another organization or foundation. This is
the mode for **open-source developer relations (devrel)**: landing high-quality patches in
someone else's house, on their terms.

It is a peer to `globalrules.md` (full/owned) and `MVP-GlobalRules.md` (rapid/owned). Those
two assume you **own and deploy** the repo — its Issues are your board, its CI is your
pipeline, its style is yours to set. In external-repo mode those assumptions are wrong, and
following them causes real harm (relabeling issues you don't own, opening PRs that violate
the project's conventions, deploying infrastructure that doesn't exist).

**When to use this mode:** the working repository has its own `CONTRIBUTING`, `CODEOWNERS`,
`LICENSE`, and CI, and its `origin` remote points at an organization/foundation you are not
the maintainer of. When in doubt, assume external-repo mode — it is the conservative choice.

---

## ⛔ CRITICAL RULES — READ FIRST (these override the owned-project rules)

1. **The repository's own standards preside.** Read the repo's `CONTRIBUTING`, its
   coding-standard document, its `CLAUDE.md`/`AGENTS.md`, `CODEOWNERS`, PR template, and CI
   config **before writing code**. Where they conflict with the generic agentic-rules on any
   specific — base branch, naming convention, line length, coverage threshold, commit format,
   test framework — **the repository wins, every time.** The agentic-rules are the fallback
   for whatever the repo leaves unspecified, never an override of what it specifies.

2. **Upstream Issues and PRs are read-only reference, not your board.** Do **not** post
   "WIP" comments, add/remove labels, change estimates, transition state, assign, or close
   issues and PRs you do not own. You may **read** them for context and **comment
   substantively** when you have something useful to add (a reproduction, a fix proposal, a
   review). Track *your own* work in the team's internal memory/task system — never by
   mutating the upstream project's metadata.

3. **Respect ownership and provenance on every contribution.** Fork or branch per the repo's
   policy; keep PRs small and focused against the repo's declared base branch; respect
   `CODEOWNERS` for review routing; honor the project's **commit sign-off policy** — add a
   DCO `Signed-off-by:` trailer whenever a `DCO` file or `CONTRIBUTING` requires it, in
   addition to the agent `Co-Authored-By:` trailer; add the exact **license header** the repo
   requires (e.g. SPDX identifiers) to new files.

4. **Memory and audit-trail discipline still apply.** Recall relevant memory at task start;
   store decisions, gotchas, and per-repo bindings at task end. Every task ends in a
   **verifiable artifact you own** — a commit on your branch, an opened PR, a substantive
   upstream comment, or a stored memory. This is the team-internal source of truth, since the
   upstream board is not.

5. **Chain-of-thought before nontrivial code.** State a short numbered plan; self-validate
   against these rules and the repo's standards afterward. If the repo's standard and a rule
   here cannot both be satisfied, follow the repo and say why.

**Forbidden:** driving an upstream board you don't own (WIP comments, relabeling, closing
issues) · opening a PR before reading the repo's CONTRIBUTING and coding standard · omitting
a required DCO sign-off or license header · applying owned-project style (camelCase, 80-col,
a fixed coverage %) over the repo's own enforced style · standing up deploy/serverless/IaC
machinery for a library you merely contribute to.

---

## What carries over from the owned-project rules

- **TDD**, deferring to the repo's testing conventions. Write tests for new features and
  regression tests for bug fixes, but follow the project's framework, layout, and philosophy
  (e.g. "test the public interface, not internals"). Do not impose an external coverage gate
  the project does not enforce.
- **Chain-of-thought, refactoring discipline, and self-validation** (meta-rules §3, §5, §8).
- **Secrets hygiene** — environment/managed stores only; never commit or echo secrets.
- **The memory protocol** (recall at start, store at end) and the **audit-trail** principle.

## What does NOT apply in this mode

- **Backlog ownership** (globalrules "Backlog Management", meta-rules §1) — you are not
  running the project's sprints or triage. Reframed by Critical Rule #2 above.
- **CI/CD authorship, deployment, IaC, canary, rollback, monitoring** (meta-rules §6–7,
  MVP-GlobalRules CI/CD) — the project owns its pipeline. You make it *pass*, you don't
  redesign it. Run the repo's own lint/test/build tooling locally before pushing.
- **Owned-project coding style specifics** (globalrules "Coding Style": camelCase, 80-col) —
  superseded by the repo's enforced style (Critical Rule #1).

---

## Standard workflow (external contribution)

1. **Orient.** Read the repo's `CONTRIBUTING`, coding-standard doc, `CLAUDE.md`/`AGENTS.md`,
   `CODEOWNERS`, PR template, and CI/pre-commit config. Recall team memory for prior bindings
   about this repo. Record the presiding standards and any hard overrides as a per-repo
   binding in memory (or a git-ignored local file in the checkout) so future sessions skip
   the re-derivation.
2. **Scope.** Pick or confirm the change. If it maps to an upstream issue, reference that
   issue in your PR — but do not mutate the issue. Keep the change small and focused per the
   repo's PR-scope guidance.
3. **Plan (chain-of-thought).** Numbered plan; note which repo standards apply and any
   caller-impact/global-view analysis the repo requires.
4. **TDD implement.** Red → Green → Refactor, using the repo's test framework and layout.
5. **Self-check against the repo's gate.** Run the repo's own linters/formatters/type
   checks/tests (e.g. `pre-commit run --all-files`, the repo's `pytest` invocation) until
   clean. Add required license headers and sign-off trailers.
6. **Open the PR** against the repo's base branch, using its PR template, routed to
   `CODEOWNERS`. Link the relevant issue as reference.
7. **Steward the PR.** Respond to review, keep the branch current with the base branch per
   the repo's rebase/merge policy, and land it. Store outcome + the merge/PR reference in
   team memory.

---

## Self-validation

After each task, confirm: (1) the repo's own standards were read and followed where they
speak; (2) no upstream board metadata you don't own was mutated; (3) required sign-off and
license headers are present; (4) the repo's own CI/lint gate passes locally; (5) the outcome
is recorded in team-internal memory. If any rule here could not be satisfied because the
repo's standard required otherwise, state which, and that the repo took precedence.
