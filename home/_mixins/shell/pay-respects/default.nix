{ pkgs, ... }:
{
  programs.pay-respects = {
    enable = true;
    package = pkgs.pay-respects;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
