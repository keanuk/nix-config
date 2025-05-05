{ ... }:

{
  imports = [
    ../common/base/default.nix
    ../common/base/home-manager.nix

    ../common/desktop/default.nix
    ../common/desktop/gnome.nix
    # ../common/desktop/hyprland/default.nix

    ../common/shell/packages.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "25.05";
  };
}
