{ config, ... }:
let
  inherit (config.flake.modules.homeManager)
    base
    home-manager-self
    dev
    opencode
    ;
in
{
  flake.modules.homeManager.wsl = {
    imports = [
      base
      home-manager-self
      dev
      opencode
    ];

  };
}
