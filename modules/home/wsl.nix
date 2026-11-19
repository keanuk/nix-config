{ config, ... }:
let
  inherit (config.flake.modules.homeManager)
    base
    dev
    opencode
    ;
in
{
  flake.modules.homeManager.wsl =
    { lib, ... }:
    {
      imports = [
        base
        dev
        opencode
      ];

      home = {
        username = lib.mkDefault "keanu";
        homeDirectory = lib.mkDefault "/home/keanu";
      };
    };
}
