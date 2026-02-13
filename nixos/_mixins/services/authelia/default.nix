{
  config,
  pkgs,
  lib,
  domains,
  ...
}:
let

  autheliaUser = "authelia";
  autheliaGroup = "authelia";
  autheliaPort = 9191;
  authDomain = domains.auth;
  baseDomain = domains.primary;

  # Helper function to create Authelia-protected nginx virtual hosts
  # This eliminates ~700 lines of repetitive configuration
  mkAutheliaVhost = name: cfg: {
    "${name}-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = cfg.proxyPort;
        }
      ];
      locations."/" = {
        proxyPass =
          if cfg.useHttps or false then
            "https://127.0.0.1:${toString cfg.backendPort}"
          else
            "http://127.0.0.1:${toString cfg.backendPort}";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url https://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          ${lib.optionalString (cfg.passHeaders or false) ''
            auth_request_set $groups $upstream_http_remote_groups;
            auth_request_set $name $upstream_http_remote_name;
            auth_request_set $email $upstream_http_remote_email;
          ''}
          proxy_set_header Remote-User $user;
          ${lib.optionalString (cfg.passHeaders or false) ''
            proxy_set_header Remote-Groups $groups;
            proxy_set_header Remote-Name $name;
            proxy_set_header Remote-Email $email;
          ''}
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
          ${cfg.extraConfig or ""}
        '';
      };
      locations."/authelia" = {
        proxyPass = "http://127.0.0.1:${toString autheliaPort}/api/authz/auth-request";
        extraConfig = ''
          internal;
          proxy_set_header X-Original-URL https://$http_host$request_uri;
          proxy_set_header X-Original-Method $request_method;
          proxy_set_header X-Forwarded-Method $request_method;
          proxy_set_header X-Forwarded-Proto https;
          proxy_set_header X-Forwarded-Host $http_host;
          proxy_set_header X-Forwarded-Uri $request_uri;
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header Content-Length "";
          proxy_pass_request_body off;
        '';
      };
    };
  };

  # Generate access control rules from services
  mkAccessRule =
    _name: cfg:
    let
      domain = if cfg.subdomain == null then baseDomain else "${cfg.subdomain}.${baseDomain}";
    in
    {
      inherit domain;
      policy = "two_factor";
    };

  # All protected services (excludes auth itself)
  protectedServices = lib.filterAttrs (_n: v: v.requiresAuth or true) domains.services;

  # Generate all virtual hosts from service definitions
  allVirtualHosts = lib.foldl' (
    acc: name: acc // (mkAutheliaVhost name domains.services.${name})
  ) { } (builtins.attrNames protectedServices);

in
{
  users.users.${autheliaUser} = {
    isSystemUser = true;
    group = autheliaGroup;
    description = "Authelia authentication server";
  };

  users.groups.${autheliaGroup} = { };

  sops.secrets = {
    authelia-jwt-secret = {
      owner = autheliaUser;
      group = autheliaGroup;
      mode = "0400";
    };
    authelia-session-secret = {
      owner = autheliaUser;
      group = autheliaGroup;
      mode = "0400";
    };
    authelia-storage-encryption-key = {
      owner = autheliaUser;
      group = autheliaGroup;
      mode = "0400";
    };
    authelia-users = {
      owner = autheliaUser;
      group = autheliaGroup;
      mode = "0400";
    };
  };

  services.authelia.instances.main = {
    enable = true;
    package = pkgs.unstable.authelia;
    user = autheliaUser;
    group = autheliaGroup;

    secrets = {
      jwtSecretFile = config.sops.secrets.authelia-jwt-secret.path;
      sessionSecretFile = config.sops.secrets.authelia-session-secret.path;
      storageEncryptionKeyFile = config.sops.secrets.authelia-storage-encryption-key.path;
    };
    environmentVariables = { };

    settings = {
      theme = "dark";
      default_2fa_method = "totp";

      server = {
        address = "tcp://127.0.0.1:${toString autheliaPort}";
      };

      log = {
        level = "info";
        format = "text";
      };

      authentication_backend = {
        password_reset.disable = false;
        file = {
          inherit (config.sops.secrets.authelia-users) path;
          password = {
            algorithm = "argon2id";
            iterations = 3;
            memory = 65536;
            parallelism = 4;
            key_length = 32;
            salt_length = 16;
          };
        };
      };

      access_control = {
        default_policy = "deny";
        rules = [
          # Auth domain bypasses authentication (it IS authentication)
          {
            domain = authDomain;
            policy = "bypass";
          }
        ]
        ++ (lib.mapAttrsToList mkAccessRule protectedServices);
      };

      session = {
        name = "authelia_session";
        same_site = "lax";
        expiration = "1h";
        inactivity = "5m";
        remember_me = "1M";

        cookies = [
          {
            domain = baseDomain;
            authelia_url = "https://${authDomain}";
            default_redirection_url = "https://${baseDomain}";
          }
        ];
      };

      regulation = {
        max_retries = 3;
        find_time = "2m";
        ban_time = "5m";
      };

      storage = {
        local = {
          path = "/var/lib/authelia-main/db.sqlite3";
        };
      };

      notifier = {
        disable_startup_check = true;
        filesystem = {
          filename = "/var/lib/authelia-main/notifications.txt";
        };
      };
    };
  };

  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    virtualHosts = {
      # Authelia portal - no auth required
      "${authDomain}" = {
        listen = [
          {
            addr = "127.0.0.1";
            port = domains.services.auth.proxyPort;
          }
        ];
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString autheliaPort}";
          proxyWebsockets = true;
        };
      };

      # Internal authelia verification endpoints
      "authelia-internal" = {
        listen = [
          {
            addr = "127.0.0.1";
            port = 9093;
          }
        ];
        locations."/api/verify" = {
          proxyPass = "http://127.0.0.1:${toString autheliaPort}/api/verify";
        };
        locations."/api/authz" = {
          proxyPass = "http://127.0.0.1:${toString autheliaPort}/api/authz";
        };
      };
    }
    // allVirtualHosts;
  };
}
