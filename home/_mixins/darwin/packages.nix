{ pkgs, ... }:
{
  home.packages = with pkgs.unstable; [
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
