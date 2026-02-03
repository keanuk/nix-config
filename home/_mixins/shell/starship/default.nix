{
  pkgs,
  lib,
  ...
}:
{
  programs.starship = {
    enable = true;
    package = pkgs.starship;
    enableTransience = true;
    enableInteractive = true;
    enableBashIntegration = false;
    enableFishIntegration = true;
    enableNushellIntegration = false;
    enableZshIntegration = false;
    settings = lib.importTOML ./starship.toml;
  };
}
