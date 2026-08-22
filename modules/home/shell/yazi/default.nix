{
  flake.modules.homeManager.shell =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      noctaliaEnabled = config.programs.noctalia.enable or false;
    in
    {
      programs.yazi = {
        enable = true;
        package = pkgs.yazi;
        enableBashIntegration = false;
        enableFishIntegration = true;
        enableNushellIntegration = false;
        enableZshIntegration = false;
        shellWrapperName = "y";
        # Noctalia renders ~/.config/yazi/flavors/noctalia.yazi from the wallpaper.
        # No other flavor is installed, so leave yazi on its built-in theme elsewhere.
        theme = lib.mkIf noctaliaEnabled {
          flavor.use = lib.mkDefault "noctalia";
        };
      };
    };
}
