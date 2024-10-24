{ pkgs, ... }:

{
  imports = [
    ../dev/default.nix
    ../dev/flutter.nix
    ../dev/ide.nix
    ../dev/java.nix
    ../dev/nim.nix
    ../dev/node.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [ ];

  environment = {
    sessionVariables = { };
    systemPackages = with pkgs; [
      distrobox
      gnome-keyring
      ptyxis
      seahorse
      snapper-gui
      wireplumber

      xorg.xkill
    ];
  };

  users.users.keanu.packages = with pkgs; [
    alacritty
    android-tools
    anytype
    appimage-run
    audacity
    beeper
    bitwarden-desktop
    chromium
    darktable
    discord
    element-desktop
    endeavour
    firefox-devedition
    gimp
    github-desktop
    inkscape
    # jitsi-meet
    kitty
    krita
    kodi-wayland
    libadwaita
    libreoffice
    netbird-ui
    obs-studio
    pitivi
    proton-pass
    protonmail-bridge
    protonmail-bridge-gui
    protonmail-desktop
    protonvpn-gui
    signal-desktop
    skypeforlinux
    standardnotes
    steam-run
    telegram-desktop
    thunderbird
    transmission_4-gtk
    typst
    vlc
    wl-clipboard
    xclip
    zlib-ng

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
      noto-fonts-cjk-sans
      noto-fonts-emoji
      powerline-fonts
      source-code-pro
    ];
  };

}
