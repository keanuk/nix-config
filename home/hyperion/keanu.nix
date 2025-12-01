{...}: {
  imports = [
    ../_mixins/base
    ../_mixins/base/home-manager.nix

    ../_mixins/desktop
    ../_mixins/desktop/cosmic
    ../_mixins/desktop/gnome
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "23.11";
  };
}
