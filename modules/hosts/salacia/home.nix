{ config, ... }:
let
  hmRoles = with config.flake.modules.homeManager; [
    darwin-profile
    sops
  ];

  salaciaKeanuHome =
    { ... }:
    {
      imports = hmRoles;

      home.stateVersion = "25.11";
    };
in
{
  configurations.darwin.salacia.module.home-manager.users.keanu = salaciaKeanuHome;

  configurations.homeManager."keanu@salacia" = {
    system = "aarch64-darwin";
    module = salaciaKeanuHome;
  };
}
