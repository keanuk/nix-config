{ config, ... }:
{
  configurations.darwin.salacia.module = {
    imports =
      (with config.flake.modules.darwin; [
        base
        homebrew-aarch
        keanu
        home-manager
      ])
      ++ [ ./_hardware-configuration.nix ];

    networking.hostName = "salacia";
    nixpkgs.hostPlatform = "aarch64-darwin";

    homebrew.caskArgs.appdir = "/Volumes/SALACIA-EXT/Applications";

    system.stateVersion = 6;
  };
}
