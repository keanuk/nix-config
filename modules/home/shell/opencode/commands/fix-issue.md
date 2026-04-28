Diagnose and fix a reported issue with minimal scope.

Process:
1. **Understand**: Read the issue description carefully. What is the expected behavior? What is actually happening?
2. **Locate**: Find the code path or configuration responsible for the behavior
3. **Root cause**: Trace back to the origin — don't treat symptoms
4. **Plan**: Describe exactly what you will change and why, before touching any files
5. **Implement**: Make the smallest change that fixes the root cause
6. **Verify**: Explain concretely how to confirm the fix works

For Nix issues:
- Check `git status` first — untracked files are invisible to the flake
- Use `just check` to validate flake evaluation after changes
- Use `nix eval .#nixosConfigurations.<host>.config.<option>` to verify option values
- Run `nix fmt`, `deadnix`, and `statix check` on every modified file before finishing
- For service failures, verify sops secret paths: `/run/secrets/<name>` (NixOS) or `~/.config/sops-nix/secrets/<name>` (home-manager)

For upstream issues (when you can't fix the root cause directly):
- Create a workaround file using the template at `nixos/_mixins/fixes/_template.nix` or `home/_mixins/fixes/_template.nix`
- Include: issue link, description of the workaround, status, last-checked date, and the condition under which it can be removed
- Add a `warnings` entry so builds surface a reminder to revisit it

Constraints:
- Fix only what was reported — don't refactor or clean up surrounding code in the same change
- Don't add error handling for scenarios that cannot happen
- If the fix requires a separate follow-up, note it explicitly rather than doing it silently
