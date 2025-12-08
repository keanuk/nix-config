{
  config,
  lib,
  pkgs,
  ...
}: let
  tunnelId = "586f6d2e-b360-4f89-a667-5068d2e70f9e";
in {
  # Create the cloudflared user and group explicitly for sops-nix compatibility
  # The native module uses DynamicUser by default, but sops-nix needs the user
  # to exist before the service starts to set file ownership
  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
    description = "Cloudflare Tunnel daemon user";
  };

  users.groups.cloudflared = {};

  # Configure sops secret with correct ownership for cloudflared
  sops.secrets.cloudflared-tunnel-credentials = {
    owner = "cloudflared";
    group = "cloudflared";
    mode = "0400";
  };

  services.cloudflared = {
    enable = true;
    package = pkgs.unstable.cloudflared;
    tunnels = {
      "${tunnelId}" = {
        credentialsFile = config.sops.secrets.cloudflared-tunnel-credentials.path;
        default = "http_status:404";
        ingress = {
          "oranos.me" = "http://localhost:8082";
          "git.oranos.me" = "http://localhost:8929";
          "chat.oranos.me" = "http://localhost:11435";
          "cloud.oranos.me" = "http://localhost:80";
          # "cockpit.oranos.me" = "http://localhost:9090";
          # "code.oranos.me" = "http://localhost:3000";
          "photos.oranos.me" = "http://localhost:2283";
          "home.oranos.me" = "http://localhost:8123";
          "media.oranos.me" = "http://localhost:8096";
          "audio.oranos.me" = "http://localhost:8000";
          "plex.oranos.me" = "http://localhost:32400";
        };
      };
    };
  };

  # Override the systemd service to use our static user instead of DynamicUser
  systemd.services."cloudflared-tunnel-${tunnelId}" = {
    serviceConfig = {
      # Disable DynamicUser and use our static user
      DynamicUser = lib.mkForce false;
      User = lib.mkForce "cloudflared";
      Group = lib.mkForce "cloudflared";
      # Use IPv4 for edge connections
      Environment = "TUNNEL_EDGE_IP_VERSION=4";
    };
  };
}
