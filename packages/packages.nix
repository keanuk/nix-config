{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpid
    distrobox
    font-awesome
    libglvnd
	  libxkbcommon
    nerdfonts
    pciutils
    powerline-fonts
    psmisc
    sbctl
    SDL2
    snapper
    snapper-gui
    source-code-pro
    usbutils
    xorg.xkill
  ];

  users.users.keanu.packages = with pkgs; [
    android-studio
    androidStudioPackages.beta
    androidStudioPackages.dev
    android-tools
    btop
    cargo
    dotnet-sdk_8
    flutter
    gcc
    gh
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.forge
    gnomeExtensions.night-theme-switcher
    go
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
