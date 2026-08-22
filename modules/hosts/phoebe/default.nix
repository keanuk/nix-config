{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    amd
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
    home-manager
    nfs-data
    ;
in
{
  configurations.nixos.phoebe.module =
    { lib, ... }:
    {
      imports = [
        base
        amd
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
        home-manager
        nfs-data
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
        ./_hardware-configuration.nix
        ./_disko-btrfs.nix
      ];

      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = "phoebe";

      services.ollama.rocmOverrideGfx = lib.mkForce "11.0.2";

      system.stateVersion = "25.11";
    };
}
