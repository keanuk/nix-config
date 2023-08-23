#!/bin/bash

# Copy hardware-configuration and backup original
cp /etc/nixos/hardware-configuration.nix .
mv /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.bak

# Backup original configuration.nix
mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak

# Create directories in /etc/nixos
mkdir /etc/nixos/hardware
mkdir /etc/nixos/user
mkdir /etc/nixos/user/keanu
mkdir /etc/nixos/desktop

# Symlink configuration files to /etc/nixos
ln -s /home/$USER/.config/nixos-config/* /etc/nixos/
ln -s /home/$USER/.config/nixos-config/hardware/* /etc/nixos/hardware/
ln -s /home/$USER/.config/nixos-config/user/keanu/* /etc/nixos/user/keanu/
ln -s /home/$USER/.config/nixos-config/desktop/* /etc/nixos/desktop/
