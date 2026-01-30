{
  config,
  lib,
  pkgs,
  ...
}:
let
  tunnelId = "c7967aa7-6b7a-4f93-bb49-7663fe2ab21b";
in
{
  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
    description = "Cloudflare Tunnel daemon user";
  };

  users.groups.cloudflared = { };

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
          "auth.oranos.org" = "http://localhost:9092"; # Authelia

          "oranos.org" = "http://localhost:9094"; # Dashy
          "chat.oranos.org" = "http://localhost:9095"; # Open WebUI
          "photos.oranos.org" = "http://localhost:9096"; # Immich
          "media.oranos.org" = "http://localhost:9097"; # Jellyfin
          "audio.oranos.org" = "http://localhost:9098"; # Audiobookshelf
          "plex.oranos.org" = "http://localhost:9099"; # Plex

          "sonarr.oranos.org" = "http://localhost:9100"; # Sonarr
          "radarr.oranos.org" = "http://localhost:9101"; # Radarr
          "lidarr.oranos.org" = "http://localhost:9102"; # Lidarr
          "prowlarr.oranos.org" = "http://localhost:9103"; # Prowlarr
          "bazarr.oranos.org" = "http://localhost:9104"; # Bazarr

          "home.oranos.org" = "http://localhost:9105"; # Home Assistant
          "git.oranos.org" = "http://localhost:9106"; # GitLab
          "cloud.oranos.org" = "http://localhost:9107"; # Nextcloud
          "code.oranos.org" = "http://localhost:9108"; # OpenVSCode Server
          "cockpit.oranos.org" = "http://localhost:9109"; # Cockpit
        };
      };
    };
  };

  systemd.services."cloudflared-tunnel-${tunnelId}" = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = lib.mkForce "cloudflared";
      Group = lib.mkForce "cloudflared";
      Environment = "TUNNEL_EDGE_IP_VERSION=4";
    };
  };
}
