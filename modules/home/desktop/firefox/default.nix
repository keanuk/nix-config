{
  flake.modules.homeManager.desktop =
    { pkgs, config, ... }:
    {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-devedition;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
      };

      # workaround to allow leetgo to read Firefox cookie
      home.file.".mozilla/firefox".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/mozilla/firefox";
    };
}
