{ pkgs, ... }:

{
  environment = {
    sessionVariables = { };
    systemPackages = with pkgs; [
      distrobox
      ptyxis
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
    netbird-dashboard
    netbird-ui
    obs-studio
    pitivi
    proton-pass
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
    trayscale
    typst
    vlc
    wl-clipboard
    xclip
    zlib-ng

    kdePackages.kdenlive
  ];
}
