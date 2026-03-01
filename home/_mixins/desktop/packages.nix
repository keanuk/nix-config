{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs.unstable; [
    # TODO: re-enable when build is fixed
    # alpaca
    android-studio
    android-tools
    antigravity-fhs
    appimage-run
    audacity
    bitwarden-desktop
    bottles
    bruno
    # TODO: switch back to unstable when build is fixed
    pkgs.stable.calibre
    caprine
    catppuccin
    darktable
    dbeaver-bin
    dig
    endeavour
    ente-auth
    ente-cli
    ente-desktop
    foliate
    fractal
    fragments
    gimp3-with-plugins
    github-desktop
    gnome-builder
    gnome-disk-utility
    gnome-maps
    handbrake
    inkscape
    jellyfin-media-player
    # TODO: switch back to unstable when build is fixed
    pkgs.stable.jitsi
    joplin-desktop
    krita
    kodi-wayland
    leetgo
    # TODO: switch back to unstable when build is fixed
    pkgs.stable.libreoffice
    librewolf
    lmstudio
    logseq
    lollypop
    microsoft-edge
    netbird-ui
    nextcloud-client
    obs-studio
    papers
    pitivi
    plex-desktop
    plexamp
    # TODO: re-enable when build is fixed
    # pocket-casts
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
    tremotesf
    tuba
    typst
    vlc
    wireshark
    wl-clipboard
    xclip
    pear-desktop
    zlib-ng

    androidStudioPackages.beta
    androidStudioPackages.dev

    kdePackages.kdenlive
    kdePackages.kdevelop

    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default

    # Gaming
    airshipper
    bugdom
    cartridges
    dwarf-fortress
    # TODO: switch back to unstable when build is fixed
    pkgs.stable.flightgear
    heroic
    nanosaur
    nanosaur2
    otto-matic
    shattered-pixel-dungeon
    supertux
    supertuxkart
    wesnoth
    xonotic
    zeroad
  ];
}
