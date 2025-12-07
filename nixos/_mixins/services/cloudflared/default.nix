{config, pkgs, ...}: {
  services.cloudflared = {
    enable = true;
    package = pkgs.unstable.cloudflared;
    tunnels = {
      "beehive-tunnel" = {
        credentialsFile = config.sops.secrets.cloudflared-tunnel-credentials.path;
        default = "http_status:404";
        ingress = {
          # Nextcloud - Note: Nextcloud has its own nginx, so we proxy to it
          "nextcloud.oranos.me" = {
            service = "http://localhost:80";
          };
          # Immich - Photo management
          "immich.oranos.me" = {
            service = "http://localhost:2283";
          };
          # Home Assistant
          "homeassistant.oranos.me" = {
            service = "http://localhost:8123";
          };
          # Open WebUI - AI chat interface
          "openwebui.oranos.me" = {
            service = "http://localhost:11435";
          };
          # Cockpit - Server management
          "cockpit.oranos.me" = {
            service = "https://localhost:9090";
            originRequest.noTLSVerify = true;
          };
          # Jellyfin - Media server (if using nixarr)
          "jellyfin.oranos.me" = {
            service = "http://localhost:8096";
          };
          # Audiobookshelf (if enabled)
          "audiobooks.oranos.me" = {
            service = "http://localhost:8000";
          };
          # Plex (if enabled)
          "plex.oranos.me" = {
            service = "http://localhost:32400";
          };
        };
      };
    };
  };

  sops.secrets.cloudflared-tunnel-credentials = {
    owner = "cloudflared";
    group = "cloudflared";
  };
}
