# MISTRAL.md — Project Context for Mistral Vibe & Le Chat

## Project Overview

This is a multi-platform Nix configuration managing NixOS, nix-darwin, and home-manager across ~14 devices (desktops, laptops, servers, VPS instances, and WSL). It uses the **mixin pattern** for composable, per-host configuration.

## Repository Structure

```
flake.nix                    # Entry point — all hosts, inputs, overlays, dev shells
lib/                         # Helper functions (mkNixosHost, mkDarwinHost, mkHomeConfig, mkHost, domains)
nixos/                       # NixOS system configurations
  _mixins/                   # Reusable NixOS modules
    base/                    # Core system (nix settings, boot, hardware, sops, server, vps, laptop, pc)
    desktop/                 # Desktop environments (COSMIC, GNOME, Hyprland, Pantheon, Plasma)
    fixes/                   # Temporary workarounds with removal tracking
    programs/                # System programs (nh, nix-ld, steam, gamescope, evolution)
    services/                # System services (ollama, tailscale, cloudflared, authelia, nginx, etc.)
    user/                    # User account definitions (keanu, kimmy)
    virtualization/          # Podman, OCI containers
  <hostname>/                # Per-host configs (beehive, earth, hyperion, mars, miranda, phoebe, tethys, titan)
  vps/                       # VPS hosts (bucaccio, emilyvansant, love-alaya)
  iso/                       # Custom ISO generation
darwin/                      # nix-darwin (macOS) configurations
  _mixins/                   # Reusable Darwin modules (base, desktop, fixes, services, user)
  <hostname>/                # Per-host configs (salacia, charon, vesta)
home/                        # Home Manager configurations
  _mixins/                   # Reusable home-manager modules
    base/                    # Core home config (home-manager, sops, impermanence, server, wsl)
    profiles/                # Shared profiles (desktop-linux.nix, darwin.nix, vps.nix)
    darwin/                  # Darwin-specific home packages and config
    desktop/                 # Desktop apps (firefox, vscode, ghostty, zed, kitty, etc.)
    dev/                     # Language toolchains (rust, go, node, python, c, java, zig, etc.)
    fixes/                   # Home-level workarounds
    services/                # User services (openclaw)
    shell/                   # Shell tools (fish, starship, atuin, git, neovim, helix, etc.)
  <hostname>/                # Per-host home configs
  vps/                       # VPS home configs
modules/                     # Custom NixOS and home-manager modules
overlays/                    # Package overlays (unstable-packages, stable-packages, additions, modifications, fixes/)
pkgs/                        # Custom packages (exposed via overlays.additions)
secrets/                     # SOPS-encrypted secrets (age encryption)
windows/                     # Windows setup scripts (PowerShell, winget, nushell config)
```

## Key Architecture Decisions

### The Mixin Pattern

`_mixins/` directories contain small, focused modules grouped by category. Each host's `default.nix` imports only the mixins it needs. This applies consistently across `nixos/_mixins/`, `darwin/_mixins/`, and `home/_mixins/`.

### Host Configuration Flow

- **NixOS hosts**: `flake.nix` → `lib/mkNixosHost.nix` → `nixos/<host>/default.nix` → imports mixins + `lib/mkHost.nix` for home-manager integration
- **Darwin hosts**: `flake.nix` → `lib/mkDarwinHost.nix` → `darwin/<host>/default.nix` → imports mixins + `lib/mkHost.nix`
- **Home configs**: Both inline (via `mkHomeManagerHost` in host configs) and standalone (via `mkHomeConfig` in flake.nix)

### Stable vs Unstable

- Most hosts use `nixpkgs` (unstable) and `home-manager`
- VPS hosts use `nixpkgs-stable` (25.11) and `home-manager-stable` for reliability
- `pkgs.unstable.*` is available on stable hosts via overlays for packages needing bleeding-edge versions

### Secrets Management

- SOPS with age encryption, keys listed in `.sops.yaml`
- NixOS hosts: `nixos/_mixins/base/sops.nix` (system-level)
- Darwin/home-manager: `home/_mixins/base/sops.nix` (user-level)
- Never hardcode secrets — use `config.sops.secrets.<name>.path`

### Centralized Domain Config

`lib/domains.nix` defines the primary domain, email, and all service definitions (subdomains, ports). Used by `cloudflared`, `authelia`, `static-website`, and other service mixins. Adding a service there auto-propagates to tunnel routes and reverse proxy configs.

### Overlays

- `overlays/default.nix` defines: `additions`, `modifications`, `unstable-packages`, `stable-packages`
- `overlays/fixes/` contains temporary package-level patches with removal tracking comments
- Applied in three places: `flake.nix` (pkgsFor), `nixos/_mixins/base/nix.nix`, `darwin/_mixins/base/default.nix`

### Ollama Model Tiers

- Base mixin (`nixos/_mixins/services/ollama/default.nix`): defaults to small `gemma3:1b` for resource-constrained hosts
- Full list (`nixos/_mixins/services/ollama/full-models.nix`): opt-in import for powerful hosts (beehive, titan, phoebe)
- Do NOT change the default — weaker devices intentionally only load the small model

### VPS Deployment

- VPS hosts are resource-constrained — never run `nixos-rebuild` on them directly
- Use `deploy-rs`: `nix run .#deploy-rs -- .#<hostname>` or `just deploy <hostname>`
- Initial provisioning via `nixos-anywhere` (see `.agent/workflows/hetzner-vps.md`)

## Hosts Quick Reference

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
- Workaround/fix files must include: issue link, description, status, last-checked date, and removal condition
- Add `warnings` entries to fix files so builds surface reminders to check if workarounds are still needed

### File Organization

- One module per directory with a `default.nix` entry point (e.g., `services/ollama/default.nix`)
- Use `packages.nix` alongside `default.nix` when the package list is large
- Host-specific overrides go in the host's `default.nix`, not in shared mixins
- Profiles (`home/_mixins/profiles/`) aggregate common import sets for host categories

### Secrets

- Never hardcode secrets, passwords, or API keys in Nix files
- Use `sops-nix` with `config.sops.secrets.<name>.path`
- NixOS secret paths: `/run/secrets/<name>`
- Home-manager secret paths: `~/.config/sops-nix/secrets/<name>`
- All secrets live in `secrets/sops/secrets.yaml`, encrypted with age keys from `.sops.yaml`

### Testing Changes

- `just check` — validate flake evaluation without building
- `just build` — build current host's OS config
- `just home` — build and switch home-manager config
- `nix eval .#nixosConfigurations.<host>.config.<option>` — spot-check a specific option value
- **New files must be `git add`ed before Nix can see them** (flakes only track files known to git)

## Common Tasks

### Adding a new NixOS host

1. Create `nixos/<hostname>/default.nix` and `hardware-configuration.nix`
2. Import appropriate mixins (base, desktop, services, user)
3. Add `mkHomeManagerHost` call with path to home config
4. Create `home/<hostname>/keanu.nix` importing a profile (e.g., `profiles/desktop-linux.nix`)
5. Add entries to `flake.nix`: `nixosConfigurations.<hostname>` and `homeConfigurations."keanu@<hostname>"`

### Adding a new VPS host

1. Create `nixos/vps/<hostname>/` with `default.nix`, `disko-configuration.nix`, `hardware-configuration.nix`
2. Import `../../_mixins/base`, `../../_mixins/base/vps-grub.nix`, and `static-website` mixin
3. Create `home/vps/<hostname>/keanu.nix` importing `profiles/vps.nix`
4. Add to `flake.nix`: nixosConfigurations (using `mkNixosHost-stable`), homeConfigurations (using `mkHomeConfig-stable`), and `deploy.nodes`
5. Add age key to `.sops.yaml` and re-encrypt secrets

### Adding a new service

1. Create `nixos/_mixins/services/<name>/default.nix`
2. If it needs a subdomain, add it to `lib/domains.nix` (auto-propagates to cloudflared and authelia)
3. Import the service in the relevant host's `default.nix`

### Adding a workaround/fix

1. Copy the template from `nixos/_mixins/fixes/_template.nix` or `home/_mixins/fixes/_template.nix`
2. Fill in: issue link, workaround description, status, last-checked date, removal condition
3. Add a `warnings` list entry so builds remind you to check if it's still needed
4. Import it in the relevant `fixes/default.nix`
