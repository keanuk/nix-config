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
        # auth = {
        #   enableGuestAccess = false;
        #   users = [
        #     {
        #       user = "admin";
        #       hash = "a0b2382c329ba78849a0f0cccbcb0d8779c51266aea0b423d3b9e00794ddfedf";
        #       type = "admin";
        #     }
        #   ];
        # };
      };
      sections = [];
    };
  };

  # Configure nginx to listen on port 8082 for dashy (localhost only)
  # External access goes through Authelia proxy on port 9094
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
