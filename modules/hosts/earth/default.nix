{ config, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    hardware
    intel
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
      intel
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
      ./_disko-configuration.nix
      ./_hardware-configuration.nix
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "earth";
    system.stateVersion = "23.11";
  };
}
