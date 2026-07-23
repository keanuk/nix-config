{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    hardware
    lanzaboote
    laptop
    desktop
    niri
    noctalia
    btrfs
    keanu
    home-manager
    ;
in
{
  configurations.nixos.miranda.module = {
    imports = [
      base
      hardware
      lanzaboote
      laptop
      desktop
      niri
      noctalia
      btrfs
      keanu
      home-manager
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./_hardware-configuration.nix
      ./_disko-configuration.nix
    ];

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
    networking.hostName = "miranda";
    system.stateVersion = "25.05";
  };
}
