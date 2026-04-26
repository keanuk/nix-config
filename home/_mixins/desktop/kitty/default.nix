{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    themeFile = "Catppuccin-Mocha";
  };
}
