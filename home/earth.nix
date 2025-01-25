{ ... }:

{
  imports = [
    ./base/default.nix
    ./base/home-manager.nix

    ./shell/packages.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "23.11";
  };
}
