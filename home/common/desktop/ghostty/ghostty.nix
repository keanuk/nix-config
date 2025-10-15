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
      theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";
      font-size = lib.mkDefault 13;
      font-family = "RobotoMono Nerd Font";
      background-blur = lib.mkDefault true;
    };
  };
}
