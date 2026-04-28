# 🏠 Keanu's Nix Configuration

Personal NixOS and nix-darwin configuration files using Nix flakes. This repository contains configurations for multiple devices across different architectures and use cases.

## 🖥️ Devices Overview

### NixOS Systems (Linux)

| Device | Description | Architecture | Role | Notes |
|--------|-------------|--------------|------|-------|
| **beehive** | Beelink SER9 Pro | x86_64 | Home Server | Media server with Jellyfin, Plex, *arr stack |
| **earth** | Intel NUC 10 i7 | x86_64 | Mini PC | Compact desktop |
| **hyperion** | HP EliteBook 845 G8 | x86_64 | Laptop | Desktop with Pantheon DE |
| **miranda** | HP EliteBook 1030 G2 | x86_64 | Laptop | Portable workstation |
| **phoebe** | ThinkPad P14s AMD Gen 5 | x86_64 | Laptop | Development machine |
| **tethys** | Zotac ZBox | x86_64 | Mini PC | Compact desktop |
| **titan** | CyberPowerPC | x86_64 | Desktop | High-performance workstation |

### macOS Systems (Darwin)

| Device | Description | Architecture | Role | Notes |
|--------|-------------|--------------|------|-------|
| **salacia** | Mac Mini 2024 | aarch64 | Desktop | Apple Silicon workstation |
| **vesta** | MacBook Pro 2020 | x86_64 | Laptop | Intel-based portable |
| **charon** | MacBook Air 2018 | x86_64 | Laptop | Lightweight portable |

### Windows Systems (WSL)

| Device | Description | Architecture | Role | Notes |
|--------|-------------|--------------|------|-------|
| **mars** | ThinkPad X13s Gen 1 | aarch64 | Desktop | Portable workstation with cellular |

## 🛠️ Key Tools & Utilities

### Development
- **Git** - Version control with custom configuration
- **Neovim/Nixvim** - Modern Vim-based editor with Nix configuration
- **Helix** - Post-modern text editor
- **GitHub CLI (gh)** - GitHub integration
- **Just** - Command runner for project automation

### Shell & Terminal
- **Fish** - Friendly interactive shell
- **Atuin** - Magical shell history
- **Starship** - Cross-shell prompt
- **Fzf** - Fuzzy finder
- **Direnv** - Environment variable management
- **Eza** - Modern ls replacement
- **Bat** - Cat with syntax highlighting
- **Ripgrep** - Fast text search
- **Bottom** - System resource monitor

### System Management
- **Home Manager** - Declarative user environment management
- **Nix Helper (nh)** - Simplified Nix commands
- **SOPS** - Secrets management
- **Disko** - Declarative disk partitioning
- **Lanzaboote** - Secure Boot for NixOS

### Media & Entertainment
- **Jellyfin** - Media server (earth)
- **Plex** - Media server (earth)
- **Sonarr/Radarr/Lidarr** - Media automation (earth)
- **Prowlarr** - Indexer management (earth)

## 🚀 Getting Started

### Prerequisites

1. **Nix with flakes enabled**:
   ```bash
   # On NixOS, enable in configuration.nix:
   nix.settings.experimental-features = [ "nix-command" "flakes" ];

   # On other systems, add to ~/.config/nix/nix.conf:
   experimental-features = nix-command flakes
   ```

2. **Required tools**:
   ```bash
   nix profile install nixpkgs#git nixpkgs#just nixpkgs#nh
   ```

### Initial Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/keanu/nix-config ~/.config/nix-config
   cd ~/.config/nix-config
   ```

2. **Set up SOPS encryption** (for secrets):
   ```bash
   # Generate age key from SSH key:
   ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt

   # Or generate new age key:
   age-keygen -o ~/.config/sops/age/keys.txt

   # Get public key for adding to .sops.yaml:
   age-keygen -y ~/.config/sops/age/keys.txt
   ```

### Building & Switching

The configuration uses [Just](https://github.com/casey/just) for convenient command execution:

```bash
# List all available commands
just

# Build and switch both OS and Home Manager
just switch

# Build and switch only Home Manager
just home

# Build and switch only OS configuration
just host

# Update flake inputs
just update

# Clean up old generations
just gc
```

### Manual Commands

If you prefer manual commands:

```bash
# NixOS system
sudo nixos-rebuild switch --flake .#hostname

# nix-darwin
darwin-rebuild switch --flake .#hostname

# Home Manager
home-manager switch --flake .#username@hostname
```

## 📁 Repository Structure

```
.
├── flake.nix                       # Entry point: inputs + flake-parts.lib.mkFlake + import-tree ./modules
├── flake.lock                      # Locked dependency versions
├── justfile                        # Task runner commands
├── lib/{cosmic,wallpapers}/        # Static assets (catppuccin theme submodule + wallpaper images)
├── secrets/                        # Encrypted secrets (SOPS)
└── modules/
    ├── flake/                      # flake-parts wiring (systems, formatter, devshells, packages, hydra, nixConfig)
    ├── meta/domains.nix            # options.domains — primary domain, services, ports
    ├── configurations/             # option trees → flake.{nixos,darwin,home}Configurations + deploy.nodes
    │   ├── nixos.nix               # configurations.nixos.<host>           (unstable)
    │   ├── nixos-stable.nix        # configurations.nixos-stable.<host>    (VPS, stable 25.11)
    │   ├── darwin.nix
    │   ├── home-manager.nix        # both unstable + stable
    │   └── deploy-rs.nix
    ├── nixpkgs/                    # overlays, custom packages, fix overlays
    ├── secrets/                    # sops-nix wiring (NixOS + home-manager)
    ├── nixos/                      # flake.modules.nixos.<role> — base, pc, laptop, server, vps, wsl, amd, …
    │   ├── desktop/<de>/           # cosmic, gnome, pantheon, plasma, hyprland (one DE per directory)
    │   ├── programs/<name>/        # fuse, nh, nix-ld, evolution, gamescope, steam
    │   ├── services/<name>/        # the 43 services (cloudflared, jellyfin, ollama, …)
    │   ├── users/                  # user-keanu, user-kimmy
    │   └── fixes/                  # opt-in fix-* roles
    ├── darwin/                     # flake.modules.darwin.<role>
    │   ├── services/<svc>/
    │   └── users/
    ├── home/                       # flake.modules.homeManager.<role>
    │   ├── shell/<tool>/           # fish, starship, atuin, git, neovim, …
    │   ├── desktop/<app>/          # firefox, vscode, kitty, …
    │   ├── dev/<lang>/             # rust, python, go, nix, …
    │   └── services/openclaw/
    └── hosts/<host>/               # per-host composition
        ├── imports.nix             # composes roles via with config.flake.modules.nixos / darwin
        ├── home.nix                # writes home-manager.users.<u> + standalone homeConfigurations
        ├── _hardware-configuration.nix
        └── _disko-configuration.nix
```

### The Dendritic Pattern

This configuration uses the **dendritic pattern** with [flake-parts](https://flake.parts) and [`import-tree`](https://github.com/vic/import-tree). Every `.nix` file under `modules/` (except those starting with `_`) is a top-level flake-parts module, auto-imported into a single configuration tree. Files compose by writing to `flake.modules.<class>.<role>` deferredModules, which merge automatically.

**How it works:**

1. **Each feature is a module that contributes to a role.** A service file under `modules/nixos/services/<svc>/default.nix` writes:
   ```nix
   { flake.modules.nixos.svc-<svc> = { ... NixOS config ... }; }
   ```
   Multiple files writing to the same role merge into one deferredModule.

2. **Hosts compose roles by reference, not by path.** A host's `modules/hosts/<host>/imports.nix` does:
   ```nix
   { config, ... }: {
     configurations.nixos.<host>.module = {
       imports = with config.flake.modules.nixos; [
         base laptop desktop cosmic svc-btrfs user-keanu home-manager
       ];
       networking.hostName = "<host>";
       system.stateVersion = "...";
     };
   }
   ```

3. **No more `specialArgs` plumbing.** Cross-cutting values like `domains` live as top-level options (`options.domains`) and are read at flake-parts scope, then captured into deferredModules via closure.

4. **Consistent across platforms.** `flake.modules.nixos.<role>`, `flake.modules.darwin.<role>`, and `flake.modules.homeManager.<role>` use the same pattern.

5. **Underscore-prefixed files (`_hardware-configuration.nix`, `_aliases.nix`, `_fixes/`, `_pkgs.nix`) are skipped by `import-tree`** and imported by path where needed — used for raw NixOS / home-manager modules and data files that aren't flake-parts modules themselves.

**Benefits:**
- **Discoverability** — browse `modules/` to see every available feature
- **Composition by name** — hosts list role names, not paths
- **Free file motion** — paths represent features, so files can be moved or split without breaking imports
- **Cross-platform sharing** — modules that span NixOS / Darwin / home-manager can be a single file

## 🔧 Configuration Details

### Styling
- **Catppuccin** theme across applications
- **Stylix** for system-wide theming
- Consistent fonts: Inter, JetBrains Mono, Nerd Fonts

### Security
- **SOPS-nix** for secrets management
- **Lanzaboote** for Secure Boot on supported systems
- **Age** encryption for sensitive data

### Storage
- **Btrfs** with snapshots on supported systems
- **Disko** for declarative disk management
- **Impermanence** for ephemeral root filesystem

## 🔄 Maintenance

### Updating
```bash
# Update all flake inputs
just update

# Update specific input
nix flake update nixpkgs

# Check for available updates
nix flake show --allow-import-from-derivation
```

### Cleanup
```bash
# Remove old generations (keep 5 most recent)
just gc

# Manual cleanup
nix-collect-garbage -d
sudo nix-collect-garbage -d  # On NixOS
```

### Debugging
```bash
# Check configuration syntax (skip building closures)
nix flake check --no-build

# Spot-check one host evaluates
nix eval --raw .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath
nix eval --raw .#homeConfigurations.\"<user>@<host>\".activationPackage.drvPath

# Build without switching
just build-host  # or just build-home

# View build logs
nix log /nix/store/...
```

## 📚 Key Features

- **Multi-architecture support** (x86_64, aarch64)
- **Cross-platform** (NixOS, macOS)
- **Declarative secrets** management with SOPS
- **Automated media server** setup (earth)
- **Consistent development environment** across all machines
- **Secure Boot** support where applicable
- **Ephemeral root** filesystem with impermanence
- **Custom overlays** and packages

## 🤝 Contributing

This is a personal configuration, but feel free to:
- Use parts of this configuration for your own setup
- Report issues or suggest improvements
- Submit PRs for general improvements

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [NixOS Community](https://nixos.org/)
- [Home Manager](https://github.com/nix-community/home-manager)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
