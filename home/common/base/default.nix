{ inputs, ... }:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin

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

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  # TODO: remove when issue is resolved https://github.com/catppuccin/nix/issues/552
  catppuccin.mako.enable = false;
}
