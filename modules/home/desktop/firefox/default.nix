{ config, ... }:
{
  flake.modules.homeManager.firefox =
    { pkgs, config, ... }:
    {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-devedition;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
      };

      # workaround to allow leetgo to read Firefox cookie
      home.file.".mozilla/firefox".source =
        config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/mozilla/firefox";
    };

  flake.modules.homeManager.desktop = config.flake.modules.homeManager.firefox;
}
