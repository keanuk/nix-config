{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    libglvnd
	  libxkbcommon
    distrobox
    SDL2
    snapper-gui
    xorg.xkill
  ];

  users.users.keanu.packages = with pkgs; [
    android-studio
    androidStudioPackages.beta
    androidStudioPackages.dev
    android-tools
    appimage-run
    dotnet-sdk_8
    flutter
    gh
    jdk
    jetbrains.idea-community
    jetbrains.jdk
    jetbrains.pycharm-community
    kotlin
    netbird-ui
    nim
    nodejs
    nodePackages."@angular/cli"
    nodePackages.typescript
    python3Full
    steam-run
    swift
    vscode-fhs
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

  services.vscode-server.enable = true;

  environment.sessionVariables = {};
}
