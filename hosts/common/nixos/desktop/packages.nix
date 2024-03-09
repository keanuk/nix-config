{ pkgs, ... }:

{
  imports = [
    ../dev/flutter.nix
    ../dev/ide.nix
    ../dev/java.nix
    ../dev/nim.nix
    ../dev/node.nix
  ];

  environment.systemPackages = with pkgs; [
    distrobox
    snapper-gui
    xorg.xkill
  ];

  users.users.keanu.packages = with pkgs; [
    android-tools
    anytype
    appimage-run
    beeper
    libadwaita
    netbird-ui
    steam-run
    typst
    wl-clipboard
    xclip
  ];

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      cantarell-fonts
      font-awesome
      inter
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
