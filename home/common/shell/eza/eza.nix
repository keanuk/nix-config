{pkgs, ...}: {
  programs.eza = {
    enable = true;
    package = pkgs.eza;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
