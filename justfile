all_cores := `case "$(uname -s)" in Linux) nproc;; Darwin) sysctl -n hw.logicalcpu;; esac`
current_hostname := `hostname -s`
current_username := `whoami`
backup_ext := `date +%Y%m%d-%H%M`

# List recipes
default:
    @just --list --unsorted

# Build OS and Home configurations
build:
    @just build-host

# Switch OS and Home configurations
switch:
    @just switch-host

# Build and Switch Home configuration
home:
    @just build-home
    @just switch-home

# Build and Switch Host configuration
host:
    @just build-host
    @just switch-host

# Build ISO
# Build ISO
iso:
    @echo "ISO 󰗮 Building: console"
    nom build .#packages.x86_64-linux.iso
    mkdir -p "${HOME}/Quickemu/nixos-iso" 2>/dev/null
    cp result/iso/*.iso "${HOME}/Quickemu/nixos-iso/nixos.iso"
    @echo "ISO copied to ${HOME}/Quickemu/nixos-iso/nixos.iso"

# Nix Garbage Collection
gc:
    @echo "Garbage 󰩹 Collection"
    nh clean all --keep 5

# Update flake.lock
update:
    @echo "flake.lock 󱄅 Updating "
    nix flake update

# Build Home configuration
build-home username=current_username hostname=current_hostname:
    @echo "Home Manager  Building: {{ username }}@{{ hostname }}"
    @nh home build . --configuration "{{ username }}@{{ hostname }}"

# Switch Home configuration
switch-home username=current_username hostname=current_hostname:
    @echo "Home Manager  Switching: {{ username }}@{{ hostname }}"
    @nh home switch . --configuration "{{ username }}@{{ hostname }}" --backup-extension {{ backup_ext }}

# Build OS configuration
build-host hostname=current_hostname:
    @if [ "$(uname)" = "Linux" ]; then \
      echo "NixOS  Building: {{ hostname }}"; \
      nh os build . --hostname "{{ hostname }}" -- \
        --option extra-substituters https://install.determinate.systems \
        --option extra-trusted-public-keys cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM=; \
    elif [ "$(uname)" = "Darwin" ]; then \
      echo "nix-darwin 󰀵 Building: {{ hostname }}"; \
      nh darwin build . --hostname "{{ hostname }}" -- \
        --option extra-substituters https://install.determinate.systems \
        --option extra-trusted-public-keys cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM=; \
    else \
      echo "Unsupported OS: $(uname)"; \
    fi

# Switch OS configuration
switch-host hostname=current_hostname:
    @if [ "$(uname)" = "Linux" ]; then \
      echo "NixOS  Switching: {{ hostname }}"; \
      nh os switch . --hostname "{{ hostname }}"; \
    elif [ "$(uname)" = "Darwin" ]; then \
      echo "nix-darwin 󰀵 Switching: {{ hostname }}"; \
      nh darwin switch . --hostname "{{ hostname }}"; \
    else \
      echo "Unsupported OS: $(uname)"; \
    fi

# Generate Authelia secrets (prints to stdout for adding to SOPS)
authelia-secrets:
    @echo "🔐 Generating Authelia secrets..."
    @echo ""
    @echo "Add these to your secrets/sops/secrets.yaml:"
    @echo ""
    @echo "authelia-jwt-secret: $(openssl rand -hex 64)"
    @echo "authelia-session-secret: $(openssl rand -hex 64)"
    @echo "authelia-storage-encryption-key: $(openssl rand -hex 32)"
    @echo ""
    @echo "For the authelia-users secret, see: nixos/_mixins/services/authelia/README.md"

# Generate Argon2id password hash for Authelia users
authelia-hash password:
    @echo "🔐 Generating Argon2id hash for password..."
    @if command -v authelia >/dev/null 2>&1; then \
      authelia crypto hash generate argon2 --password '{{ password }}'; \
    elif command -v docker >/dev/null 2>&1; then \
      docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --password '{{ password }}'; \
    else \
      echo "Error: Neither authelia nor docker found. Install one of them to generate hashes."; \
      echo "Alternatively, use: nix-shell -p authelia --run \"authelia crypto hash generate argon2 --password '{{ password }}'\""; \
    fi
