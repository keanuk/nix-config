{ pkgs, ... }:
{
  programs.carapace = {
    enable = true;
    package = pkgs.carapace;
    enableBashIntegration = false;
    enableFishIntegration = true;
    enableNushellIntegration = false;
    enableZshIntegration = false;
  };
}
