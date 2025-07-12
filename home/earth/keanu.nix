{...}: {
  imports = [
    ../common/base/default.nix
    ../common/base/home-manager.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "23.11";
  };
}
