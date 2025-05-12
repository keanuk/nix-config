{pkgs, ...}: {
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    package = pkgs.atuin;
    settings = {
      style = "auto";
    };
  };
}
