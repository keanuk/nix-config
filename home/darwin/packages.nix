{ pkgs, ... }:

{
  home.packages = with pkgs; [
    age
    android-tools
    cpufetch
    fastfetch
    ffmpeg
    fortune
    git-crypt
    just
    kind
    kubectl
    libnatpmp
    nix-index
    nmap
    onefetch
    ripgrep
    sops
    ssh-to-age
    tlrc
    tree
    typst
    wget
    yt-dlp
    zlib-ng
  ];
}
