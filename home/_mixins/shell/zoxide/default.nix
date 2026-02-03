{ pkgs, ... }:
{
  programs.zoxide = {
    enable = true;
    package = pkgs.zoxide;
    enableBashIntegration = false;
    enableFishIntegration = true;
    enableNushellIntegration = false;
    enableZshIntegration = false;
  };
}
