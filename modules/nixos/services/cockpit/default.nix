{ config, ... }:
let
  d = config.domains;
  cockpitDomain = "${d.services.cockpit.subdomain}.${d.primary}";
  cockpitPort = toString d.services.cockpit.backendPort;
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
            Origins = lib.mkForce "https://localhost:${cockpitPort} https://${config.networking.hostName}:${cockpitPort} wss://${config.networking.hostName}:${cockpitPort} https://${cockpitDomain} wss://${cockpitDomain}";
          };
        };
      };
    };

  flake.modules.nixos.server = config.flake.modules.nixos.cockpit;
}
