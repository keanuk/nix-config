#!/bin/bash

# Copy hardware-configuration and backup original
cp /etc/nixos/hardware-configuration.nix .
mv /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.bak

# Backup original configuration.nix
mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak

# Symlink configuration files to /etc/nixos
ln -s /home/$USER/.config/nixos-config/* /etc/nixos/
