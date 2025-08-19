{...}: {
  imports = [
    ../common/base/default.nix
    ../common/base/home-manager.nix

    ../common/desktop/default.nix
    ../common/desktop/gnome/gnome.nix
  ];

  home = {
    username = "kimmy";
    homeDirectory = "/home/kimmy";
    stateVersion = "23.11";
  };
}
