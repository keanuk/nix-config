Review a pull request or diff with structured, actionable feedback.

Process:
1. Read the full diff to understand the scope and intent
2. Check the PR description or commit messages for context
3. Review in this priority order:
   - Correctness: does the change do what it claims?
   - Security: any new risks or missed hardening?
   - Scope: are there unrelated changes mixed in?
   - Conventions: does it follow project patterns and style?
   - Maintainability: will future readers understand this?

Feedback format:
```
## Summary
Brief overview of what changed and whether it achieves its goal.

## Blocking Issues
- Specific problems that must be fixed before merging

## Suggestions
- Improvements worth considering, but not blocking

## Questions
- Things that are unclear and need clarification from the author
```

Rules:
- Be specific: cite file names and line numbers
- Distinguish clearly between "must fix" and "nice to have"
- Acknowledge what's done well
- Don't manufacture issues — if something is fine, move on
- Check that tests cover the new behavior
- Verify no secrets, credentials, or debug code were left in
