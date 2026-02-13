{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.vscode-server.nixosModules.default

    ../services/openssh
  ];

  # ===== Swap Configuration =====
  # Essential for low-memory VPS to prevent OOM during any local operations
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 2048; # 2GB swap
      priority = 0;
    }
  ];

  boot = {
    # Tune swap behavior for low-memory systems
    kernel.sysctl = {
      "vm.swappiness" = 60; # More aggressive swap usage
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
    };
  };

  # ===== Nix Settings for Low-Resource Systems =====
  nix.settings = {
    # Limit parallelism to reduce memory pressure
    max-jobs = 1;
    cores = 1;

    # Prefer downloading from cache over building locally
    builders-use-substitutes = true;

    # Keep build logs small
    log-lines = 25;
  };

  # ===== Disable services not needed on VPS =====
  services = {
    # Disable comin (git-ops auto-rebuild) - use deploy-rs instead
    comin.enable = lib.mkForce false;

    vscode-server.enable = true;
  };

  # ===== Disable Virtualization Stack =====
  virtualisation = {
    podman.enable = lib.mkForce false;
  };

  # ===== Additional VPS Packages =====
  environment.systemPackages = with pkgs; [
    # Locale support (required for clean shell startup)
    glibcLocales
  ];

  # ===== Security =====
  security = {
    audit.enable = lib.mkForce false;
    auditd.enable = lib.mkForce false;
    # Allow passwordless sudo for wheel users on VPS
    # Required for automated deployments via deploy-rs
    sudo-rs.wheelNeedsPassword = false;
  };

  # ===== Systemd Hardening =====
  systemd = {
    oomd = {
      enable = true;
      enableRootSlice = true;
      enableUserSlices = true;
    };

    # Reduce journal size to save disk space
    services.systemd-journald.serviceConfig = {
      SystemMaxUse = "100M";
      RuntimeMaxUse = "50M";
    };
  };

  # ===== Network =====
  # Simple network config for VPS
  networking = {
    useDHCP = lib.mkDefault true;
  };

  time.timeZone = lib.mkOverride 49 "UTC";

  # ===== Locale =====
  # Use simple English locale for VPS to avoid locale errors
  i18n.defaultLocale = lib.mkForce "en_US.UTF-8";
  i18n.extraLocaleSettings = lib.mkForce {
    LC_ALL = "en_US.UTF-8";
  };
}
