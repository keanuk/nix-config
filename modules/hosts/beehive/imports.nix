{ config, inputs, ... }:
{
  configurations.nixos.beehive.module = {
    imports =
      (with config.flake.modules.nixos; [
        base
        amd
        hardware
        server
        systemd-boot
        btrfs
        ollama
        ollama-full
        keanu
        home-manager
        github-runner
      ])
      ++ [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-pc
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        ./_hardware-configuration.nix
        ./_disko-configuration.nix
        ./_raid-configuration.nix
        ./_shares.nix
        ./_github-runner.nix
      ];

    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "beehive";

    system.stateVersion = "25.05";
  };
}
