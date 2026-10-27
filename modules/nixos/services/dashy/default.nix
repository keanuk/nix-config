{ config, ... }:
let
  d = config.domains;
  url = svc: "https://${d.services.${svc}.subdomain}.${d.primary}";
in
{
  flake.modules.nixos.dashy =
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
                  url = url "home";
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
                  url = url "sonarr";
                }
                {
                  title = "Radarr";
                  description = "Movies";
                  icon = "hl-radarr";
                  url = url "radarr";
                }
                {
                  title = "Lidarr";
                  description = "Music";
                  icon = "hl-lidarr";
                  url = url "lidarr";
                }
                {
                  title = "Prowlarr";
                  description = "Indexers";
                  icon = "hl-prowlarr";
                  url = url "prowlarr";
                }
                {
                  title = "Bazarr";
                  description = "Subtitles";
                  icon = "hl-bazarr";
                  url = url "bazarr";
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
                  url = url "cloud";
                }
                {
                  title = "Forgejo";
                  description = "Source Code";
                  icon = "hl-gitea";
                  url = url "git";
                }
                {
                  title = "VSCode";
                  description = "Code Editor";
                  icon = "hl-visual-studio-code";
                  url = url "code";
                }
                {
                  title = "Open WebUI";
                  description = "AI Chat";
                  icon = "fas fa-robot";
                  url = url "chat";
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
                  url = url "cockpit";
                }
                {
                  title = "Authelia";
                  description = "Authentication";
                  icon = "hl-authelia";
                  url = url "auth";
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
              port = d.services.dashy.backendPort;
            }
          ];
        };
      };
    };

  flake.modules.nixos.server = config.flake.modules.nixos.dashy;
}
