#!/bin/bash

# Backup original configuration.nix and hardware-configuration.nix
mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
mv /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.bak

# Delete existing symlinks
find /etc/nixos/* ! -name '*.bak' -type l -delete

# Delete existing directories
find /etc/nixos/* ! -name '*.bak' -type d -delete

# Symlink config files to /etc/nixos
cp -rs $PWD/* /etc/nixos