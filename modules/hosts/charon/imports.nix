{ config, ... }:
{
  configurations.darwin.charon.module = {
    imports = (
      with config.flake.modules.darwin;
      [
        base
        homebrew
        user-keanu
        home-manager
      ]
    )
    ++ [ ./_hardware-configuration.nix ];

    networking.hostName = "charon";
    nixpkgs.hostPlatform = "x86_64-darwin";

    system.stateVersion = 4;
  };
}
