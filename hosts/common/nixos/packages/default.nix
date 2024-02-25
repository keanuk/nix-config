{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    acpid
    bcachefs-tools
    just
    pciutils
    polkit
    psmisc
    sbctl
    snapper
    usbutils
  ];

  users.users.keanu.packages = with pkgs; [
    age
    btop
    cargo
    cpufetch
    direnv
    fastfetch
    fortune
    gcc
    git-crypt
    go
    htop
    mono
    nixfmt
    nix-index
    nmap
    onefetch
    ramfetch
    rustc
    sops
    ssh-to-age
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
