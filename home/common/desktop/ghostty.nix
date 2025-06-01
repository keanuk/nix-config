{
  pkgs,
  lib,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;
    settings = {
      theme = "dark:catppuccin-mocha,light:catppuccin-latte";
      font-size = lib.mkDefault 12;
      font-family = "RobotoMono Nerd Font";
    };
  };
}
