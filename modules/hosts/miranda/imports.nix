{ config, inputs, ... }:
{
  configurations.nixos.miranda.module = {
    imports =
      (with config.flake.modules.nixos; [
        base
        hardware
        lanzaboote
        laptop
        desktop
        cosmic
        btrfs
        keanu
        home-manager
      ])
      ++ [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        inputs.nixos-hardware.nixosModules.common-pc-laptop
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        ./_hardware-configuration.nix
        ./_disko-configuration.nix
      ];

    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "miranda";
    system.stateVersion = "25.05";
  };
}
