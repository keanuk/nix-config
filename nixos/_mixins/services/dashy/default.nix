{ pkgs, ... }:
{
  services.dashy = {
    enable = true;
    package = pkgs.unstable.dashy-ui;
    virtualHost = {
      enableNginx = true;
      domain = "localhost";
    };
    settings = {
      pageInfo = {
        title = "Dashboard";
        description = "Personal homelab dashboard";
      };
      appConfig = {
        theme = "catppuccin-mocha";
        layout = "auto";
        iconSize = "medium";
        language = "en";
        statusCheck = true;
        statusCheckInterval = 300;
      };
      sections = [
        {
          name = "Home Automation";
          icon = "fas fa-home";
          items = [
            {
              title = "Home Assistant";
              description = "Home Automation";
              icon = "hl-home-assistant";
              url = "https://home.oranos.me";
            }
          ];
        }
        {
          name = "Media & Downloads";
          icon = "fas fa-play-circle";
          items = [
            {
              title = "Sonarr";
              description = "TV Shows";
              icon = "hl-sonarr";
              url = "https://sonarr.oranos.me";
            }
            {
              title = "Radarr";
              description = "Movies";
              icon = "hl-radarr";
              url = "https://radarr.oranos.me";
            }
            {
              title = "Lidarr";
              description = "Music";
              icon = "hl-lidarr";
              url = "https://lidarr.oranos.me";
            }
            {
              title = "Prowlarr";
              description = "Indexers";
              icon = "hl-prowlarr";
              url = "https://prowlarr.oranos.me";
            }
            {
              title = "Bazarr";
              description = "Subtitles";
              icon = "hl-bazarr";
              url = "https://bazarr.oranos.me";
            }
          ];
        }
        {
          name = "Productivity & Dev";
          icon = "fas fa-keyboard";
          items = [
            {
              title = "Nextcloud";
              description = "Cloud Storage";
              icon = "hl-nextcloud";
              url = "https://cloud.oranos.me";
            }
            {
              title = "GitLab";
              description = "Source Code";
              icon = "hl-gitlab";
              url = "https://git.oranos.me";
            }
            {
              title = "VSCode";
              description = "Code Editor";
              icon = "hl-visual-studio-code";
              url = "https://code.oranos.me";
            }
            {
              title = "Open WebUI";
              description = "AI Chat";
              icon = "fas fa-robot";
              url = "https://chat.oranos.me";
            }
          ];
        }
        {
          name = "System & Admin";
          icon = "fas fa-server";
          items = [
            {
              title = "Cockpit";
              description = "Server Admin";
              icon = "hl-cockpit";
              url = "https://cockpit.oranos.me";
            }
            {
              title = "Authelia";
              description = "Authentication";
              icon = "hl-authelia";
              url = "https://auth.oranos.me";
            }
          ];
        }
      ];
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."localhost" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 8082;
        }
      ];
    };
  };
}
