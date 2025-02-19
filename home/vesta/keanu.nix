{ ... }:

{
  imports = [
    ../common/base/default.nix

    ../common/darwin/default.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/Users/keanu";
    stateVersion = "24.05";
  };
}
