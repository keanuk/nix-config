{ config, inputs, ... }:
{
  configurations.nixos.phoebe.module =
    { lib, ... }:
    {
      imports = (
        with config.flake.modules.nixos;
        [
          base
          amd
          hardware
          lanzaboote
          laptop
          desktop
          cosmic
          svc-btrfs
          svc-ollama
          svc-ollama-full
          user-keanu
          home-manager
        ]
      )
      ++ [
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
