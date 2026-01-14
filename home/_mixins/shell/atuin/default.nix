{
  pkgs,
  lib,
  ...
}:
{
  programs.atuin = {
    enable = true;
    package = pkgs.atuin;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    daemon.enable = lib.mkDefault true;
    settings = {
      style = "auto";
    };
  };
}
