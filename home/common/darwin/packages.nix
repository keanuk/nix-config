{ pkgs, ... }:

{
  home.packages = with pkgs; [
    aichat
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
    leetcode-cli
    leetgo
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
