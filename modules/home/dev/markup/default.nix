{ config, ... }:
{
  flake.modules.homeManager.markup =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        marksman
        taplo
        yaml-language-server
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.markup;
}
