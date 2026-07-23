{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    hardware
    pc
    rtw88-fix
    systemd-boot
    desktop
    niri
    noctalia
    btrfs
    ollama
    keanu
    home-manager
    ;
in
{
  configurations.nixos.earth.module = {
    imports = [
      base
      hardware
      pc
      rtw88-fix
      systemd-boot
      desktop
      niri
      noctalia
      btrfs
      ollama
      keanu
      home-manager
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./_disko-configuration.nix
      ./_hardware-configuration.nix
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
    networking.hostName = "earth";
    system.stateVersion = "23.11";
  };
}
