{pkgs, ...}: {
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
        auth = {
          enableGuestAccess = false;
          users = [
            {
              user = "admin";
              hash = "057ba03d6c44104863dc7361fe4578965d1887360f90a0895882e58a6248fc86";
              type = "admin";
            }
          ];
        };
      };
      sections = [];
    };
  };

  # Configure nginx to listen on port 8082 for dashy
  services.nginx = {
    enable = true;
    virtualHosts."localhost" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 8082;
        }
      ];
    };
  };

  # Open the firewall for dashy
  networking.firewall.allowedTCPPorts = [8082];
}
