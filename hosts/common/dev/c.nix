{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    clang-tools
    cmake
    cmake-language-server
    libclang
    # lldb
  ];
}
