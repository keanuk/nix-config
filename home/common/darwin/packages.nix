{pkgs, ...}: {
  home.packages = with pkgs; [
    aichat
    aider-chat
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
