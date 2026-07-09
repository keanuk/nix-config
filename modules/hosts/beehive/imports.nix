{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    amd
    hardware
    pc
    systemd-boot
    desktop
    cosmic
    btrfs
    ollama
    ollama-full
    keanu
    home-manager
    ;
in
{
  configurations.nixos.beehive.module = {
    imports = [
      base
      amd
      hardware
      pc
      systemd-boot
      desktop
      cosmic
      btrfs
      ollama
      ollama-full
      keanu
      home-manager
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./_hardware-configuration.nix
      ./_disko-configuration.nix
    ];

    # Mount ursa's NFS share since RAID is now hosted on ursa
    fileSystems."/mnt/data" = {
      device = "ursa.local:/data";
      fsType = "nfs";
      options = [
        "rw"
        "noatime"
        "_netdev"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
        "x-systemd.mount-timeout=10"
        "x-systemd.requires=tailscaled.service"
        "nfsvers=4"
      ];
    };

    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "beehive";

    system.stateVersion = "25.05";
  };
}
