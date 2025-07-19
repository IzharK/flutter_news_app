# Contributing Guidelines

Thank you for considering contributing to **flutter_news_app**!

This document describes our development workflow, branch strategy, and commit message conventions so that all contributions remain consistent.

---

## Branch Strategy

| Branch        | Purpose                               |
|---------------|---------------------------------------|
| `main`        | Always production‐ready.              |
| `develop`     | Integration branch for completed work |
| `feat/*`      | New features                           |
| `fix/*`       | Bug fixes                              |
| `chore/*`     | Maintenance tasks / refactors         |

Create feature branches from **develop**:

```bash
# Example
git checkout develop
git pull
git checkout -b feat/news_api_integration
```

When a feature/fix is complete and passes CI, open a Pull Request (PR) into **develop**. Merging **develop → main** happens only when a release is ready.

---

## Commit Message Convention (Conventional Commits)

```
<type>(<scope>): <subject>

[body (optional)]
```

### Allowed `<type>` values
- `feat`     – New feature
- `fix`      – Bug fix
- `docs`     – Documentation only changes
- `refactor` – Code change that neither fixes a bug nor adds a feature
- `test`     – Adding or refactoring tests
- `chore`    – Build process, tool changes, maintenance

### Examples
```
feat(news_service): fetch top headlines from NewsAPI
fix(article_controller): handle null description safely
docs(contributing): add commit convention table
```

### Breaking changes
If a commit introduces a breaking API change, add a footer section:

```
BREAKING CHANGE: description of the change
```

---

## Pre-commit Hook

We use a local Git pre-commit hook to enforce formatting and static analysis:

```bash
flutter format --set-exit-if-changed .
flutter analyze --fatal-infos
```

The hook is stored in `.githooks/pre-commit`. Git is configured (`core.hooksPath`) to use that directory automatically.

---

## Git Aliases (optional)
Add these to your personal `~/.gitconfig` for convenience:

```ini
[alias]
  co = checkout
  br = branch
  ci = commit
  st = status -sb
  amend = commit --amend --no-edit
```

---

Happy coding! :rocket:
