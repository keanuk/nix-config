{ pkgs, ... }:
{
  programs.pay-respects = {
    enable = true;
    package = pkgs.pay-respects;
    enableBashIntegration = false;
    enableFishIntegration = true;
    enableNushellIntegration = false;
    enableZshIntegration = false;
  };
}
