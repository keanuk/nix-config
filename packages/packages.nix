{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpid
    distrobox
    libglvnd
	  libxkbcommon
    pciutils
    psmisc
    sbctl
    SDL2
    snapper
    snapper-gui
    usbutils
    xorg.xkill
  ];

  users.users.keanu.packages = with pkgs; [
    android-studio
    androidStudioPackages.beta
    androidStudioPackages.dev
    android-tools
    bat
    btop
    cargo
    dotnet-sdk_8
    flutter
    gcc
    gh
    go
    helix
    htop
    jdk
    jetbrains.idea-community
    jetbrains.jdk
    jetbrains.pycharm-community
    kotlin
    mono
    neofetch
    netbird-ui
    nim
    nixfmt
    nmap
    nodejs
    nodePackages."@angular/cli"
    nodePackages.typescript
    python3Full
    rustc
    steam-run
    swift
    tealdeer
    tree
    vim
    vscode-fhs
    wget
    wl-clipboard
    xclip
  ];

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      font-awesome
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      powerline-fonts
      source-code-pro
    ];
  };

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
