{ ... }:

{
  imports = [
    ./default.nix
    ./desktop/default.nix
    ./desktop/gnome.nix
    ./desktop/hyprland/default.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "24.05";
  };
}
