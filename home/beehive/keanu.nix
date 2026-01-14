{ ... }:
{
  imports = [
    ../_mixins/base
    ../_mixins/base/home-manager.nix
    ../_mixins/base/server.nix
    ../_mixins/desktop/pass
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "25.05";
  };
}
