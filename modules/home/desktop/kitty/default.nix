{
  flake.modules.homeManager.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      noctaliaEnabled = config.theme.noctaliaManaged;
    in
    {
      programs.kitty = {
        enable = true;
        package = pkgs.kitty;
        # Noctalia renders ~/.config/kitty/themes/noctalia.conf from the wallpaper.
        themeFile = if noctaliaEnabled then null else "Catppuccin-Mocha";
        extraConfig = lib.optionalString noctaliaEnabled "include themes/noctalia.conf";
      };
    };
}
