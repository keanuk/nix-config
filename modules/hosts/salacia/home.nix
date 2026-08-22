{ config, ... }:
let
  keanuHome = {
    imports = with config.flake.modules.homeManager; [
      darwin-profile
      sops
    ];
    home.stateVersion = "25.11";
  };
in
{
  configurations.darwin.salacia.module.home-manager.users.keanu = keanuHome;

  configurations.homeManager."keanu@salacia" = {
    system = "aarch64-darwin";
    module = keanuHome;
  };
}
