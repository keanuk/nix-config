{...}: {
  imports = [
    ../common/base/default.nix
    ../common/base/home-manager.nix
    ../common/base/server.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "25.05";
  };
}
