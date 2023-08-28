#!/bin/bash

# Copy hardware-configuration and backup original
cp /etc/nixos/hardware-configuration.nix ./hardware/$HOST.nix
mv /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.bak

# Backup original configuration.nix
mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak

# Create directories in /etc/nixos
mkdir /etc/nixos/desktop
mkdir /etc/nixos/hardware
mkdir /etc/nixos/nix
mkdir /etc/nixos/packages
mkdir /etc/nixos/system
mkdir /etc/nixos/user
mkdir /etc/nixos/user/keanu

# Symlink configuration files to /etc/nixos
ln -sf $PWD/desktop/* /etc/nixos/desktop/
ln -sf $PWD/hardware/* /etc/nixos/hardware/
ln -sf $PWD/nix/* /etc/nixos/nix/
ln -sf $PWD/packages/* /etc/nixos/packages/
ln -sf $PWD/system/* /etc/nixos/system/
ln -sf $PWD/user/keanu/* /etc/nixos/user/keanu/
