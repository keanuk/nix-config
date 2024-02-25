# nix-config

Personal configuration files for Nix.

## Setup

Run setup.sh as superuser from directory where you want to keep configs.

### Set up sops-nix

#### Generate private keys

Either from existing private ssh key:
`ssh-to-age -private-key -i .ssh/id_ed25519 > .config/sops/age/keys.txt`

Or new key:
`age-keygen -o ~/.config/sops/age/keys.txt`

#### Get public key

`age-keygen -y ~/.config/sops/age/keys.txt`