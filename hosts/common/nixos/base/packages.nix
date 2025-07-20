{pkgs, ...}: {
  programs = {
    fish.enable = true;
    zsh.enable = true;

    nix-ld = {
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
  };

  services.atuin.enable = true;

  environment.sessionVariables = {};

  environment.systemPackages = with pkgs; [
    acpid
    bcachefs-tools
    busybox
    cachix
    dmidecode
    hwdata
    iptables
    libsecret
    linux-wifi-hotspot
    lsof
    pciutils
    polkit
    psmisc
    sbctl
    smartmontools
    snapper
    tpm2-tools
    tpm2-tss
    usbutils
    util-linux
    wireguard-tools
  ];
}
