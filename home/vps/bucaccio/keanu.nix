{ ... }:
{
  imports = [
    ../../_mixins/base/vps.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "25.11";
  };
}
