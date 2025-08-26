{pkgs, ...}: {
  home.packages = with pkgs; [
    clang-tools
    cmake
    # TODO: switch back to unstable when the build succeeds
    stable.cmake-language-server
    lldb
  ];
}
