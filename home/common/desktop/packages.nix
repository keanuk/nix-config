{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    aichat
    alpaca
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
    catppuccin
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
    ladybird
    leetcode-cli
    leetgo
    libadwaita
    libreoffice
    librewolf
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
    signal-desktop-bin
    slack
    standardnotes
    steam-run
    # TODO: re-enable when the build succeeds
    # stellarium
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
    zlib-ng

    androidStudioPackages.beta
    androidStudioPackages.dev

    kdePackages.kdenlive
    kdePackages.kdevelop
    
    inputs.zen-browser.packages."${system}".default

    # Games
    airshipper
    bugdom
    flightgear
    heroic
    lutris
    # TODO: re-enable when the build succeeds
    # nanosaur
    nanosaur2
    # TODO: re-enable when the build succeeds
    # otto-matic
    shattered-pixel-dungeon
    superTux
    superTuxKart
    wesnoth
    xonotic
  ];
}
