{ config, ... }:
{
  configurations.darwin.vesta.module = {
    imports = (
      with config.flake.modules.darwin;
      [
        base
        homebrew
        keanu
        home-manager
      ]
    )
    ++ [ ./_hardware-configuration.nix ];

    networking.hostName = "vesta";
    nixpkgs.hostPlatform = "x86_64-darwin";

    system.stateVersion = 4;
  };
}
