{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs.unstable; [
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
    catppuccin
    darktable
    dbeaver-bin
    dig
    endeavour
    ente-auth
    ente-cli
    ente-desktop
    gimp3-with-plugins
    github-desktop
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
    netbird-ui
    nextcloud-client
    obs-studio
    plex-desktop
    plexamp
    # TODO: re-enable when build is fixed
    # pocket-casts
    podman-desktop
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
    typst
    vlc
    wireshark
    wl-clipboard
    xclip
    pear-desktop
    zlib-ng

    kdePackages.kdenlive

    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];
}
