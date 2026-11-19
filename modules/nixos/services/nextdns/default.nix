# NOTE: Not imported by any host; kept intentionally for future use.
{
  flake.modules.nixos.nextdns =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      sops.secrets.nextdns_id = {
        mode = "0400";
      };

      # Disable the built-in nextdns module as we're using a custom service
      # that reads the profile ID from sops at runtime
      services.nextdns.enable = lib.mkForce false;

      environment.systemPackages = with pkgs; [
        nextdns
      ];

      # Custom nextdns service that reads profile ID from sops secret
      systemd.services.nextdns = {
        description = "NextDNS DNS/DNS-over-HTTPS proxy";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = "5s";
          DynamicUser = true;
          LoadCredential = "nextdns_id:${config.sops.secrets.nextdns_id.path}";
          AmbientCapabilities = "CAP_NET_BIND_SERVICE";
          CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        };

        script = ''
          PROFILE_ID=$(tr -d '\n\r' < "$CREDENTIALS_DIRECTORY/nextdns_id")
          exec ${pkgs.nextdns}/bin/nextdns run -profile "$PROFILE_ID" -listen localhost:53
        '';
      };
    };
}
