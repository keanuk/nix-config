{
  config,
  pkgs,
  lib,
  ...
}:
let
  forgejoUser = "forgejo";
  forgejoGroup = "forgejo";
in
{
  sops.secrets.forgejo-secret = {
    owner = forgejoUser;
    group = forgejoGroup;
    mode = "0400";
  };

  services.forgejo = {
    enable = true;
    package = pkgs.unstable.forgejo;
    stateDir = "/data/.state/forgejo";
    user = forgejoUser;
    group = forgejoGroup;

    database = {
      type = "sqlite3";
    };

    settings = {
      DEFAULT = {
        APP_NAME = "Oranos Git";
      };
      server = {
        DOMAIN = "git.oranos.me";
        ROOT_URL = "https://git.oranos.me/";
        HTTP_PORT = 3001;
        HTTP_ADDR = "127.0.0.1";
      };
      service = {
        DISABLE_REGISTRATION = true;
        REQUIRE_SIGNIN_VIEW = true;
      };
      session = {
        COOKIE_SECURE = true;
      };
      mailer = {
        ENABLED = true;
        PROTOCOL = "smtp";
        SMTP_ADDR = "127.0.0.1";
        SMTP_PORT = 1025;
        FROM = "git@oranos.me";
      };
      log = {
        LEVEL = "Info";
      };
    };

    secrets = {
      security.SECRET_KEY = lib.mkDefault config.sops.secrets.forgejo-secret.path;
    };
  };

  systemd.services.forgejo = {
    after = [ "raid-online.target" ];
    bindsTo = [ "raid-online.target" ];
    unitConfig.AssertPathIsMountPoint = "/data";
  };
}
