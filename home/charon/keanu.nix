{ ... }:

{
  imports = [
    ../common/base/default.nix

    ../common/shell/packages.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/Users/keanu";
    stateVersion = "24.05";
  };
}
