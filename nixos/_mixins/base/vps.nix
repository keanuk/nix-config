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

  # Tune swap behavior for low-memory systems
  boot.kernel.sysctl = {
    "vm.swappiness" = 60; # More aggressive swap usage
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
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

  # ===== Disable bcachefs =====
  # Not needed on VPS and currently marked as broken in stable
  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
  ];

  # ===== Disable sops-nix =====
  # sops requires either SSH host keys (not available during initial install)
  # or an age key file that doesn't exist on fresh systems
  # Disable for VPS to allow clean nixos-anywhere installation
  sops.defaultSopsFile = lib.mkForce null;
  sops.secrets = lib.mkForce { };

  # ===== Disable Local Auto-Builds =====
  # On resource-constrained VPS, builds should happen remotely and be deployed
  system.autoUpgrade.enable = lib.mkForce false;

  # Disable comin (git-ops auto-rebuild) - use deploy-rs instead
  services.comin.enable = lib.mkForce false;

  # ===== Enable Essential VPS Services =====
  services = {
    vscode-server.enable = true;

    # Keep systemd-oomd for memory pressure management
    # (inherited from base, but ensure it's on)
  };

  # ===== Disable Unnecessary Services for VPS =====
  services = {
    # Desktop/hardware services not needed on VPS
    printing.enable = lib.mkForce false;
    avahi.enable = lib.mkForce false;
    power-profiles-daemon.enable = lib.mkForce false;
    fwupd.enable = lib.mkForce false;
    devmon.enable = lib.mkForce false;
    gvfs.enable = lib.mkForce false;
    udisks2.enable = lib.mkForce false;
    upower.enable = lib.mkForce false;
    pcscd.enable = lib.mkForce false; # Smart card daemon
    homed.enable = lib.mkForce false;
    xinetd.enable = lib.mkForce false;
    gpm.enable = lib.mkForce false;

    # SSSD is overkill for simple VPS
    sssd.enable = lib.mkForce false;

    # Disable accounts-daemon (desktop user management)
    accounts-daemon.enable = lib.mkForce false;

    # Keep these useful for VPS
    # fail2ban - enabled in base
    # openssh - imported above
    # irqbalance - useful
    # sysstat - useful for monitoring
  };

  # ===== Disable Hardware Features Not Applicable to VPS =====
  hardware = {
    bluetooth.enable = lib.mkForce false;
    enableAllFirmware = lib.mkForce false;
    enableRedistributableFirmware = lib.mkForce false;
  };

  # Disable Plymouth (boot splash)
  boot.plymouth.enable = lib.mkForce false;

  # Use a lighter kernel (not latest, to save on memory and build time)
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  # ===== Disable Virtualization Stack =====
  # Don't need Docker/Podman on simple web server VPS
  virtualisation = {
    containerd.enable = lib.mkForce false;
    docker.enable = lib.mkForce false;
    podman.enable = lib.mkForce false;
  };

  # ===== Additional VPS Packages =====
  # Don't use mkForce - let base packages merge naturally
  # Just add any VPS-specific tools here
  environment.systemPackages = with pkgs; [
    # Locale support (required for clean shell startup)
    glibcLocales
  ];

  # ===== Security =====
  security = {
    audit.enable = lib.mkForce false;
    auditd.enable = lib.mkForce false;
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
    networkmanager.enable = lib.mkForce false; # Use simple dhcpcd instead
  };

  # ===== Timezone =====
  # Set a fixed timezone for VPS (no need for automatic detection)
  # mkOverride 49 has higher priority than mkForce (which is mkOverride 50)
  services.automatic-timezoned.enable = lib.mkForce false;
  services.localtimed.enable = lib.mkForce false;
  time.timeZone = lib.mkOverride 49 "UTC";

  # ===== Locale =====
  # Use simple English locale for VPS to avoid locale errors
  # The base config uses de_DE which requires extra locale data
  i18n.defaultLocale = lib.mkForce "en_US.UTF-8";
  i18n.extraLocaleSettings = lib.mkForce {
    LC_ALL = "en_US.UTF-8";
  };
}
