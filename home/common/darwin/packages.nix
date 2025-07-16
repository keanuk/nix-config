{pkgs, ...}: {
  home.packages = with pkgs; [
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
