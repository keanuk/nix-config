{ pkgs, ... }:

let
  libPath = with pkgs; lib.makeLibraryPath [
    libGL
    libxkbcommon
    wayland
  ];
in
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
    wayland

    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
  ];

  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.libxkbcommon.dev}/lib/pkgconfig";
    # LD_LIBRARY_PATH = libPath;
  };
}
