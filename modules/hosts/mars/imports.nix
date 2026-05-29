{ config, ... }:
let
  inherit (config.flake.modules.nixos)
    wsl
    keanu
    home-manager
    ;
in
{
  configurations.nixos.mars.module = {
    imports = [
      wsl
      keanu
      home-manager
      ./_hardware-configuration.nix
    ];

    nixpkgs.hostPlatform = "aarch64-linux";
    networking.hostName = "mars";
    system.stateVersion = "25.11";
  };
}
