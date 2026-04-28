{ config, inputs, ... }:
{
  flake.modules.nixos.vps =
    { lib, pkgs, ... }:
    {
      imports = (
        with config.flake.modules.nixos;
        [
          nix-settings
          system-packages
          openssh
        ]
      )
      ++ [ inputs.vscode-server.nixosModules.default ];

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
        optimise = {
          automatic = true;
          dates = [ "weekly" ];
        };
      };

      services = {
        comin.enable = lib.mkForce false;
        vscode-server.enable = true;
      };

      virtualisation = {
        podman.enable = lib.mkForce false;
      };

      environment.systemPackages = with pkgs; [
        glibcLocales
      ];

      security = {
        audit.enable = lib.mkForce false;
        auditd.enable = lib.mkForce false;
        sudo-rs.wheelNeedsPassword = false;
      };

      systemd = {
        oomd = {
          enable = true;
          enableRootSlice = true;
          enableUserSlices = true;
        };

        services.systemd-journald.serviceConfig = {
          SystemMaxUse = "100M";
          RuntimeMaxUse = "50M";
        };
      };

      networking = {
        useDHCP = lib.mkDefault true;
      };

      time.timeZone = lib.mkOverride 49 "UTC";

      i18n.defaultLocale = lib.mkForce "en_US.UTF-8";
      i18n.extraLocaleSettings = lib.mkForce {
        LC_ALL = "en_US.UTF-8";
      };
    };
}
