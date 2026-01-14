{
  config,
  lib,
  pkgs,
  ...
}:
let
  tunnelId = "586f6d2e-b360-4f89-a667-5068d2e70f9e";
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
          "auth.oranos.me" = "http://localhost:9092";

          "oranos.me" = "http://localhost:9094";
          "chat.oranos.me" = "http://localhost:9095"; # Open WebUI
          "photos.oranos.me" = "http://localhost:9096"; # Immich
          "media.oranos.me" = "http://localhost:9097"; # Jellyfin
          "audio.oranos.me" = "http://localhost:9098"; # Audiobookshelf
          "plex.oranos.me" = "http://localhost:9099"; # Plex

          "sonarr.oranos.me" = "http://localhost:9100";
          "radarr.oranos.me" = "http://localhost:9101"; # Radarr
          "lidarr.oranos.me" = "http://localhost:9102"; # Lidarr
          "prowlarr.oranos.me" = "http://localhost:9103"; # Prowlarr
          "bazarr.oranos.me" = "http://localhost:9104"; # Bazarr

          "home.oranos.me" = "http://localhost:9105";
          "git.oranos.me" = "http://localhost:9106"; # GitLab
          "cloud.oranos.me" = "http://localhost:9107"; # Nextcloud
          "code.oranos.me" = "http://localhost:9108"; # OpenVSCode Server
          "cockpit.oranos.me" = "http://localhost:9109"; # Cockpit
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
