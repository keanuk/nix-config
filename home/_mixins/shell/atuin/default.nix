{
  pkgs,
  lib,
  ...
}:
{
  programs.atuin = {
    enable = true;
    package = pkgs.atuin;
    enableBashIntegration = false;
    enableFishIntegration = true;
    enableNushellIntegration = false;
    enableZshIntegration = false;
    daemon.enable = lib.mkDefault true;
    settings = {
      style = "auto";
    };
  };
}
