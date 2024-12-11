{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    distrobox
    ptyxis
    snapper-gui
    wireplumber

    xorg.xkill
  ];

  users.users.keanu.packages = with pkgs; [
    alacritty
    amberol
    android-studio
    android-tools
    anytype
    appimage-run
    audacity
    beeper
    bitwarden-desktop
    bottles
    calibre
    cameractrls
    caprine
    darktable
    discord
    element-desktop
    endeavour
    firefox-devedition
    foliate
    fractal
    fragments
    gimp
    github-desktop
    gnome-builder
    inkscape
    jellyfin-media-player
    jitsi
    joplin-desktop
    kitty
    krita
    kodi-wayland
    libadwaita
    libreoffice
    lollypop
    netbird-dashboard
    netbird-ui
    nextcloud-client
    obs-studio
    pitivi
    plex-desktop
    plexamp
    polari
    proton-pass
    # protonmail-bridge-gui
    protonmail-desktop
    protonvpn-gui
    rawtherapee
    remmina
    session-desktop
    shortwave
    shotwell
    signal-desktop
    skypeforlinux
    slack
    standardnotes
    steam-run
    stellarium
    telegram-desktop
    transmission_4
    trayscale
    tuba
    typst
    vlc
    wireshark
    wl-clipboard
    xclip
    xournalpp
    zed-editor
    zlib-ng

    androidStudioPackages.beta
    androidStudioPackages.dev

    kdePackages.kdenlive
    kdePackages.kdevelop

    # Games
    airshipper
    bugdom
    flightgear
    heroic
    lutris
    nanosaur
    nanosaur2
    otto-matic
    superTux
    superTuxKart
    wesnoth
    xonotic
  ];
}
