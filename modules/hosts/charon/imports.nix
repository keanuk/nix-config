{ config, ... }:
let
  inherit (config.flake.modules.darwin)
    base
    homebrew
    keanu
    home-manager-26-05
    ;
in
{
  configurations.darwin.charon.darwinInput = "darwin-26-05";

  configurations.darwin.charon.module = {
    imports = [
      base
      homebrew
      keanu
      home-manager-26-05
      ./_hardware-configuration.nix
    ];

    networking.hostName = "charon";
    nixpkgs.hostPlatform = "x86_64-darwin";

    system.stateVersion = 4;
  };
}
