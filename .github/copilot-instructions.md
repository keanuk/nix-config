# GitHub Copilot Instructions — Keanu's Nix Configuration

## Project Overview

This is a multi-platform Nix configuration managing NixOS, nix-darwin, and home-manager across ~14 devices (desktops, laptops, servers, VPS instances, and WSL). It uses the **dendritic pattern** with [flake-parts](https://flake.parts) and [`import-tree`](https://github.com/vic/import-tree).

## Repository Layout

- `flake.nix` — Entry point: inputs + `flake-parts.lib.mkFlake` + `import-tree ./modules`
- `modules/`
  - `flake/` — flake-parts wiring (systems, formatter, devshells, packages, hydra, nixConfig)
  - `meta/domains.nix` — `options.domains` (primary domain, services, ports)
  - `configurations/` — option trees that emit `flake.{nixos,darwin,home}Configurations` and `deploy.nodes`
  - `nixpkgs/` — overlays, custom packages (`_pkgs.nix`), fix overlays (`_fixes/`)
  - `secrets/` — sops-nix wiring (NixOS + home-manager)
  - `nixos/` — `flake.modules.nixos.<role>` — base/pc/laptop/server/vps/wsl/amd, desktop/<de>/, programs/<name>/, services/<name>/, users/, fixes/
  - `darwin/` — `flake.modules.darwin.<role>` — base, packages, homebrew{,-aarch}, services/<svc>/, users/, fixes
  - `home/` — `flake.modules.homeManager.<role>` — base, profiles (desktop-linux, darwin-profile, vps-profile, wsl, server), shell/<tool>/, desktop/<app>/, dev/<lang>/, services/openclaw/
  - `hosts/<host>/` — per-host composition (`imports.nix`, `home.nix`, `_hardware-configuration.nix`, etc.)
- `lib/` — static assets only: `wallpapers/` (used by stylix/hyprpaper) and `cosmic/catppuccin` (submodule)
- `secrets/` — SOPS-encrypted secrets (age encryption); `secrets/sops/secrets.yaml`
- `windows/` — Windows setup scripts
- Files starting with `_` are skipped by `import-tree` and imported by path where needed (e.g. `_hardware-configuration.nix`, `_aliases.nix`, `_fixes/`).

## Architecture

### The Dendritic Pattern

Every `.nix` file under `modules/` (except `_*` files) is a top-level flake-parts module, auto-imported via `import-tree`. Files compose by writing to `flake.modules.<class>.<role>` deferredModules, which merge automatically when multiple files target the same role.

A leaf module looks like:

```nix
# modules/nixos/services/cloudflared/default.nix
{ config, ... }:
let d = config.domains; in
{
  flake.modules.nixos.svc-cloudflared = { ... NixOS module body ... };
}
```

A host composes roles by name:

```nix
# modules/hosts/earth/imports.nix
{ config, ... }: {
  configurations.nixos.earth.module = {
    imports = with config.flake.modules.nixos; [ base pc desktop cosmic svc-btrfs user-keanu home-manager ];
    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "earth";
    system.stateVersion = "23.11";
  };
}
```

### Configuration Output

- `flake.nixosConfigurations` is built from `configurations.nixos.<host>.module` (unstable) and `configurations.nixos-stable.<host>.module` (VPS, stable 25.11).
- `flake.darwinConfigurations` is built from `configurations.darwin.<host>.module`.
- `flake.homeConfigurations."<user>@<host>"` from `configurations.homeManager.<key>` (unstable) and `configurations.homeManager-stable.<key>` (VPS).
- `flake.deploy.nodes.<host>` is auto-derived from `configurations.nixos-stable.<host>` entries with `isVps = true`.

### Stable vs Unstable

- Most hosts use `nixpkgs` (unstable) and `home-manager`.
- VPS hosts use `nixpkgs-stable` (25.11) and `home-manager-stable`.
- `pkgs.unstable.*` and `pkgs.stable.*` are exposed via overlays for cross-channel access.

### Centralized Domain Config

`modules/meta/domains.nix` defines `options.domains` (primary domain, auth domain, email, 27 service entries with subdomain/ports/auth flags). Service modules read `config.domains` at flake-parts scope and capture values via closure. No more `specialArgs` plumbing.

### Ollama Model Tiers

- Base: `flake.modules.nixos.svc-ollama` — small `gemma3:1b` for weak devices.
- Full list: `flake.modules.nixos.svc-ollama-full` — opt-in for beehive, titan, phoebe.
- Do NOT change the default — weaker devices intentionally only load the small model.

### VPS Deployment

- VPS hosts are resource-constrained — never `nixos-rebuild` on them.
- Use `deploy-rs`: `just deploy <hostname>` or `nix run .#deploy-rs -- .#<hostname>`.
- Initial provisioning via `nixos-anywhere`.

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

- Format with `nixfmt-tree` (the flake's formatter, run `nix fmt`).
- Use `lib.mkDefault` for values that hosts should be able to override easily.
- Use `lib.mkForce` sparingly, only when a role must override a base setting.
- Prefer `{ ... }:` or named args over `_:` unless the module genuinely uses no arguments.
- Fix/workaround files must include: issue link, status, last-checked date, removal condition. Add a `warnings` list entry so builds surface a reminder.

### File Organization

- One feature per directory with a `default.nix` entry point. Auxiliary files in the same directory either contribute to the same role (multiple `flake.modules.<class>.<role>` writes merge) or are underscore-prefixed for path-imports.
- Outer wrapper takes the flake-parts arguments it needs (`{ config, inputs, lib, ... }`).
- Body assigns `flake.modules.<class>.<role> = { ... };`.
- Inner module body is a regular NixOS / nix-darwin / home-manager module taking its own `{ pkgs, lib, config, ... }`.

### Secrets

- Never hardcode secrets, passwords, or API keys in Nix files.
- Use `sops-nix`: `config.sops.secrets.<name>.path`.
- NixOS: `/run/secrets/<name>`. Home-manager: `~/.config/sops-nix/secrets/<name>`.
- All secrets in `secrets/sops/secrets.yaml`, encrypted with age keys from `.sops.yaml`.
- Per-host secret declarations live in `modules/hosts/<host>/sops.nix`.

### Testing

- `just check` — validate flake evaluation without building.
- `just build` — build current host's config.
- `just home` — build and switch home-manager config.
- `nix eval --raw .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath` — spot-check evaluation.
- `nix eval --raw .#homeConfigurations.\"<user>@<host>\".activationPackage.drvPath` — spot-check HM config.
- **New files must be `git add`ed before Nix can see them.**

### Linting

Before committing changes to any `.nix` file, run these three checks and fix any issues:

1. `nix fmt` — format with `nixfmt-tree`.
2. `deadnix <file>` — detect unused variables.
3. `statix check <file>` — catch common Nix anti-patterns.

All three are available via `nix develop`.

## Common Tasks

### Adding a new NixOS host

1. Create `modules/hosts/<hostname>/imports.nix` writing to `configurations.nixos.<hostname>.module`. Compose roles via `imports = with config.flake.modules.nixos; [ ... ];`.
2. Copy `hardware-configuration.nix` (and any disko config) into the host folder with an `_` prefix.
3. Create `modules/hosts/<hostname>/home.nix` writing both `configurations.nixos.<host>.module.home-manager.users.<user>` and the standalone `configurations.homeManager."<user>@<host>"`.

### Adding a new VPS host

1. Create `modules/hosts/<hostname>/imports.nix` writing to `configurations.nixos-stable.<hostname>` with `isVps = true; deploy = { hostname = "..."; sshUser = "..."; };` and `staticWebsite = { domain = "..."; webRoot = "..."; };`.
2. Compose roles `[ base vps-grub vps-website user-keanu home-manager-stable ]` plus the host's hardware/disko files.
3. Create `home.nix` writing both the integrated and standalone home-manager configs (using `homeManager-stable`).
4. Add the deploy target's age key to `.sops.yaml`.

### Adding a new service

1. Create `modules/nixos/services/<name>/default.nix` writing `flake.modules.nixos.svc-<name> = { ... };`.
2. If the service needs a subdomain, add it to `modules/meta/domains.nix` (auto-propagates to cloudflared/authelia which read `config.domains`).
3. Reference the service from a role aggregator (e.g. `flake.modules.nixos.server`) or directly from a host's imports.

### Adding a workaround/fix

1. Create `modules/nixos/fixes/<name>/default.nix` writing `flake.modules.nixos.fix-<name> = { ... };`.
2. Add `warnings = [ "..." ];` so builds surface a reminder.
3. Hosts opt in by adding the role to their imports list.
