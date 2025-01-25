{ pkgs, ... }:

{
  imports = [
    ./c.nix
    ./go.nix
    ./haskell.nix
    ./lua.nix
    ./markup.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
  ];

  environment.systemPackages = with pkgs; [
    bash-language-server
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
