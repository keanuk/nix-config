{pkgs, ...}: {
  programs.zoxide = {
    enable = true;
    package = pkgs.zoxide;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
