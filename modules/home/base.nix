{ config, ... }:
{
  flake.modules.homeManager.base = {
    imports = with config.flake.modules.homeManager; [
      shell
    ];

    programs.home-manager = {
      enable = true;
    };

    news.display = "notify";
  };
}
