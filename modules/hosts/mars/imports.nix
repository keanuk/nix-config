{ config, ... }:
{
  configurations.nixos.mars.module = {
    imports =
      with config.flake.modules.nixos;
      [
        wsl
        keanu
        home-manager
      ]
      ++ [ ./_hardware-configuration.nix ];

    nixpkgs.hostPlatform = "aarch64-linux";
    networking.hostName = "mars";
    system.stateVersion = "25.11";
  };
}
