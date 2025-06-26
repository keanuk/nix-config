{
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./packages.nix

    ../services/apparmor.nix
    ../services/btrfs.nix
    ../services/tailscale.nix
    ../services/virtualization.nix

    ../programs/nh.nix
  ];

  boot = {
    initrd.systemd.enable = true;
    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["iptable_raw"];
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  users.defaultUserShell = pkgs.fish;

  # workaround for https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
    };
  };

  zramSwap = {
    enable = true;
    priority = 5;
    memoryPercent = 25;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    ksm.enable = true;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      allowed-users = ["@users"];
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
      system-features = [
        "big-parallel"
        "kvm"
        "nixos-test"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://keanu.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "keanu.cachix.org-1:bnYEu6tJzXfwM5JkEhc90uEjR7cAHwaa4fwHRCYdFGg="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than +5";
    };
  };

  nixpkgs.overlays = [
    outputs.overlays.unstable-packages
  ];

  time.timeZone = lib.mkForce null;

  services = {
    accounts-daemon.enable = true;
    automatic-timezoned.enable = true;
    avahi.enable = true;
    devmon.enable = true;
    fail2ban.enable = true;
    fwupd.enable = true;
    gvfs.enable = true;
    homed.enable = true;
    irqbalance.enable = true;
    localtimed.enable = true;
    pcscd.enable = true;
    printing.enable = true;
    power-profiles-daemon.enable = true;
    resolved.enable = true;
    resolved.dnssec = "allow-downgrade";
    smartd.enable = true;
    sssd.enable = true;
    sysstat.enable = true;
    thermald.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    xinetd.enable = true;
  };

  systemd = {
    # network.enable = true;
    oomd.enable = true;
  };

  networking = {
    firewall.enable = true;
    firewall.trustedInterfaces = ["wt0"];
    networkmanager.enable = true;
    nftables.enable = true;
  };

  security = {
    audit.enable = true;
    auditd.enable = true;
    polkit.enable = true;
    rtkit.enable = true;
    sudo-rs.enable = true;
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
      # LC_ALL = "de_DE.UTF-8";
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
}
