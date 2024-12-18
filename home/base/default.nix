{ ... }:

{
  imports = [
    ../shell/default.nix
    # ./theme/stylix.nix
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
}
