# Code Quality
Prefer the simplest solution that works (KISS). Don't design for hypothetical future requirements (YAGNI).
Don't add error handling, fallbacks, or abstractions for scenarios that cannot happen.
Three similar lines is better than a premature abstraction.
Write no comments by default; only add one when the WHY is non-obvious (a hidden constraint, a subtle invariant, a workaround for a specific bug).
Use descriptive names -- well-named identifiers document themselves.
Prefer editing existing files over creating new ones. Make the minimal change that achieves the goal.
Apply security best practices: validate inputs at system boundaries, use secure defaults, minimize attack surface.

# Nix Projects
Format all .nix files with `nix fmt` before finalizing changes.
Run `deadnix <file>` to detect unused variables and bindings.
Run `statix check <file>` to catch common anti-patterns.
Use `lib.mkDefault` for values hosts should be able to override; use `lib.mkForce` sparingly and only when justified.
New files must be `git add`ed before the Nix flake can see them (flakes only track git-indexed files).
Workaround/fix files must include: issue link, description, status, last-checked date, and removal condition.
Follow the mixin pattern: small, focused modules under `_mixins/` directories.
One module per directory with a `default.nix` entry point; use `packages.nix` when the package list is large.
Host-specific overrides belong in the host's `default.nix`, not in shared mixins.
Never hardcode secrets -- use sops-nix with `config.sops.secrets.<name>.path`.
VPS hosts must be deployed with deploy-rs (`just deploy <hostname>`), never direct `nixos-rebuild`.
