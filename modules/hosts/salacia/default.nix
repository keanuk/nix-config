{ config, ... }:
let
  inherit (config.flake.modules.darwin)
    base
    homebrew
    keanu
    home-manager
    ;
in
{
  configurations.darwin.salacia.module = {
    imports = [
      base
      homebrew
      keanu
      home-manager
      ./_hardware-configuration.nix
    ];

    networking.hostName = "salacia";
    nixpkgs.hostPlatform = "aarch64-darwin";

    homebrew.caskArgs.appdir = "/Volumes/SALACIA-EXT/Applications";

    system.stateVersion = 6;
  };
}
