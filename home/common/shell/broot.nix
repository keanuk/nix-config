{pkgs, ...}: {
  programs.broot = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    package = pkgs.broot;
    settings = {
      modal = true;
    };
  };
}
