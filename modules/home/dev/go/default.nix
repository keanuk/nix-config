{ config, ... }:
{
  flake.modules.homeManager.go =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        go
        delve
        gopls
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.go;
}
