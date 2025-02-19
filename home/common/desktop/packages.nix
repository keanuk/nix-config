{ pkgs, ... }: {
  home.packages = with pkgs; [
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
    ente-auth
    ente-cli
    foliate
    fractal
    fragments
    gimp
    github-desktop
    gnome-builder
    gnome-disk-utility
    inkscape
    jellyfin-media-player
    jitsi
    joplin-desktop
    krita
    kodi-wayland
    leetcode-cli
    leetgo
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
    protonmail-desktop
    protonmail-bridge-gui
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
    transmission_4-gtk
    trayscale
    tremotesf
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
    shattered-pixel-dungeon
    superTux
    superTuxKart
    wesnoth
    xonotic
  ];
}
