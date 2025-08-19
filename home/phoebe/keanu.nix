{...}: {
  imports = [
    ../common/base/default.nix
    ../common/base/home-manager.nix

    ../common/desktop/default.nix
    ../common/desktop/gnome/gnome.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "25.11";
  };
}
