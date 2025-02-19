{ ... }:

{
  imports = [
    ../common/base/default.nix
    ../common/base/home-manager.nix

    ../common/shell/packages.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "23.11";
  };
}
