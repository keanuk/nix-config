{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    amd
    hardware
    pc
    lanzaboote
    desktop
    niri
    noctalia
    btrfs
    ollama
    ollama-medium
    keanu
    home-manager
    nfs-data
    ;
in
{
  configurations.nixos.beehive.module = {
    imports = [
      base
      amd
      hardware
      pc
      lanzaboote
      desktop
      niri
      noctalia
      btrfs
      ollama
      ollama-medium
      keanu
      home-manager
      nfs-data
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./_hardware-configuration.nix
      ./_disko-configuration.nix
    ];

    fileSystems = {
      # USB SSD mounts (non-blocking if disconnected)
      "/mnt/ssd-1t-1" = {
        device = "/dev/disk/by-label/ssd-1t-1";
        fsType = "btrfs";
        options = [
          "rw"
          "noatime"
          "nofail"
          "x-systemd.automount"
        ];
      };

      "/mnt/ssd-1t-2" = {
        device = "/dev/disk/by-label/ssd-1t-2";
        fsType = "btrfs";
        options = [
          "rw"
          "noatime"
          "nofail"
          "x-systemd.automount"
        ];
      };
    };

    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "beehive";

    system.stateVersion = "26.11";
  };
}
