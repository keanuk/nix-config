{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang-tools
    cmake
    cmake-language-server
    lldb
  ];
}
