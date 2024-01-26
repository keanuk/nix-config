{ config, pkgs, ... }:

{
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
    direnv
    fortune
    gcc
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

  # nixpkgs
  nixpkgs.config = {
    allowUnfree = true;
    # permittedInsecurePackages = [];
  };

  environment.sessionVariables = {};
}
