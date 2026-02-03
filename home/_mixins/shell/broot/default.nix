{ pkgs, ... }:
{
  programs.broot = {
    enable = true;
    package = pkgs.broot;
    enableBashIntegration = false;
    enableFishIntegration = true;
    enableNushellIntegration = false;
    enableZshIntegration = false;
    settings = {
      modal = true;
    };
  };
}
