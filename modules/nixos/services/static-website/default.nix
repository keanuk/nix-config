{ config, ... }:
let
  inherit (config.domains) email;
in
{
  flake.modules.nixos.static-website =
    {
      config,
      lib,
      pkgs,
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
        deployUser = lib.mkOption {
          type = lib.types.str;
          default = "deploy";
          description = "Unprivileged non-wheel SSH user created when deployAuthorizedKeys is non-empty.";
        };
        deployAuthorizedKeys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "SSH public keys allowed to deploy static site content via deployUser (never granted sudo/wheel).";
        };
        owner = lib.mkOption {
          type = lib.types.str;
          default =
            if config.staticWebsite.deployAuthorizedKeys != [ ] then
              config.staticWebsite.deployUser
            else
              "keanu";
          description = "Owner of the web root directory.";
        };
        group = lib.mkOption {
          type = lib.types.str;
          default = "users";
          description = "Group of the web root directory.";
        };
      };

      config =
        let
          cfg = config.staticWebsite;
          hasDeployKeys = cfg.deployAuthorizedKeys != [ ];
        in
        {
          users.users.${cfg.deployUser} = lib.mkIf hasDeployKeys {
            isNormalUser = true;
            inherit (cfg) group;
            home = cfg.webRoot;
            createHome = false;
            shell = pkgs.bashInteractive;
            description = "Unprivileged CI deploy user for ${cfg.domain}";
            openssh.authorizedKeys.keys = map (
              key: "no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ${key}"
            ) cfg.deployAuthorizedKeys;
          };

          services.nginx = {
            enable = true;
            recommendedGzipSettings = true;
            recommendedOptimisation = true;
            recommendedProxySettings = true;
            recommendedTlsSettings = true;

            virtualHosts.${cfg.domain} = {
              forceSSL = true;
              enableACME = true;
              root = cfg.webRoot;
              serverAliases = [ "www.${cfg.domain}" ];
              extraConfig = ''
                # Security headers
                add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
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
            "d ${cfg.webRoot} ${if hasDeployKeys then "0775" else "0755"} ${cfg.owner} ${cfg.group} -"
          ];

          networking.firewall.allowedTCPPorts = [
            80
            443
          ];
        };
    };
}
