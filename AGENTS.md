# AGENTS.md — Project Context for OpenAI Codex & Agents

## Project Overview

This is a multi-platform Nix configuration managing NixOS, nix-darwin, and home-manager across ~14 devices (desktops, laptops, servers, VPS instances, and WSL). It uses the **dendritic pattern** with [flake-parts](https://flake.parts): every `.nix` file under `modules/` is a top-level flake-parts module, auto-imported via [`import-tree`](https://github.com/vic/import-tree). Files starting with `_` are skipped by `import-tree` and are imported by path where needed.

## Repository Structure

```
flake.nix                            # Entry point: inputs + flake-parts.lib.mkFlake + import-tree ./modules
modules/
├── flake/                           # flake-level wiring
│   ├── systems.nix                  # supported systems
│   ├── formatter.nix                # nixfmt-tree
│   ├── devshells.nix                # devenv-based dev shells (default + per-language)
│   ├── packages.nix                 # nixos-anywhere, deploy-rs
│   ├── nix-config.nix               # flake.nixConfig (substituters, public keys)
│   └── hydra.nix                    # flake.hydraJobs
├── meta/
│   └── domains.nix                  # options.domains — primary domain, services, ports
├── configurations/                  # option trees → flake.{nixos,darwin,home}Configurations
│   ├── nixos.nix                    # configurations.nixos.<host>          (unstable)
│   ├── nixos-stable.nix             # configurations.nixos-stable.<host>   (VPS, stable 25.11)
│   ├── darwin.nix                   # configurations.darwin.<host>
│   ├── home-manager.nix             # configurations.homeManager + homeManager-stable
│   └── deploy-rs.nix                # derives flake.deploy.nodes from isVps=true entries
├── nixpkgs/
│   ├── overlays.nix                 # flake.overlays = { additions, modifications, unstable-packages, stable-packages }
│   ├── _pkgs.nix                    # custom package definitions (referenced by additions overlay)
│   └── _fixes/                      # temporary package-level patches (referenced by modifications)
├── secrets/
│   ├── nixos.nix                    # flake.modules.nixos.sops
│   └── home.nix                     # flake.modules.homeManager.sops
├── nixos/                           # flake.modules.nixos.<role> deferredModules
│   ├── nix-settings.nix             # nix daemon + nixpkgs config + overlays (everyone needs this)
│   ├── system-packages.nix          # base packages (everyone needs this)
│   ├── base.nix                     # main NixOS base role; imports the two above + svc-comin, svc-tailscale, etc.
│   ├── pc.nix, laptop.nix, server.nix, vps.nix, vps-grub.nix, wsl.nix, amd.nix
│   ├── hardware.nix                 # hardware-firmware, autoUpgrade
│   ├── lanzaboote.nix, systemd-boot.nix
│   ├── fs.nix, swapfile.nix, preservation.nix
│   ├── ephemeral-bcachefs.nix, ephemeral-luks-btrfs.nix
│   ├── rtw88-fix.nix
│   ├── home-manager.nix             # HM-as-NixOS-module (unstable + stable variants)
│   ├── desktop/                     # desktop role + DE-specific roles (cosmic, gnome, pantheon, plasma, hyprland)
│   ├── programs/                    # prog-{fuse,nh,nix-ld,evolution,gamescope,steam}
│   ├── services/                    # svc-<name> for each of 43 services (1 file each, ollama keeps subdir)
│   ├── users/                       # user-{keanu,kimmy}
│   ├── virtualization.nix           # podman + oci-containers
│   └── fixes/                       # opt-in fix-{ath11k,gnome-shell-bluetooth-crash,...} roles
├── darwin/                          # flake.modules.darwin.<role>
│   ├── base.nix, packages.nix
│   ├── homebrew.nix, homebrew-aarch.nix
│   ├── desktop-fonts.nix
│   ├── home-manager.nix             # HM-as-darwin-module
│   ├── services/                    # svc-comin
│   ├── users/keanu.nix
│   └── fixes.nix
├── home/                            # flake.modules.homeManager.<role>
│   ├── base.nix                     # base role; imports shell role
│   ├── home-manager-self.nix        # autoUpgrade
│   ├── desktop-linux.nix            # profile: base + desktop + cosmic-tray + gnome-tray (Linux desktop)
│   ├── darwin-profile.nix           # profile: base + darwin (Darwin)
│   ├── vps-profile.nix              # profile: base only (VPS)
│   ├── wsl.nix                      # WSL profile
│   ├── server.nix                   # server-oriented role
│   ├── impermanence.nix
│   ├── darwin.nix, darwin-packages.nix    # darwin-specific apps + packages
│   ├── shell/                       # shell role (and shell-{neovim,nh,nushell,zsh} opt-in roles)
│   ├── desktop/                     # desktop role with 22 apps (and pass, cosmic-tray, gnome-tray, hyprland-tray, gaming, appearance roles)
│   ├── dev/                         # dev role with language toolchains
│   ├── services/openclaw/           # option-driven openclaw role (programs.openclawSecrets.*)
│   └── fixes/                       # registry placeholder
└── hosts/<hostname>/                # per-host composition
    ├── imports.nix                  # composes roles via with config.flake.modules.nixos / darwin
    ├── home.nix                     # writes home-manager.users.<name> + standalone homeConfigurations
    ├── _hardware-configuration.nix  # auto-generated; underscore-prefix to skip import-tree
    ├── _disko-configuration.nix     # disko config; underscore-prefix
    ├── sops.nix                     # (beehive only) per-host sops secrets
    ├── _raid-configuration.nix      # (beehive only)
    ├── _shares.nix                  # (beehive only)
    └── _disko-btrfs.nix             # (phoebe only)
```

## Key Architecture Decisions

### The Dendritic Pattern + flake-parts
- Every file under `modules/` (except those starting with `_`) is a flake-parts module.
- Files contribute features by writing to `flake.modules.<class>.<role>` where `<class>` is `nixos`, `darwin`, or `homeManager`. Multiple files writing to the same role merge automatically (deferredModule semantics).
- Hosts compose by `imports = with config.flake.modules.<class>; [ <role1> <role2> ];`.
- Files starting with `_` are skipped by `import-tree`, used for raw sub-modules referenced by path (hardware-configuration.nix, disko configs, raw HM modules pulled in by sibling default.nix files).

### Configuration Output
- `flake.nixosConfigurations` is built from `configurations.nixos.<host>.module` (unstable) and `configurations.nixos-stable.<host>.module` (stable channel — VPS hosts).
- `flake.darwinConfigurations` is built from `configurations.darwin.<host>.module`.
- `flake.homeConfigurations."<user>@<host>"` is built from `configurations.homeManager.<key>` (unstable) and `configurations.homeManager-stable.<key>` (stable, VPS).
- `flake.deploy.nodes.<host>` is auto-derived from `configurations.nixos-stable.<host>` entries with `isVps = true`.

### Stable vs Unstable
- Most hosts use `nixpkgs` (unstable) and `home-manager`.
- VPS hosts use `nixpkgs-stable` (25.11) and `home-manager-stable` for reliability.
- Both `pkgs.unstable.*` and `pkgs.stable.*` are exposed via overlays for cross-channel access.

### Secrets Management
- SOPS with age encryption, keys listed in `.sops.yaml`.
- NixOS-side: `flake.modules.nixos.sops` (imported by base role).
- HM-side: `flake.modules.homeManager.sops` (opt-in per host).
- Per-host secret declarations live in `modules/hosts/<host>/sops.nix`.
- Default sops file is resolved via `_module.args.rootPath` set in `flake.nix`.

### Centralized Domain Config
- `modules/meta/domains.nix` defines `options.domains` — primary domain, auth domain, email, and 27 service entries (subdomain, ports, requiresAuth, etc.).
- Service modules read `config.domains` at flake-parts scope and capture values via closure into the inner deferredModule (avoids specialArgs threading).

### Overlays
- `modules/nixpkgs/overlays.nix` defines `flake.overlays = { additions; modifications; unstable-packages; stable-packages; }`.
- Overlays are applied in `modules/nixos/nix-settings.nix` (nixpkgs.overlays) and in `modules/configurations/home-manager.nix` (per-system pkgs for standalone HM).
- Custom packages live in `modules/nixpkgs/_pkgs.nix`.
- Fix overlays in `modules/nixpkgs/_fixes/`.

### Ollama Model Tiers
- Base service: `flake.modules.nixos.svc-ollama` (gemma3:1b for resource-constrained hosts).
- Full list: `flake.modules.nixos.svc-ollama-full` (opt-in for beehive, titan, phoebe).

### VPS Deployment
- VPS hosts use `deploy-rs` (declared via `configurations.nixos-stable.<host>.{isVps,deploy}`).
- Initial provisioning via `nixos-anywhere`.
- Use `just deploy <hostname>` or `nix run .#deploy-rs -- .#<hostname>`.

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
| salacia | Darwin | aarch64 | Desktop (Mac Mini 2024) | unstable |
| vesta | Darwin | x86_64 | Laptop (MacBook Pro 2020) | unstable |
| charon | Darwin | x86_64 | Laptop (MacBook Air 2018) | unstable |
| bucaccio | NixOS VPS | x86_64 | Static website (Hetzner) | stable |
| emilyvansant | NixOS VPS | x86_64 | Static website (Hetzner) | stable |
| love-alaya | NixOS VPS | x86_64 | Static website (Hetzner) | stable |

## Coding Conventions

### Nix Style
- Format with `nixfmt-tree` (the flake's formatter). Run `nix fmt`.
- Use `lib.mkDefault` for values that hosts should be able to override easily.
- Use `lib.mkForce` sparingly, only when a mixin must override a base setting.
- Prefer `{ ... }:` or named args over `_:` unless the module genuinely uses no arguments.
- Workaround/fix files include: issue link, status, last-checked date, removal condition.

### Adding a Feature
- One feature per file under the appropriate `modules/<class>/...` subtree.
- Outer wrapper takes the flake-parts arguments (`{ config, inputs, lib, ... }`) it needs.
- Body assigns `flake.modules.<class>.<role> = { ... };`.
- Inner module body is a regular NixOS / nix-darwin / home-manager module taking its own `{ pkgs, lib, config, ... }` args.
- For closure-capture of flake-parts values into the inner module (e.g. `config.domains` from outer scope), pre-compute in a `let` block.

### Adding a New Host
1. Create `modules/hosts/<hostname>/imports.nix` writing to `configurations.nixos.<hostname>.module` (or `nixos-stable` for VPS, `darwin` for macOS).
2. Compose roles via `imports = with config.flake.modules.nixos; [ ... ];`.
3. Copy `hardware-configuration.nix` (and any disko config) to the host folder with an `_` prefix.
4. Create `modules/hosts/<hostname>/home.nix` writing both `configurations.<class>.<host>.module.home-manager.users.<user>` and `configurations.homeManager."<user>@<host>"`.
5. For VPS: set `isVps = true; deploy = { hostname = "..."; sshUser = "..."; };` and `staticWebsite = { domain = "..."; webRoot = "..."; };`.

### Linting

Before committing, always run:

1. `nix fmt` — format with `nixfmt-tree`.
2. `deadnix <file>` — detect unused variables.
3. `statix check <file>` — catch common Nix anti-patterns.

All three are available via `nix develop`.

### Testing Changes
- `nix flake check --no-build` — validate flake evaluation.
- `nix eval --raw .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath` — spot-check a host evaluates.
- `nix eval --raw .#homeConfigurations."<user>@<host>".activationPackage.drvPath` — spot-check a HM config evaluates.
- New files must be `git add`ed before Nix can see them (flakes only see tracked files).
