{ ... }:

{
  imports = [
    ./base/default.nix

    ./darwin/default.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/Users/keanu";
    stateVersion = "24.05";
  };
}
