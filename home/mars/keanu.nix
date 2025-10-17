{...}: {
  imports = [
    ../common/base/default.nix
    ../common/base/home-manager.nix
    ../common/base/wsl.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "25.11";
  };
}
