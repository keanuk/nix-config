{
  flake.modules.homeManager.desktop =
    {
      pkgs,
      lib,
      ...
    }:
    {
      programs.ghostty = {
        enable = true;
        package = lib.mkDefault pkgs.ghostty;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        installBatSyntax = lib.mkDefault true;
        installVimSyntax = lib.mkDefault true;
        settings = {
          theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";
          font-size = lib.mkDefault 13;
          font-family = "RobotoMono Nerd Font";
          background-blur = lib.mkDefault true;
        };
      };
    };
}
