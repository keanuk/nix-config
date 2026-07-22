{
  flake.modules.homeManager.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      noctaliaEnabled = config.programs.noctalia.enable or false;
    in
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
          theme = lib.mkDefault (
            if noctaliaEnabled then "noctalia" else "dark:Catppuccin Mocha,light:Catppuccin Latte"
          );
          font-size = lib.mkDefault 13;
          font-family = "RobotoMono Nerd Font";
          background-blur = lib.mkDefault true;
        };
      };
    };
}
