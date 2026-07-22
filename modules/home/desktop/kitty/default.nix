{
  flake.modules.homeManager.desktop =
    { pkgs, config, ... }:
    let
      noctaliaEnabled = config.programs.noctalia.enable or false;
    in
    {
      programs.kitty = {
        enable = true;
        package = pkgs.kitty;
        themeFile = if noctaliaEnabled then null else "Catppuccin-Mocha";
      };
    };
}
