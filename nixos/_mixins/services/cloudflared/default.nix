{config, pkgs, ...}: let
  tunnelId = "586f6d2e-b360-4f89-a667-5068d2e70f9e";
  credentialsPath = config.sops.secrets.cloudflared-tunnel-credentials.path;

  # Generate the cloudflared config file
  configFile = pkgs.writeText "cloudflared.yml" (builtins.toJSON {
    tunnel = tunnelId;
    credentials-file = credentialsPath;
    ingress = [
      {
        hostname = "nextcloud.oranos.me";
        service = "http://localhost:80";
      }
      {
        hostname = "immich.oranos.me";
        service = "http://localhost:2283";
      }
      {
        hostname = "homeassistant.oranos.me";
        service = "http://localhost:8123";
      }
      {
        hostname = "openwebui.oranos.me";
        service = "http://localhost:11435";
      }
      # {
      #   hostname = "cockpit.oranos.me";
      #   service = "https://localhost:9090";
      #   originRequest.noTLSVerify = true;
      # }
      {
        hostname = "jellyfin.oranos.me";
        service = "http://localhost:8096";
      }
      {
        hostname = "audiobooks.oranos.me";
        service = "http://localhost:8000";
      }
      {
        hostname = "plex.oranos.me";
        service = "http://localhost:32400";
      }
      {
        service = "http_status:404";
      }
    ];
  });
in {
  # Define the cloudflared service manually to avoid LoadCredential issues
  systemd.services.cloudflared-tunnel = {
    description = "Cloudflare Tunnel for beehive";
    after = ["network-online.target" "sops-nix.service"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = "${pkgs.unstable.cloudflared}/bin/cloudflared tunnel --config=${configFile} --no-autoupdate run";
      Restart = "on-failure";
      RestartSec = "5s";
      # Run as a dedicated user instead of DynamicUser to work with sops-nix
      User = "cloudflared";
      Group = "cloudflared";
    };

    environment = {
      TUNNEL_EDGE_IP_VERSION = "4";
    };
  };

  # Create the cloudflared user and group
  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
    description = "Cloudflare Tunnel daemon user";
  };

  users.groups.cloudflared = {};

  # Configure sops secret with correct ownership
  sops.secrets.cloudflared-tunnel-credentials = {
    owner = "cloudflared";
    group = "cloudflared";
    mode = "0400";
  };
}
