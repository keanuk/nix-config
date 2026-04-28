{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.kitty = {
        enable = true;
        package = pkgs.kitty;
        themeFile = "Catppuccin-Mocha";
      };
    };
}
