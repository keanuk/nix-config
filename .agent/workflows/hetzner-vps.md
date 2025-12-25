---
description: Deploy NixOS to a Hetzner VPS using nixos-anywhere
---

# Hetzner VPS NixOS Deployment

This workflow deploys NixOS to a Hetzner Cloud server using nixos-anywhere.

## Prerequisites

1. A Hetzner Cloud server provisioned with any Linux (Ubuntu/Debian rescue works)
2. SSH access to the server as root
3. Your SSH public key added to the server's authorized_keys
4. Nix installed locally (with flakes enabled)

## Steps

### 1. Provision Hetzner Server

Create a Hetzner Cloud server via console or CLI:
- Location: Your preferred region
- Image: Ubuntu 22.04 (or boot into rescue mode)
- Type: CPX11 or higher
- SSH key: Add your public key

### 2. Update disk device in disko config

SSH into the server and identify the disk device:
```bash
ssh root@<HETZNER_IP> lsblk
```

Update `nixos/bucaccio/disko-configuration.nix` if the device differs from `/dev/sda`.

### 3. Generate age key on server (for sops)

```bash
# SSH into server
ssh root@<HETZNER_IP>

# Install age (if not available)
nix-shell -p age

# Generate key
mkdir -p /root/.config/sops/age
age-keygen -o /root/.config/sops/age/keys.txt

# Get the public key
cat /root/.config/sops/age/keys.txt | grep "public key"
```

Update `.sops.yaml` with the new public key for bucaccio.

### 4. Re-encrypt secrets

```bash
# From your local machine
sops updatekeys secrets/sops/secrets.yaml
```

### 5. Deploy with nixos-anywhere

// turbo-all
Run from WSL or a Linux machine:
```bash
cd /path/to/nix-config

# For a fresh install
nix run .#nixos-anywhere -- \
  --flake .#bucaccio \
  root@<HETZNER_IP>
```

The server will:
1. Boot into kexec
2. Partition disks using disko
3. Install NixOS with your configuration
4. Reboot into the new system

### 6. Post-deployment

After reboot, connect via:
```bash
ssh keanu@<HETZNER_IP>
```

Or if Tailscale is configured:
```bash
ssh keanu@bucaccio
```

> [!TIP]
> **SSH Keys**: It is highly recommended to add your public SSH key to `nixos/_mixins/user/keanu/default.nix` before deployment to ensure you can log in without a password.

## Troubleshooting

- **Disk not found**: Check `lsblk` output and update disko config device path (default is `/dev/sda`)
- **SSH timeout**: Verify firewall allows port 22, check Hetzner console
- **Build fails**: Run `nix flake check` locally first to catch issues. If hardware specific errors occur, check `nixos/bucaccio/hardware-configuration.nix`.

## Adding More Hetzner VPS Hosts

1. Create new directory: `nixos/<hostname>/`
2. Copy and modify files from `bucaccio/`:
   - `default.nix` - update hostname
   - `disko-configuration.nix` - update device path
   - `hardware-configuration.nix` - keep as-is for similar VPS
3. Create home config: `home/<hostname>/keanu.nix`
4. Add to `flake.nix`:
   - `nixosConfigurations.<hostname>`
   - `homeConfigurations."keanu@<hostname>"`
5. Add age key to `.sops.yaml`
6. Deploy with nixos-anywhere
