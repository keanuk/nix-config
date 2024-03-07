{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    clang-tools
    libclang
    lldb
  ];
}
