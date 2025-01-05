{ pkgs, ... }: {
  home.packages = with pkgs; [
    age
    bitwarden-cli
    cpufetch
    fastfetch
    ffmpeg
    fortune
    git-crypt
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
