{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.vscode = {
        enable = true;
        package = pkgs.vscode-fhs;
        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
          ];
          userSettings = {
            "window.autoDetectColorScheme" = true;
            "workbench.preferredDarkColorTheme" = "Catppuccin Mocha";
            "workbench.preferredLightColorTheme" = "Catppuccin Latte";
            "workbench.iconTheme" = "catppuccin-mocha";
          };
        };
      };
    };
}
