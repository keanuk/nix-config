Generate a conventional commit message for the staged changes.

Steps:
1. Run `git diff --staged` to see exactly what is changing
2. Run `git log --oneline -10` to understand the recent commit style in this repo
3. Analyze the changes: what is actually being modified, and why?

Commit message format (Conventional Commits):
- Subject: `type(scope): short description` — max 72 chars, imperative mood, no trailing period
- Types: `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`, `revert`
- Scope is optional but helpful in large repos (e.g., `feat(hyprland):`, `fix(beehive):`)
- Body (if needed): explain the WHY, not the WHAT; wrap at 72 chars; leave blank line after subject
- Footer: reference issues with `Fixes #123` or `Closes #123`

Word choice:
- `add` = wholly new feature or file
- `update` = enhancement to something that exists
- `fix` = correcting a bug or broken behavior
- `remove` = deleting something

Rules:
- One commit per logical change — don't bundle unrelated work
- Don't mention file names in the subject unless the rename/move is the point
- Never suggest `--no-verify` to skip hooks
- Do not commit secrets, `.env` files, or sops-encrypted files outside `secrets/`

Output only the commit message, ready to pass to `git commit -m`.
