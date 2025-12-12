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
          # Authelia authentication portal - direct access
          "auth.oranos.me" = "http://localhost:9092";

          # Services protected by Authelia (routed through nginx with auth_request)
          "oranos.me" = "http://localhost:9094"; # Dashy via Authelia
          "chat.oranos.me" = "http://localhost:9095"; # Open WebUI via Authelia
          "photos.oranos.me" = "http://localhost:9096"; # Immich via Authelia
          "media.oranos.me" = "http://localhost:9097"; # Jellyfin via Authelia
          "audio.oranos.me" = "http://localhost:9098"; # Audiobookshelf via Authelia
          "plex.oranos.me" = "http://localhost:9099"; # Plex via Authelia

          # *arr services protected by Authelia
          "sonarr.oranos.me" = "http://localhost:9100"; # Sonarr via Authelia
          "radarr.oranos.me" = "http://localhost:9101"; # Radarr via Authelia
          "lidarr.oranos.me" = "http://localhost:9102"; # Lidarr via Authelia
          "prowlarr.oranos.me" = "http://localhost:9103"; # Prowlarr via Authelia
          "bazarr.oranos.me" = "http://localhost:9104"; # Bazarr via Authelia

          # Services with their own auth, now also protected by Authelia (2FA required)
          "home.oranos.me" = "http://localhost:9105"; # Home Assistant via Authelia
          "git.oranos.me" = "http://localhost:9106"; # GitLab via Authelia
          "cloud.oranos.me" = "http://localhost:9107"; # Nextcloud via Authelia
          "code.oranos.me" = "http://localhost:9108"; # OpenVSCode Server via Authelia
          "cockpit.oranos.me" = "http://localhost:9109"; # Cockpit via Authelia
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
