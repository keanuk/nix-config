{
  pkgs,
  config,
  ...
}: {
  # Configure sops secrets for GitLab
  sops.secrets.gitlab-root-password = {
    owner = "gitlab";
    group = "gitlab";
    mode = "0400";
  };

  sops.secrets.gitlab-secret = {
    owner = "gitlab";
    group = "gitlab";
    mode = "0400";
  };

  sops.secrets.gitlab-otp = {
    owner = "gitlab";
    group = "gitlab";
    mode = "0400";
  };

  sops.secrets.gitlab-db = {
    owner = "gitlab";
    group = "gitlab";
    mode = "0400";
  };

  sops.secrets.gitlab-jws = {
    owner = "gitlab";
    group = "gitlab";
    mode = "0400";
  };

  services.gitlab = {
    enable = true;
    package = pkgs.unstable.gitlab;
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
    };
    extraConfig = {
      gitlab = {
        email_from = "gitlab@oranos.me";
        email_reply_to = "noreply@oranos.me";
        trusted_proxies = ["127.0.0.1" "::1"];
      };
    };
  };

  # Ensure GitLab services start after RAID is mounted
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

  # GitLab workhorse listens on port 8929 by default
  networking.firewall.allowedTCPPorts = [8929];
}
