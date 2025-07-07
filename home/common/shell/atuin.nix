{pkgs, ...}: {
  programs.atuin = {
    enable = true;
    package = pkgs.atuin;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    daemon.enable = true;
    settings = {
      style = "auto";
    };
  };
}
