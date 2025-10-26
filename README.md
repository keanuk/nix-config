# 🏠 Keanu's Nix Configuration

Personal NixOS and nix-darwin configuration files using Nix flakes. This repository contains configurations for multiple devices across different architectures and use cases.

## 🖥️ Devices Overview

### NixOS Systems (Linux)

| Device | Description | Architecture | Role | Notes |
|--------|-------------|--------------|------|-------|
| **beehive** | Beelink SER9 Pro | x86_64 | Home Server | Media server with Jellyfin, Plex, *arr stack |
| **earth** | Intel NUC 10 i7 | x86_64 | Home Server | Media server with Jellyfin, Plex, *arr stack |
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
├── flake.nix                 # Main flake configuration
├── flake.lock               # Locked dependency versions
├── justfile                 # Task runner commands
│
├── nixos/                   # NixOS configurations
│   ├── _mixins/            # Reusable NixOS configuration modules
│   │   ├── base/           # Base system configs (boot, impermanence, laptop, server, etc.)
│   │   ├── desktop/        # Desktop environments (COSMIC, GNOME, Hyprland, Pantheon, Plasma)
│   │   ├── programs/       # System programs (nh, Steam, Evolution)
│   │   ├── services/       # System services (Jellyfin, Plex, *arr, Tailscale, etc.)
│   │   ├── user/           # User account configurations
│   │   └── virtualization/ # Virtualization configs
│   ├── beehive/            # Beelink SER9 Pro
│   ├── earth/              # Intel NUC server
│   ├── hyperion/           # HP EliteBook 845 G8
│   ├── miranda/            # HP EliteBook 1030 G2
│   ├── phoebe/             # ThinkPad P14s AMD Gen 5
│   ├── tethys/             # Zotac ZBox
│   ├── titan/              # CyberPowerPC desktop
│   └── mars/               # ThinkPad X13s Gen 1 (WSL)
│
├── darwin/                  # macOS (nix-darwin) configurations
│   ├── _mixins/            # Reusable Darwin configuration modules
│   │   ├── base/           # Base macOS configs
│   │   ├── desktop/        # Desktop-related macOS configs
│   │   ├── services/       # macOS services
│   │   └── user/           # User account configurations
│   ├── salacia/            # Mac Mini 2024
│   ├── vesta/              # MacBook Pro 2020
│   └── charon/             # MacBook Air 2018
│
├── home/                    # Home Manager configurations
│   ├── _mixins/            # Reusable Home Manager modules
│   │   ├── base/           # Base home configs (default, impermanence, server, wsl)
│   │   ├── darwin/         # Darwin-specific home configs
│   │   ├── desktop/        # Desktop apps (Firefox, VSCode, GNOME, Kitty, Thunderbird, Zed, etc.)
│   │   ├── dev/            # Language toolchains (C, Rust, Python, Go, Nix, Java, etc.)
│   │   └── shell/          # Shell tools (Fish, Starship, Atuin, Git, Neovim, Helix, etc.)
│   └── [hostname]/         # Per-host user configurations (e.g., hyperion/keanu.nix)
│
├── modules/                 # Custom NixOS and Home Manager modules
│   ├── nixos/              # NixOS modules
│   └── home-manager/       # Home Manager modules
├── overlays/               # Package overlays
├── pkgs/                   # Custom packages
└── secrets/                # Encrypted secrets (SOPS)
```

### The _mixins Pattern

This configuration uses a **_mixins pattern** for modular, composable system configuration. Instead of a monolithic `common/` directory, configurations are organized into small, focused modules that can be mixed and matched per host.

**How it works:**

1. **Mixins are organized by category** - Each `_mixins/` directory contains subdirectories grouping related functionality (e.g., `base/`, `desktop/`, `services/`)

2. **Host configurations import only what they need** - Each host's `default.nix` imports specific mixins:
   ```nix-config/example-host.nix#L1-10
   # Example: nixos/hyperion/default.nix
   imports = [
     ../_mixins/base/default.nix
     ../_mixins/base/laptop.nix
     ../_mixins/desktop/pantheon/default.nix
     ../_mixins/services/tailscale/default.nix
   ];
   ```

3. **Fine-grained composition** - Mix and match exactly the features needed:
   - A laptop gets `base/laptop.nix`, a server gets `base/server.nix`
   - Desktop systems import specific DE mixins (GNOME, Pantheon, Hyprland, etc.)
   - Media servers import only the services they need (Jellyfin, Plex, Sonarr, etc.)

4. **Consistent across platforms** - The same pattern is used for:
   - **NixOS** (`nixos/_mixins/`) - System-level configuration
   - **Darwin** (`darwin/_mixins/`) - macOS system configuration
   - **Home Manager** (`home/_mixins/`) - User-level configuration

**Benefits:**
- **Clarity** - Easy to see exactly what features a host uses
- **Reusability** - Mixins are shared across hosts without duplication
- **Flexibility** - Add or remove features by changing imports
- **Discoverability** - Browse `_mixins/` to see available options

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
# Check configuration syntax
nix flake check

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
