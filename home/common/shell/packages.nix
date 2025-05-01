{ pkgs, ... }: {
  home.packages = with pkgs; [
    age
    # TODO: Uncomment when the build succeeds again
    bitwarden-cli
    cpufetch
    fastfetch
    ffmpeg
    fortune
    git-crypt
    gnome-themes-extra
    just
    libnatpmp
    nix-index
    nmap
    onefetch
    ramfetch
    ripgrep
    sops
    ssh-to-age
    tlrc
    tree
    wget
    yt-dlp
  ];
}
