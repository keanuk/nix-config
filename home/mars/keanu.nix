{...}: {
  imports = [
    ../common/base/default.nix
    ../common/base/home-manager.nix

    ../common/wsl/default.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "25.11";
  };
}
