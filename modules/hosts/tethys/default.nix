{ config, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    hardware
    intel
    pc
    systemd-boot
    desktop
    niri
    umbriel
    noctalia
    btrfs
    keanu
    swapfile
    fs
    home-manager
    nfs-data
    ;
in
{
  configurations.nixos.tethys.module = {
    imports = [
      base
      hardware
      intel
      pc
      systemd-boot
      desktop
      niri
      umbriel
      noctalia
      btrfs
      keanu
      swapfile
      fs
      home-manager
      nfs-data
      ./_hardware-configuration.nix
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "tethys";

    system.stateVersion = "23.05";
  };
}
