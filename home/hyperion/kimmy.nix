{...}: {
  imports = [
    ../_mixins/base/default.nix
    ../_mixins/base/home-manager.nix

    ../_mixins/desktop/default.nix
    ../_mixins/desktop/gnome/default.nix
  ];

  home = {
    username = "kimmy";
    homeDirectory = "/home/kimmy";
    stateVersion = "23.11";
  };
}
