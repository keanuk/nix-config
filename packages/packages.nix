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
    btop
    cargo
    gcc
    gh
    go
    htop
    mono
    neofetch
    nixfmt
    nix-index
    nmap
    rustc
    tealdeer
    tree
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
