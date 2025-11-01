{...}: {
  imports = [
    ../_mixins/base/default.nix
    ../_mixins/base/home-manager.nix

    ../_mixins/desktop/default.nix
    ../_mixins/desktop/cosmic/default.nix
    ../_mixins/desktop/gnome/default.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "25.05";
  };
}
