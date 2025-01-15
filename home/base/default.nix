{ inputs, nix-colors, ... }:

{
  imports = [
    nix-colors.homeManagerModules.default
    inputs.catppuccin.homeManagerModules.catppuccin

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
  catppuccin.flavor = "mocha";
  catppuccin.enable = true;
}
