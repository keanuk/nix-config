{ ... }:

{
  imports = [
    ./base/default.nix
    ./base/home-manager.nix

    ./desktop/default.nix
    ./desktop/gnome.nix
    # ./desktop/hyprland/default.nix

    ./shell/packages.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "23.11";
  };
}
