{ pkgs, ... }:

{
  imports = [
    ./c.nix
    ./flutter.nix
    ./go.nix
    ./haskell.nix
    ./java.nix
    ./lua.nix
    ./markup.nix
    ./nix.nix
    ./node.nix
    ./python.nix
    ./rust.nix
    ./zig.nix
  ];

  environment.systemPackages = with pkgs; [
    bash-language-server
    devenv
    gcc
    shellcheck

    libGL
    libxkbcommon
    pkg-config
    vulkan-loader
    vulkan-tools
    wayland
    wgpu-utils

    xorg.libX11
    xorg.libxcb
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
  ];

  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.libxkbcommon.dev}/lib/pkgconfig";
  };
}
