{ ... }:

{
  imports = [
    ./default.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "24.05";
  };
}
