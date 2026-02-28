# GitHub Copilot Instructions — Keanu's Nix Configuration

## Project Overview

This is a multi-platform Nix configuration managing NixOS, nix-darwin, and home-manager across ~14 devices (desktops, laptops, servers, VPS instances, and WSL). It uses the **mixin pattern** for composable, per-host configuration.

## Repository Layout

- `flake.nix` — Entry point: all hosts, inputs, overlays, dev shells
- `lib/` — Helper functions: `mkNixosHost`, `mkDarwinHost`, `mkHomeConfig`, `mkHost` (home-manager integration), `domains.nix` (centralized service/domain config)
- `nixos/` — NixOS system configurations
  - `_mixins/` — Reusable NixOS modules: `base/`, `desktop/`, `fixes/`, `programs/`, `services/`, `user/`, `virtualization/`
  - `<hostname>/` — Per-host configs: beehive, earth, hyperion, mars, miranda, phoebe, tethys, titan
  - `vps/` — VPS hosts: bucaccio, emilyvansant, love-alaya
- `darwin/` — nix-darwin (macOS) configurations
  - `_mixins/` — Reusable Darwin modules: `base/`, `desktop/`, `fixes/`, `services/`, `user/`
  - `<hostname>/` — Per-host configs: salacia, charon, vesta
- `home/` — Home Manager configurations
  - `_mixins/` — Reusable modules: `base/`, `profiles/`, `darwin/`, `desktop/`, `dev/`, `fixes/`, `services/`, `shell/`
  - `<hostname>/` — Per-host home configs
  - `vps/` — VPS home configs
- `modules/` — Custom NixOS and home-manager modules
- `overlays/` — Package overlays: `unstable-packages`, `stable-packages`, `additions`, `modifications`, `fixes/`
- `pkgs/` — Custom packages (exposed via `overlays.additions`)
- `secrets/` — SOPS-encrypted secrets (age encryption)
- `windows/` — Windows setup scripts

## Architecture

### The Mixin Pattern

`_mixins/` directories contain small, focused modules grouped by category. Each host's `default.nix` imports only the mixins it needs. This pattern is used consistently across `nixos/_mixins/`, `darwin/_mixins/`, and `home/_mixins/`.

### Host Configuration Flow

- **NixOS**: `flake.nix` → `lib/mkNixosHost.nix` → `nixos/<host>/default.nix` → mixins + `lib/mkHost.nix` for home-manager
- **Darwin**: `flake.nix` → `lib/mkDarwinHost.nix` → `darwin/<host>/default.nix` → mixins + `lib/mkHost.nix`
- **Home configs**: Inline (via `mkHomeManagerHost`) and standalone (via `mkHomeConfig`)

### Stable vs Unstable

- Most hosts use `nixpkgs` (unstable) and `home-manager`
- VPS hosts use `nixpkgs-stable` (25.11) and `home-manager-stable`
- `pkgs.unstable.*` is available on stable hosts via overlays

### Centralized Domain Config

`lib/domains.nix` defines the primary domain, email, and all service definitions (subdomains, ports). Adding a service there auto-propagates to cloudflared tunnel routes and authelia reverse proxy configs.

### Ollama Model Tiers

- Base mixin (`services/ollama/default.nix`): defaults to small `gemma3:1b` for weak devices
- Full list (`services/ollama/full-models.nix`): opt-in for powerful hosts (beehive, titan, phoebe)
- Do NOT change the default — weaker devices intentionally only load the small model

### VPS Deployment

- VPS hosts are resource-constrained — never `nixos-rebuild` on them
- Use `deploy-rs`: `just deploy <hostname>` or `nix run .#deploy-rs -- .#<hostname>`
- Initial provisioning via `nixos-anywhere`

## Hosts

| Host | Platform | Arch | Role | Channel |
|------|----------|------|------|---------|
| beehive | NixOS | x86_64 | Home server (Beelink SER9 Pro) | unstable |
| earth | NixOS | x86_64 | Mini PC (Intel NUC 10) | unstable |
| hyperion | NixOS | x86_64 | Laptop (HP EliteBook 845 G8) | unstable |
| mars | NixOS/WSL | aarch64 | WSL (ThinkPad X13s) | unstable |
| miranda | NixOS | x86_64 | Laptop (HP EliteBook 1030 G2) | unstable |
| phoebe | NixOS | x86_64 | Laptop (ThinkPad P14s AMD Gen 5) | unstable |
| tethys | NixOS | x86_64 | Mini PC (Zotac ZBox) | unstable |
| titan | NixOS | x86_64 | Desktop (CyberPowerPC, AMD GPU) | unstable |
| salacia | Darwin | aarch64 | Desktop (Mac Mini 2024) | — |
| vesta | Darwin | x86_64 | Laptop (MacBook Pro 2020) | — |
| charon | Darwin | x86_64 | Laptop (MacBook Air 2018) | — |
| bucaccio | NixOS VPS | x86_64 | Static website (Hetzner) | stable |
| emilyvansant | NixOS VPS | x86_64 | Static website (Hetzner) | stable |
| love-alaya | NixOS VPS | x86_64 | Static website (Hetzner) | stable |

## Coding Conventions

### Nix Style

- Format with `nixfmt-tree` (the flake's formatter)
- Use `lib.mkDefault` for values that hosts should be able to override easily
- Use `lib.mkForce` sparingly, only when a mixin must override a base setting
- Prefer `{ ... }:` or named args over `_:` unless the module genuinely uses no arguments
- Fix/workaround files must include: issue link, description, status, last-checked date, removal condition
- Add `warnings` entries to fix files so builds surface reminders

### File Organization

- One module per directory with a `default.nix` entry point
- Use `packages.nix` alongside `default.nix` when the package list is large
- Host-specific overrides go in the host's `default.nix`, not in shared mixins
- Profiles (`home/_mixins/profiles/`) aggregate common import sets per host category

### Secrets

- Never hardcode secrets, passwords, or API keys in Nix files
- Use `sops-nix` with `config.sops.secrets.<name>.path`
- NixOS secrets: `/run/secrets/<name>` — Home-manager secrets: `~/.config/sops-nix/secrets/<name>`
- All secrets in `secrets/sops/secrets.yaml`, encrypted with age keys from `.sops.yaml`

### Testing

- `just check` — validate flake evaluation without building
- `just build` — build current host's OS config
- `just home` — build and switch home-manager config
- `nix eval .#nixosConfigurations.<host>.config.<option>` — spot-check option values
- **New files must be `git add`ed before Nix can see them**

## Common Tasks

### Adding a new NixOS host

1. Create `nixos/<hostname>/default.nix` and `hardware-configuration.nix`
2. Import appropriate mixins (base, desktop, services, user)
3. Add `mkHomeManagerHost` call pointing to home config
4. Create `home/<hostname>/keanu.nix` importing a profile
5. Add to `flake.nix`: `nixosConfigurations` and `homeConfigurations`

### Adding a new VPS host

1. Create `nixos/vps/<hostname>/` with `default.nix`, `disko-configuration.nix`, `hardware-configuration.nix`
2. Import `../../_mixins/base`, `../../_mixins/base/vps-grub.nix`, and `static-website` mixin
3. Create `home/vps/<hostname>/keanu.nix` importing `profiles/vps.nix`
4. Add to `flake.nix`: nixosConfigurations (`mkNixosHost-stable`), homeConfigurations (`mkHomeConfig-stable`), `deploy.nodes`
5. Add age key to `.sops.yaml`

### Adding a new service

1. Create `nixos/_mixins/services/<name>/default.nix`
2. If it needs a subdomain, add to `lib/domains.nix` (auto-propagates to cloudflared/authelia)
3. Import in the host's `default.nix`

### Adding a workaround/fix

1. Copy template from `nixos/_mixins/fixes/_template.nix` or `home/_mixins/fixes/_template.nix`
2. Fill in: issue link, description, status, last-checked date, removal condition
3. Add `warnings` entry for build-time reminders
4. Import in `fixes/default.nix`
