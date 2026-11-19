{ config, ... }:
{
  configurations.darwin.salacia.homeUsers.keanu = {
    imports = with config.flake.modules.homeManager; [
      darwin-profile
      sops
    ];
    home.stateVersion = "25.11";
  };
}
