{ lib, ... }:
{
  options.domains = {
    primary = lib.mkOption {
      type = lib.types.str;
      description = "Primary domain";
    };
    auth = lib.mkOption {
      type = lib.types.str;
      description = "Authentication domain";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "Contact email";
    };
    services = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            subdomain = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              description = "Subdomain, or null for the root domain";
            };
            backendPort = lib.mkOption {
              type = lib.types.port;
              description = "Backend service port";
            };
            proxyPort = lib.mkOption {
              type = lib.types.port;
              description = "Reverse-proxy port";
            };
            requiresAuth = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether the service requires Authelia authentication";
            };
            extraConfig = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "Extra nginx config";
            };
            useHttps = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether the upstream is HTTPS";
            };
            passHeaders = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to pass all user headers from Authelia";
            };
          };
        }
      );
    };
  };

  config.domains = {
    primary = "oranos.org";
    auth = "auth.oranos.org";
    email = "keanu@kerr.us";
    services = {
      auth = {
        subdomain = "auth";
        backendPort = 9191;
        proxyPort = 9092;
        requiresAuth = false;
      };
      dashy = {
        subdomain = null;
        backendPort = 8082;
        proxyPort = 9094;
      };
      chat = {
        subdomain = "chat";
        backendPort = 11435;
        proxyPort = 9095;
      };
      photos = {
        subdomain = "photos";
        backendPort = 2283;
        proxyPort = 9096;
        extraConfig = "client_max_body_size 50G;";
      };
      media = {
        subdomain = "media";
        backendPort = 8096;
        proxyPort = 9097;
      };
      audio = {
        subdomain = "audio";
        backendPort = 8000;
        proxyPort = 9098;
      };
      plex = {
        subdomain = "plex";
        backendPort = 32400;
        proxyPort = 9099;
        requiresAuth = false;
      };
      sonarr = {
        subdomain = "sonarr";
        backendPort = 8989;
        proxyPort = 9100;
      };
      radarr = {
        subdomain = "radarr";
        backendPort = 7878;
        proxyPort = 9101;
      };
      lidarr = {
        subdomain = "lidarr";
        backendPort = 8686;
        proxyPort = 9102;
      };
      prowlarr = {
        subdomain = "prowlarr";
        backendPort = 9696;
        proxyPort = 9103;
      };
      bazarr = {
        subdomain = "bazarr";
        backendPort = 6767;
        proxyPort = 9104;
      };
      home = {
        subdomain = "home";
        backendPort = 8123;
        proxyPort = 9105;
      };
      git = {
        subdomain = "git";
        backendPort = 3001;
        proxyPort = 9106;
        extraConfig = "client_max_body_size 512M;";
      };
      cloud = {
        subdomain = "cloud";
        backendPort = 80;
        proxyPort = 9107;
        extraConfig = "client_max_body_size 16G;";
      };
      code = {
        subdomain = "code";
        backendPort = 3000;
        proxyPort = 9108;
        passHeaders = true;
      };
      cockpit = {
        subdomain = "cockpit";
        backendPort = 9090;
        proxyPort = 9109;
        useHttps = true;
        extraConfig = "proxy_ssl_verify off;";
        passHeaders = true;
      };
    };
  };
}
