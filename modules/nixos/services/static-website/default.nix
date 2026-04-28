{ config, ... }:
let
  inherit (config.domains) email;
in
{
  flake.modules.nixos.vps-website =
    {
      config,
      lib,
      ...
    }:
    {
      options.staticWebsite = {
        domain = lib.mkOption {
          type = lib.types.str;
          description = "Public domain served by this static website.";
        };
        webRoot = lib.mkOption {
          type = lib.types.str;
          description = "Filesystem path that nginx serves as the document root.";
        };
      };

      config = {
        services.nginx = {
          enable = true;
          recommendedGzipSettings = true;
          recommendedOptimisation = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;

          virtualHosts.${config.staticWebsite.domain} = {
            forceSSL = true;
            enableACME = true;
            root = config.staticWebsite.webRoot;
            serverAliases = [ "www.${config.staticWebsite.domain}" ];
            extraConfig = ''
              # Security headers
              add_header X-Content-Type-Options "nosniff" always;
              add_header X-Frame-Options "DENY" always;
              add_header Referrer-Policy "strict-origin-when-cross-origin" always;
              add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;
            '';
            locations."/" = {
              tryFiles = "$uri $uri/ =404";
            };
          };
        };

        security.acme = {
          acceptTerms = true;
          defaults.email = email;
        };

        systemd.tmpfiles.rules = [
          "d ${config.staticWebsite.webRoot} 0755 keanu users -"
        ];

        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
      };
    };
}
