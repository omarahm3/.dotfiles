---
model: haiku
---

Commit all staged and unstaged changes into well-organized atomic commits. Follow these steps:

1. Run `git status` and `git diff` (staged + unstaged) to see all changes.
2. Run `git log --oneline -10` to match existing commit message style.
3. Analyze the changes and group them by logical concern (e.g., separate feature additions, bug fixes, config changes, refactors). Each group becomes one commit.
4. For each group, stage only the relevant files and create a commit using conventional commit format: `type(scope): message`
   - Types: feat, fix, refactor, chore, docs, style, test, perf, ci, build
   - Scope: the area of the codebase affected (keep short)
   - Message: concise, lowercase, no period, imperative mood
   - Keep the full message under 72 characters
5. If all changes are closely related, a single commit is fine — don't split artificially.
6. Do NOT push. Only commit locally.
7. After committing, run `git log --oneline -5` to show what was created.

Be fast and direct. No explanations needed — just commit.
