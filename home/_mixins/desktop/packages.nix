{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.config = {
    permittedInsecurePackages = [
    ];
  };

  home.packages = with pkgs; [
    alpaca
    android-studio
    android-tools
    antigravity-fhs
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
    dig
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
    github-desktop
    gnome-builder
    gnome-disk-utility
    gnome-maps
    # TODO: re-enable when handbrake builds
    # handbrake
    inkscape
    jellyfin-media-player
    jitsi
    joplin-desktop
    krita
    kodi-wayland
    leetgo
    libreoffice
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

    # TODO: re-enable when kdenlive builds
    # kdePackages.kdenlive
    kdePackages.kdevelop

    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default

    # Gaming
    airshipper
    bugdom
    cartridges
    dwarf-fortress
    flightgear
    heroic
    nanosaur
    nanosaur2
    otto-matic
    shattered-pixel-dungeon
    superTux
    superTuxKart
    wesnoth
    xonotic
    zeroad
  ];
}
