{ config, inputs, ... }:
{
  flake.modules.nixos.base =
    {
      options,
      pkgs,
      lib,
      ...
    }:
    {
      imports = with config.flake.modules.nixos; [
        nix-settings
        system-packages
        sops
        prog-fuse
        prog-nh
        prog-nix-ld
        svc-apparmor
        svc-comin
        svc-tailscale
        virtualization
      ]
      ++ [
        inputs.determinate.nixosModules.default
        inputs.disko.nixosModules.disko
        inputs.nur.modules.nixos.default
      ];

      boot = {
        initrd.systemd.enable = true;
        loader.efi.canTouchEfiVariables = lib.mkDefault true;
        kernelModules = [ "iptable_raw" ];
      };

      users.defaultUserShell = pkgs.fish;

      zramSwap = {
        enable = true;
        priority = 5;
        memoryPercent = 25;
      };

      time.timeZone = lib.mkForce null;

      services = {
        fail2ban.enable = true;
        irqbalance.enable = true;
        resolved =
          {
            enable = lib.mkDefault true;
          }
          // lib.optionalAttrs (builtins.hasAttr "settings" options.services.resolved) {
            settings.Resolve.DNSSEC = "allow-downgrade";
          }
          // lib.optionalAttrs (!builtins.hasAttr "settings" options.services.resolved) {
            dnssec = "allow-downgrade";
          };
        sysstat.enable = true;
      };

      systemd = {
        oomd.enable = lib.mkDefault true;
      };

      networking = {
        firewall.enable = true;
        firewall.trustedInterfaces = [ "wt0" ];
        nftables.enable = true;
      };

      security = {
        audit.enable = lib.mkDefault false;
        auditd.enable = lib.mkDefault false;
        polkit.enable = lib.mkDefault true;
        rtkit.enable = lib.mkDefault true;
        sudo-rs.enable = lib.mkDefault true;
      };

      console = {
        earlySetup = true;
        font = "Lat2-Terminus16";
        useXkbConfig = true;
        packages = with pkgs; [
          terminus_font
        ];
      };

      i18n = {
        defaultLocale = lib.mkDefault "de_DE.UTF-8";
        extraLocales = "all";
        extraLocaleSettings = {
          LC_CTYPE = "de_DE.UTF8";
          LC_ADDRESS = "de_DE.UTF-8";
          LC_MEASUREMENT = "de_DE.UTF-8";
          LC_MESSAGES = "de_DE.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_NAME = "de_DE.UTF-8";
          LC_NUMERIC = "de_DE.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_TELEPHONE = "de_DE.UTF-8";
          LC_TIME = "de_DE.UTF-8";
          LC_COLLATE = "de_DE.UTF-8";
        };
      };
    };
}
