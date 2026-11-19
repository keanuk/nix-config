_: {
  flake.modules.nixos.vps =
    { lib, ... }:
    {
      swapDevices = [
        {
          device = "/var/swapfile";
          size = 2048;
          priority = 0;
        }
      ];

      boot = {
        kernel.sysctl = {
          "vm.swappiness" = 60;
          "vm.vfs_cache_pressure" = 50;
          "vm.dirty_ratio" = 10;
          "vm.dirty_background_ratio" = 5;
        };
      };

      nix = {
        settings = {
          max-jobs = 1;
          cores = 1;
          builders-use-substitutes = true;
          log-lines = 25;
          min-free = 512000000;
          max-free = 1024000000;
        };
        gc = {
          automatic = lib.mkForce true;
          dates = lib.mkForce "daily";
          options = lib.mkForce "--delete-older-than 3d";
        };
      };

      security = {
        # Required by deploy-rs (sshUser = "keanu", user = "root") for
        # non-interactive activation. CI deploy keys must use the unprivileged
        # staticWebsite.deployAuthorizedKeys user, never keanu.
        sudo-rs.wheelNeedsPassword = false;
      };

      systemd = {
        oomd = {
          enable = true;
          enableRootSlice = true;
          enableUserSlices = true;
        };
      };

      # NOTE: journald limits live in journald.conf, not the unit's
      # serviceConfig (keys there are silently ignored). The VPS role is only
      # imported by stable hosts; on nixos-unstable `services.journald.extraConfig`
      # was removed in favor of `services.journald.settings.Journal`.
      services.journald.extraConfig = ''
        SystemMaxUse=100M
        RuntimeMaxUse=50M
      '';

      networking = {
        useDHCP = lib.mkDefault true;
      };

      time.timeZone = "UTC";

      i18n = {
        defaultLocale = lib.mkForce "en_US.UTF-8";
        extraLocales = lib.mkForce [ ];
        extraLocaleSettings = lib.mkForce {
          LC_ALL = "en_US.UTF-8";
        };
      };
    };
}
