{ ... }:

{
  imports = [
    ./base/default.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/Users/keanu";
    stateVersion = "24.05";
  };
}
