#!/bin/bash

# Delete existing symlinks
find /etc/nixos/* ! -name '*.bak' -type l -delete

# Delete existing directories
find /etc/nixos/* ! -name '*.bak' -type d -delete

# Symlink config files to /etc/nixos
cp -rs $PWD/* /etc/nixos
