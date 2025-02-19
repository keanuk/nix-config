{ ... }:

{
  imports = [
    ../common/base/default.nix
    ../common/base/home-manager.nix

    ../common/desktop/default.nix
    ../common/desktop/gnome.nix
    ../common/desktop/hyprland/default.nix

    ../common/shell/packages.nix
  ];

  home = {
    username = "kimmy";
    homeDirectory = "/home/kimmy";
    stateVersion = "23.11";
  };
}
