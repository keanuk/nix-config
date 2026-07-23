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
        theme = {
          flavor = {
            # Noctalia renders ~/.config/yazi/flavors/noctalia.yazi from the wallpaper.
            use = lib.mkDefault (if noctaliaEnabled then "noctalia" else "catppuccin-mocha");
          };
        };
      };
    };
}
