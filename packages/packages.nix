{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpid
    pciutils
    polkit
    psmisc
    sbctl
    snapper
    usbutils
  ];

  users.users.keanu.packages = with pkgs; [
    bat
    btop
    cargo
    gcc
    gh
    go
    helix
    htop
    mono
    neofetch
    nixfmt
    nmap
    rustc
    tealdeer
    tree
    vim
    wget
  ];

  # Shell
  programs.zsh.enable = true;
  programs.fish.enable = true;
  services.atuin.enable = true;

  # Nix Packages
  nixpkgs.config = {
    allowUnfree = true;
    # permittedInsecurePackages = [];
  };

  environment.sessionVariables = {};
}
