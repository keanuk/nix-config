{ pkgs, ... }:
{
  home.packages = with pkgs; [
    android-tools
    cmake
    docker
    docker-compose
    kind
    kubectl
    leetcode-cli
    leetgo
    mas
    podman
    podman-compose
    podman-tui
    typst
    yt-dlp
    zlib-ng
  ];
}
