{ config, inputs, ... }:
{
  configurations.nixos.titan.module =
    { lib, ... }:
    {
      imports =
        (with config.flake.modules.nixos; [
          base
          amd
          hardware
          lanzaboote
          pc
          rtw88-fix
          desktop
          cosmic
          btrfs
          ollama
          ollama-full
          keanu
          swapfile
          fs
          home-manager
        ])
        ++ [
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          inputs.nixos-hardware.nixosModules.common-gpu-amd
          inputs.nixos-hardware.nixosModules.common-pc
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          ./_hardware-configuration.nix
        ];

      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = "titan";

      services.ollama.rocmOverrideGfx = lib.mkForce "10.3.0";

      system.stateVersion = "23.05";
    };
}
