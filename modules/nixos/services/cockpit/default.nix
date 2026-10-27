{ config, ... }:
let
  d = config.domains;
  cockpitDomain = "${d.services.cockpit.subdomain}.${d.primary}";
in
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
        port = d.services.cockpit.backendPort;
        settings = {
          WebService = {
            Origins = lib.mkForce "https://localhost:9090 https://${config.networking.hostName}:9090 wss://${config.networking.hostName}:9090 https://${cockpitDomain} wss://${cockpitDomain}";
          };
        };
      };
    };

  flake.modules.nixos.server = config.flake.modules.nixos.cockpit;
}
