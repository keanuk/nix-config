{
  pkgs,
  lib,
  ...
}: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;
    package = pkgs.ghostty;
    settings = {
      theme = "dark:catppuccin-mocha,light:catppuccin-latte";
      font-size = lib.mkDefault 14;
      font-family = "FiraCode Nerd Font";
    };
  };
}
