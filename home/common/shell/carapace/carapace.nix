{pkgs, ...}: {
  programs.carapace = {
    enable = true;
    package = pkgs.carapace;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
