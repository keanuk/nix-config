{pkgs, ...}: {
  home.packages = with pkgs; [
    aichat
    android-tools
    cmake
    kind
    kubectl
    leetcode-cli
    leetgo
    mas
    typst
    yt-dlp
    zlib-ng
  ];
}
