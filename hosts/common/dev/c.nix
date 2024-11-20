{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    clang-tools
    cmake
    cmake-language-server
    libclang
    lldb
  ];
}
