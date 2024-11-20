{ ... }:

{
  imports = [
    ./base/default.nix
    ./base/home-manager.nix

    # ./desktop/hyprland/default.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "23.11";
  };
}
