Generate a structured changelog from recent git history.

Steps:
1. Run `git log --oneline --no-merges` to get the full commit list
2. Identify the relevant date range (since the last release tag, or a specified range)
3. Group and rewrite commits into user-meaningful entries

Output format:
```
## [Unreleased] — YYYY-MM-DD

### Features
- Description of new capabilities added

### Bug Fixes
- Description of incorrect behavior that was corrected

### Improvements
- Refactoring, performance improvements, UX polish, dependency updates

### Chores
- CI changes, tooling updates, maintenance (omit if trivial)
```

Guidelines:
- Rewrite commit messages into plain language — don't copy them verbatim
- Focus Features and Bug Fixes on user-visible or operator-visible changes
- Combine related commits that together represent one logical change
- Skip trivial chores (formatting runs, single-word typo fixes) unless there are many
- If a commit references an issue or PR, link it: `(#123)`
- Use past tense in entries ("Added X", "Fixed Y", "Updated Z")
