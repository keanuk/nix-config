{
  config,
  lib,
  pkgs,
  ...
}: let
  tunnelId = "586f6d2e-b360-4f89-a667-5068d2e70f9e";
in {
  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
    description = "Cloudflare Tunnel daemon user";
  };

  users.groups.cloudflared = {};

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
          "auth.oranos.me" = "http://localhost:9092";

          "oranos.me" = "http://localhost:9094";
          "chat.oranos.me" = "http://localhost:9095"; # Open WebUI via Authelia
          "photos.oranos.me" = "http://localhost:9096"; # Immich via Authelia
          "media.oranos.me" = "http://localhost:9097"; # Jellyfin via Authelia
          "audio.oranos.me" = "http://localhost:9098"; # Audiobookshelf via Authelia
          "plex.oranos.me" = "http://localhost:9099"; # Plex via Authelia

          "sonarr.oranos.me" = "http://localhost:9100";
          "radarr.oranos.me" = "http://localhost:9101"; # Radarr via Authelia
          "lidarr.oranos.me" = "http://localhost:9102"; # Lidarr via Authelia
          "prowlarr.oranos.me" = "http://localhost:9103"; # Prowlarr via Authelia
          "bazarr.oranos.me" = "http://localhost:9104"; # Bazarr via Authelia

          "home.oranos.me" = "http://localhost:9105";
          "git.oranos.me" = "http://localhost:9106"; # GitLab via Authelia
          "cloud.oranos.me" = "http://localhost:9107"; # Nextcloud via Authelia
          "code.oranos.me" = "http://localhost:9108"; # OpenVSCode Server via Authelia
          "cockpit.oranos.me" = "http://localhost:9109"; # Cockpit via Authelia
        };
      };
    };
  };

      Group = lib.mkForce "cloudflared";
      Environment = "TUNNEL_EDGE_IP_VERSION=4";
    };
  };
}
