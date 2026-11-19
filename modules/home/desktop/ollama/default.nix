{ config, ... }:
{
  flake.modules.homeManager.ollama =
    { pkgs, ... }:
    {
      services.ollama = {
        enable = false;
        package = pkgs.unstable.ollama;
        port = 11434;
        acceleration = null;
      };
    };

  flake.modules.homeManager.desktop = config.flake.modules.homeManager.ollama;
}
