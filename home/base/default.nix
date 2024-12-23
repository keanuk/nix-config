{ nix-colors, ... }:

{
  imports = [
    nix-colors.homeManagerModules.default

    ../shell/default.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.home-manager = {
    enable = true;
    path = "$HOME/.config/nix-config";
  };

  news.display = "notify";

  home = {
    sessionVariables = {
      # EDITOR = "micro";
      # SYSTEMD_EDITOR = "micro";
      # VISUAL = "micro";
    };
  };

  colorScheme = nix-colors.colorSchemes.catppuccin-mocha;
}
