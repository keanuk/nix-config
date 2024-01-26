{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    distrobox
    snapper-gui
    xorg.xkill
  ];

  users.users.keanu.packages = with pkgs; [
    android-studio
    androidStudioPackages.beta
    androidStudioPackages.dev
    android-tools
    anytype
    appimage-run
    beeper
    blackbox-terminal
    dotnet-sdk_8
    flutter
    gh
    jdk
    jetbrains.idea-community
    jetbrains.pycharm-community
    kotlin
    libadwaita
    netbird-ui
    nim
    nodejs
    nodePackages."@angular/cli"
    nodePackages.typescript
    python3Full
    steam-run
    texlive.combined.scheme-full
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

  environment.sessionVariables = {};
}
