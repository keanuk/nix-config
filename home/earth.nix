{ ... }:

{
  imports = [
    ./default.nix
    ./desktop/hyprland/default.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "23.11";
  };
}
