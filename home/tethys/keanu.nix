{...}: {
  imports = [
    ../common/base/default.nix
    ../common/base/home-manager.nix
    ../common/base/server.nix

    ../common/desktop/hyprland/default.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "23.05";
  };
}
