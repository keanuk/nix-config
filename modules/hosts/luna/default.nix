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
    ollama
    ollama-medium
    keanu
    fs
    home-manager
    cellular
    nfs-data
    ;
in
{
  configurations.nixos.luna.module = {
    imports = [
      base
      hardware
      lanzaboote
      laptop
      desktop
      niri
      noctalia
      btrfs
      ollama
      ollama-medium
      keanu
      fs
      home-manager
      cellular
      nfs-data
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen
      ./_disko-btrfs.nix
      ./_hardware-configuration.nix
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "luna";

    system.stateVersion = "26.11";
  };
}
