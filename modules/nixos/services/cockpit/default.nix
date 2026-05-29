{ config, ... }:
{
  flake.modules.nixos.cockpit =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      services.cockpit = {
        enable = true;
        package = pkgs.cockpit;
        openFirewall = true;
        port = 9090;
        settings = {
          WebService = {
            Origins = lib.mkForce "https://localhost:9090 https://${config.networking.hostName}:9090 wss://${config.networking.hostName}:9090 https://cockpit.oranos.org wss://cockpit.oranos.org";
          };
        };
      };

      # TODO: Remove when issue is resolved: https://github.com/trifectatechfoundation/sudo-rs/issues/1249
      security.sudo-rs.enable = lib.mkForce false;
    };

  flake.modules.nixos.server = config.flake.modules.nixos.cockpit;
}
