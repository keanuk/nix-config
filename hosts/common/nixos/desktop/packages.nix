{pkgs, ...}: {

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
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
  };

  environment.systemPackages = with pkgs; [
    distrobox
    gsmartcontrol
    snapper-gui
    wireplumber

    xorg.xkill
  ];
}
