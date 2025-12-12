{
  config,
  lib,
  pkgs,
  ...
}: let
  autheliaUser = "authelia";
  autheliaGroup = "authelia";
  autheliaPort = 9191;
  authDomain = "auth.oranos.me";
  baseDomain = "oranos.me";
in {
  # Create authelia user and group for sops-nix compatibility
  users.users.${autheliaUser} = {
    isSystemUser = true;
    group = autheliaGroup;
    description = "Authelia authentication server";
  };

  users.groups.${autheliaGroup} = {};

  # Configure sops secrets for Authelia
  sops.secrets.authelia-jwt-secret = {
    owner = autheliaUser;
    group = autheliaGroup;
    mode = "0400";
  };

  sops.secrets.authelia-session-secret = {
    owner = autheliaUser;
    group = autheliaGroup;
    mode = "0400";
  };

  sops.secrets.authelia-storage-encryption-key = {
    owner = autheliaUser;
    group = autheliaGroup;
    mode = "0400";
  };

  # User password hashes file - this contains the argon2id hashed passwords
  sops.secrets.authelia-users = {
    owner = autheliaUser;
    group = autheliaGroup;
    mode = "0400";
  };

  # Protonmail Bridge password for SMTP authentication
  sops.secrets.protonmail-bridge-password = {
    owner = autheliaUser;
    group = autheliaGroup;
    mode = "0400";
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

    # SMTP password from SOPS
    environmentVariables = {
      AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.sops.secrets.protonmail-bridge-password.path;
    };

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
          path = config.sops.secrets.authelia-users.path;
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
          # Public access to the auth portal itself
          {
            domain = authDomain;
            policy = "bypass";
          }

          # Two-factor authentication required for sensitive services
          # These services can modify server settings, download content, or access private data
          {
            domain = "git.${baseDomain}";
            policy = "two_factor";
          }
          {
            domain = "cloud.${baseDomain}";
            policy = "two_factor";
          }
          {
            domain = "home.${baseDomain}";
            policy = "two_factor";
          }
          {
            domain = "photos.${baseDomain}";
            policy = "two_factor";
          }
          # *arr services - can download content and modify media library
          {
            domain = "sonarr.${baseDomain}";
            policy = "two_factor";
          }
          {
            domain = "radarr.${baseDomain}";
            policy = "two_factor";
          }
          {
            domain = "lidarr.${baseDomain}";
            policy = "two_factor";
          }
          {
            domain = "prowlarr.${baseDomain}";
            policy = "two_factor";
          }
          {
            domain = "bazarr.${baseDomain}";
            policy = "two_factor";
          }
          {
            domain = "code.${baseDomain}";
            policy = "two_factor";
          }

          # Two-factor authentication for all services
          {
            domain = baseDomain;
            policy = "two_factor";
          }
          {
            domain = "chat.${baseDomain}";
            policy = "two_factor";
          }
          {
            domain = "media.${baseDomain}";
            policy = "two_factor";
          }
          {
            domain = "audio.${baseDomain}";
            policy = "two_factor";
          }
          {
            domain = "plex.${baseDomain}";
            policy = "two_factor";
          }
        ];
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
        disable_startup_check = false;
        smtp = {
          address = "smtp://127.0.0.1:1025";
          username = "keanu@kerr.us";
          sender = "Authelia <keanu@kerr.us>";
          subject = "[Authelia] {title}";
          disable_require_tls = false;
          disable_starttls = false;
          tls = {
            skip_verify = true;
          };
        };
      };
    };
  };

  # Nginx reverse proxy configuration for Authelia and protected services
  services.nginx = {
    enable = true;

    # Recommended settings for Authelia
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    # Authelia portal virtual host
    virtualHosts."${authDomain}" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9092;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString autheliaPort}";
        proxyWebsockets = true;
      };
    };

    # Internal authelia verification endpoint (used by auth_request)
    virtualHosts."authelia-internal" = {
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

    # Dashy - protected by Authelia
    virtualHosts."dashy-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9094;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:8082";
        proxyWebsockets = true;
        extraConfig = ''
          # Authelia auth_request configuration
          auth_request /authelia;
          auth_request_set $target_url https://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          auth_request_set $groups $upstream_http_remote_groups;
          auth_request_set $name $upstream_http_remote_name;
          auth_request_set $email $upstream_http_remote_email;
          proxy_set_header Remote-User $user;
          proxy_set_header Remote-Groups $groups;
          proxy_set_header Remote-Name $name;
          proxy_set_header Remote-Email $email;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
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

    # Chat (Open WebUI) - protected by Authelia
    virtualHosts."chat-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9095;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:11435";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url $scheme://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          proxy_set_header Remote-User $user;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
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

    # Photos (Immich) - protected by Authelia
    virtualHosts."photos-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9096;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:2283";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url $scheme://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          proxy_set_header Remote-User $user;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
          # Immich needs larger body size for uploads
          client_max_body_size 50G;
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

    # Media (Jellyfin) - protected by Authelia
    virtualHosts."media-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9097;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url $scheme://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          proxy_set_header Remote-User $user;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
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

    # Audio (Audiobookshelf) - protected by Authelia
    virtualHosts."audio-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9098;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:8000";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url $scheme://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          proxy_set_header Remote-User $user;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
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

    # Plex - protected by Authelia
    virtualHosts."plex-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9099;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:32400";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url $scheme://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          proxy_set_header Remote-User $user;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
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

    # Sonarr - protected by Authelia
    virtualHosts."sonarr-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9100;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:8989";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url $scheme://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          proxy_set_header Remote-User $user;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
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

    # Radarr - protected by Authelia
    virtualHosts."radarr-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9101;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:7878";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url $scheme://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          proxy_set_header Remote-User $user;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
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

    # Lidarr - protected by Authelia
    virtualHosts."lidarr-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9102;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:8686";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url $scheme://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          proxy_set_header Remote-User $user;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
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

    # Prowlarr - protected by Authelia
    virtualHosts."prowlarr-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9103;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:9696";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url $scheme://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          proxy_set_header Remote-User $user;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
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

    # Bazarr - protected by Authelia
    virtualHosts."bazarr-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9104;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:6767";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url $scheme://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          proxy_set_header Remote-User $user;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
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

    # Home Assistant - protected by Authelia (2FA required)
    virtualHosts."home-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9105;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:8123";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url $scheme://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          proxy_set_header Remote-User $user;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
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

    # GitLab - protected by Authelia (2FA required)
    virtualHosts."git-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9106;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:8929";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url $scheme://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          proxy_set_header Remote-User $user;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
          # GitLab needs larger body size for git pushes
          client_max_body_size 512M;
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

    # Nextcloud - protected by Authelia (2FA required)
    virtualHosts."cloud-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9107;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:80";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /authelia;
          auth_request_set $target_url $scheme://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          proxy_set_header Remote-User $user;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
          # Nextcloud needs larger body size for file uploads
          client_max_body_size 16G;
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

    # OpenVSCode Server - protected by Authelia
    virtualHosts."code-auth" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9108;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
        extraConfig = ''
          # Authelia auth_request configuration
          auth_request /authelia;
          auth_request_set $target_url https://$http_host$request_uri;
          auth_request_set $user $upstream_http_remote_user;
          auth_request_set $groups $upstream_http_remote_groups;
          auth_request_set $name $upstream_http_remote_name;
          auth_request_set $email $upstream_http_remote_email;
          proxy_set_header Remote-User $user;
          proxy_set_header Remote-Groups $groups;
          proxy_set_header Remote-Name $name;
          proxy_set_header Remote-Email $email;
          error_page 401 =302 https://${authDomain}/?rd=$target_url;
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
}
