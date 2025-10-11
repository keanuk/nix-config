{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    alpaca
    android-studio
    android-tools
    appimage-run
    audacity
    bitwarden-desktop
    bottles
    bruno
    calibre
    caprine
    catppuccin
    darktable
    dbeaver-bin
    discord
    element-desktop
    endeavour
    ente-auth
    ente-cli
    ente-desktop
    foliate
    fractal
    fragments
    gimp3-with-plugins
    github-copilot-cli
    github-desktop
    gnome-builder
    gnome-disk-utility
    gnome-maps
    handbrake
    inkscape
    insomnia
    # TODO: re-enable when issue is resolved: https://github.com/NixOS/nixpkgs/issues/437865
    # jellyfin-media-player
    jitsi
    joplin-desktop
    krita
    # TODO: re-enable when CMAKE builds are resovled https://github.com/NixOS/nixpkgs/issues/445447
    # kodi-wayland
    leetcode-cli
    leetgo
    libreoffice
    librewolf
    lmstudio
    logseq
    lollypop
    netbird-dashboard
    netbird-ui
    nextcloud-client
    obs-studio
    papers
    pitivi
    plex-desktop
    plexamp
    pocket-casts
    podman-desktop
    polari
    proton-pass
    protonmail-desktop
    protonmail-bridge-gui
    protonvpn-gui
    rawtherapee
    rnote
    rustdesk-flutter
    session-desktop
    shortwave
    shotwell
    signal-desktop-bin
    slack
    standardnotes
    steam-run
    stellarium
    telegram-desktop
    transmission_4-gtk
    trayscale
    # TODO: re-enable when CMAKE builds are resovled https://github.com/NixOS/nixpkgs/issues/445447
    # tremotesf
    tuba
    typst
    vlc
    wireshark
    wl-clipboard
    xclip
    youtube-music
    zlib-ng

    androidStudioPackages.beta
    androidStudioPackages.dev

    kdePackages.kdenlive
    kdePackages.kdevelop

    inputs.zen-browser.packages."${system}".default

    # Games
    airshipper
    bugdom
    # TODO: re-enable when CMAKE builds are resovled https://github.com/NixOS/nixpkgs/issues/445447
    # flightgear
    heroic
    lutris
    nanosaur
    nanosaur2
    otto-matic
    shattered-pixel-dungeon
    # TODO: re-enable when CMAKE builds are resovled https://github.com/NixOS/nixpkgs/issues/445447
    # superTux
    # TODO: re-enable when CMAKE builds are resovled https://github.com/NixOS/nixpkgs/issues/445447
    # superTuxKart
    wesnoth
    xonotic
    # TODO: re-enable when CMAKE builds are resovled https://github.com/NixOS/nixpkgs/issues/445447
    # zeroad
  ];
}
