{ ... }:

{
  imports = [
    ./base/default.nix

    ./shell/packages.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/Users/keanu";
    stateVersion = "24.05";
  };
}
