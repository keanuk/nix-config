{pkgs, ...}: {
  programs.broot = {
    enable = true;
    package = pkgs.broot;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    settings = {
      modal = true;
    };
  };
}
