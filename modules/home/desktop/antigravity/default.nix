{
  flake.modules.homeManager.desktop =
    { pkgs, config, ... }:
    let
      noctaliaEnabled = config.programs.noctalia.enable or false;
    in
    {
      programs.antigravity = {
        enable = true;
        package = pkgs.antigravity-fhs;
        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
          ];
          userSettings = {
            "window.autoDetectColorScheme" = true;
            "workbench.preferredDarkColorTheme" =
              if noctaliaEnabled then "Noctalia Theme" else "Catppuccin Mocha";
            "workbench.preferredLightColorTheme" =
              if noctaliaEnabled then "Noctalia Theme" else "Catppuccin Latte";
            "workbench.iconTheme" = "catppuccin-mocha";
          };
        };
      };
    };
}
