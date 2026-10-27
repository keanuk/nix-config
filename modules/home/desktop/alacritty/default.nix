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
      programs.alacritty = {
        enable = true;
        package = pkgs.alacritty;
        settings = {
          window = {
            decorations = "none";
            dynamic_padding = true;
            padding = {
              x = 5;
              y = 5;
            };
            startup_mode = "Maximized";
          };
          # Noctalia renders ~/.config/alacritty/themes/noctalia.toml from the wallpaper.
          general = lib.mkIf noctaliaEnabled { import = [ "themes/noctalia.toml" ]; };
        };
      };
    };
}
