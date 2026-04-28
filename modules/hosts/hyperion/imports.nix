{ config, inputs, ... }:
{
  configurations.nixos.hyperion.module =
    { lib, ... }:
    {
      imports = (
        with config.flake.modules.nixos;
        [
          base
          hardware
          lanzaboote
          laptop
          desktop
          pantheon
          svc-btrfs
          user-keanu
          user-kimmy
          swapfile
          fs
          home-manager
        ]
      )
      ++ [
        inputs.nixos-hardware.nixosModules.hp-elitebook-845g8
        ./_hardware-configuration.nix
      ];

      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = "hyperion";

      i18n = {
        defaultLocale = lib.mkForce "en_US.UTF-8";
        extraLocaleSettings = lib.mkForce {
          LC_ALL = "en_US.UTF-8";
        };
      };

      system.stateVersion = "23.05";
    };
}
