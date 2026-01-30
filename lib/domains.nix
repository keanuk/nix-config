# Centralized Domain Configuration
#
# This file contains all domain-related configuration used across
# the NixOS configuration. Import this in modules that need domain info.
{
  # Primary domain
  primary = "oranos.org";

  # Authentication domain
  auth = "auth.oranos.org";

  # Email configuration
  email = "keanu@kerr.us";

  # Service definitions with their ports and subdomains
  # Format: { subdomain, backendPort, proxyPort, extraConfig? }
  services = {
    # Authentication (no auth required - it IS auth)
    auth = {
      subdomain = "auth";
      backendPort = 9191;
      proxyPort = 9092;
      requiresAuth = false;
    };

    # Dashboard
    dashy = {
      subdomain = null; # Root domain
      backendPort = 8082;
      proxyPort = 9094;
    };

    # AI/Chat
    chat = {
      subdomain = "chat";
      backendPort = 11435;
      proxyPort = 9095;
    };

    # Photos (Immich)
    photos = {
      subdomain = "photos";
      backendPort = 2283;
      proxyPort = 9096;
      extraConfig = "client_max_body_size 50G;";
    };

    # Media (Jellyfin)
    media = {
      subdomain = "media";
      backendPort = 8096;
      proxyPort = 9097;
    };

    # Audio (Audiobookshelf)
    audio = {
      subdomain = "audio";
      backendPort = 8000;
      proxyPort = 9098;
    };

    # Plex
    plex = {
      subdomain = "plex";
      backendPort = 32400;
      proxyPort = 9099;
    };

    # Sonarr
    sonarr = {
      subdomain = "sonarr";
      backendPort = 8989;
      proxyPort = 9100;
    };

    # Radarr
    radarr = {
      subdomain = "radarr";
      backendPort = 7878;
      proxyPort = 9101;
    };

    # Lidarr
    lidarr = {
      subdomain = "lidarr";
      backendPort = 8686;
      proxyPort = 9102;
    };

    # Prowlarr
    prowlarr = {
      subdomain = "prowlarr";
      backendPort = 9696;
      proxyPort = 9103;
    };

    # Bazarr
    bazarr = {
      subdomain = "bazarr";
      backendPort = 6767;
      proxyPort = 9104;
    };

    # Home Assistant
    home = {
      subdomain = "home";
      backendPort = 8123;
      proxyPort = 9105;
    };

    # Forgejo (Git)
    git = {
      subdomain = "git";
      backendPort = 3001;
      proxyPort = 9106;
      extraConfig = "client_max_body_size 512M;";
    };

    # Nextcloud
    cloud = {
      subdomain = "cloud";
      backendPort = 80;
      proxyPort = 9107;
      extraConfig = "client_max_body_size 16G;";
    };

    # OpenVSCode Server
    code = {
      subdomain = "code";
      backendPort = 3000;
      proxyPort = 9108;
      passHeaders = true; # Pass all user headers
    };

    # Cockpit
    cockpit = {
      subdomain = "cockpit";
      backendPort = 9090;
      proxyPort = 9109;
      useHttps = true;
      extraConfig = "proxy_ssl_verify off;";
      passHeaders = true;
    };
  };
}
