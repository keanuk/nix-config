{
  pkgs,
  lib,
  ...
}: {
  programs.starship = {
    enable = true;
    package = pkgs.starship;
    enableTransience = true;
    enableInteractive = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    settings = lib.importTOML ../config/starship.toml;
  };
}
