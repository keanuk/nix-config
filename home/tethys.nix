{ ... }:

{
  imports = [
    ./base/default.nix
    ./base/home-manager.nix

    ./desktop/hyprland/default.nix

    ./shell/packages.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "23.05";
  };
}
