{
  pkgs,
  config,
  ...
}: {
  sops.secrets = {
    gitlab-root-password = {
      owner = "gitlab";
      group = "gitlab";
      mode = "0400";
    };
    gitlab-secret = {
      owner = "gitlab";
      group = "gitlab";
      mode = "0400";
    };
    gitlab-otp = {
      owner = "gitlab";
      group = "gitlab";
      mode = "0400";
    };
    gitlab-db = {
      owner = "gitlab";
      group = "gitlab";
      mode = "0400";
    };
    gitlab-jws = {
      owner = "gitlab";
      group = "gitlab";
      mode = "0400";
    };
    gitlab-activerecord-primary = {
      owner = "gitlab";
      group = "gitlab";
      mode = "0400";
    };
    gitlab-activerecord-deterministic = {
      owner = "gitlab";
      group = "gitlab";
      mode = "0400";
    };
    gitlab-activerecord-salt = {
      owner = "gitlab";
      group = "gitlab";
      mode = "0400";
    };
  };

  services.gitlab = {
    enable = true;
    packages.gitlab = pkgs.unstable.gitlab;
    databaseCreateLocally = true;
    statePath = "/data/.state/gitlab";
    host = "git.oranos.me";
    port = 443;
    https = true;
    initialRootPasswordFile = config.sops.secrets.gitlab-root-password.path;
    secrets = {
      secretFile = config.sops.secrets.gitlab-secret.path;
      otpFile = config.sops.secrets.gitlab-otp.path;
      dbFile = config.sops.secrets.gitlab-db.path;
      jwsFile = config.sops.secrets.gitlab-jws.path;
      activeRecordPrimaryKeyFile = config.sops.secrets.gitlab-activerecord-primary.path;
      activeRecordDeterministicKeyFile = config.sops.secrets.gitlab-activerecord-deterministic.path;
      activeRecordSaltFile = config.sops.secrets.gitlab-activerecord-salt.path;
    };
    extraConfig = {
      gitlab = {
        email_from = "gitlab@oranos.me";
        email_reply_to = "noreply@oranos.me";
        trusted_proxies = ["127.0.0.1" "::1"];
      };
    };
  };

  systemd.services = {
    gitlab = {
      after = ["raid-online.target"];
      bindsTo = ["raid-online.target"];
      unitConfig.AssertPathIsMountPoint = "/data";
    };

    gitlab-workhorse = {
      after = ["raid-online.target"];
      bindsTo = ["raid-online.target"];
      unitConfig.AssertPathIsMountPoint = "/data";
    };

    gitlab-sidekiq = {
      after = ["raid-online.target"];
      bindsTo = ["raid-online.target"];
      unitConfig.AssertPathIsMountPoint = "/data";
    };

    gitaly = {
      after = ["raid-online.target"];
      bindsTo = ["raid-online.target"];
      unitConfig.AssertPathIsMountPoint = "/data";
    };
  };

  networking.firewall.allowedTCPPorts = [8929];
}
