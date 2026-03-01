{ ... }:
{
  imports = [
    ../_mixins/base
    ../_mixins/base/home-manager.nix

    ../_mixins/desktop
    ../_mixins/desktop/gnome
    ../_mixins/desktop/gaming.nix
  ];

  home = {
    username = "kimmy";
    homeDirectory = "/home/kimmy";
    stateVersion = "23.11";
  };
}
