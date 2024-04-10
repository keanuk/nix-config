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
    wireplumber
    xorg.xkill
  ];

  users.users.keanu.packages = with pkgs; [
    android-tools
    anytype
    appimage-run
    audacity
    beeper
    bitwarden-desktop
    darktable
    discord
    element-desktop
    endeavour
    gimp
    github-desktop
    inkscape
    krita
    kodi-wayland
    libadwaita
    libreoffice
    logseq
    netbird-ui
    obs-studio
    pitivi
    protonmail-bridge
    protonmail-bridge-gui
    protonmail-desktop
    protonvpn-gui
    signal-desktop
    skypeforlinux
    standardnotes
    steam-run
    telegram-desktop
    transmission-gtk
    typst
    vlc
    wl-clipboard
    xclip

    kdePackages.kdenlive
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

  environment.sessionVariables = { };
}
