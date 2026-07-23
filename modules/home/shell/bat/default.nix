{
  flake.modules.homeManager.shell =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      noctaliaEnabled = config.programs.noctalia.enable or false;
    in
    {
      programs.bat = {
        enable = true;
        package = pkgs.bat;
        config = {
          # Noctalia renders ~/.config/bat/themes/noctalia.tmTheme from the wallpaper.
          theme = lib.mkDefault (if noctaliaEnabled then "noctalia" else "Catppuccin Mocha");
        };
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batgrep
          batman
          batpipe
          batwatch
          prettybat
        ];
      };
    };
}
