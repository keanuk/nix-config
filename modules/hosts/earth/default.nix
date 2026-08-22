{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    hardware
    pc
    rtw88
    systemd-boot
    desktop
    niri
    noctalia
    btrfs
    ollama
    keanu
    home-manager
    nfs-data
    ;
in
{
  configurations.nixos.earth.module = {
    imports = [
      base
      hardware
      pc
      rtw88
      systemd-boot
      desktop
      niri
      noctalia
      btrfs
      ollama
      keanu
      home-manager
      nfs-data
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./_disko-configuration.nix
      ./_hardware-configuration.nix
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "earth";
    system.stateVersion = "23.11";
  };
}
