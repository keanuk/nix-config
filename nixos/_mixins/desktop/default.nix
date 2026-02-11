{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./fonts.nix

    ../programs/evolution
    ../programs/gamescope
    ../programs/steam

    ../services/geoclue2
    ../services/udev
  ];

  boot.kernelParams = [
    "amdgpu.exp_hw_support=1"
  ];

  services = {
    # Desktop services
    accounts-daemon.enable = true;
    automatic-timezoned.enable = true;
    avahi.enable = true;
    dbus.enable = true;
    devmon.enable = true;
    flatpak.enable = true;
    fprintd.enable = true;
    gnome.gnome-keyring.enable = true;
    gnome.at-spi2-core.enable = true;
    gvfs.enable = true;
    homed.enable = true;
    libinput = {
      enable = true;
      mouse = {
        naturalScrolling = true;
      };
      touchpad = {
        naturalScrolling = true;
        tapping = true;
      };
    };
    localtimed.enable = true;
    passSecretService.enable = true;
    pcscd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    printing.enable = true;
    power-profiles-daemon.enable = true;
    pulseaudio.enable = false;
    udisks2.enable = true;
    upower.enable = true;
    xinetd.enable = true;
    xserver.enable = true;

    sssd = {
      enable = true;
      settings = {
        "domain/shadowutils" = {
          auth_provider = "proxy";
          id_provider = "proxy";
          proxy_fast_alias = true;
          proxy_lib_name = "files";
          proxy_pam_target = "sssd-shadowutils";
        };
        nss = { };
        pam = { };
        sssd = {
          domains = "shadowutils";
          services = "nss, pam";
        };
      };
    };
  };

  networking.networkmanager.enable = true;

  fonts.fontDir.enable = true;

  programs = {
    gnupg.agent.enable = true;
    seahorse.enable = true;
  };

  hardware = {
    sensor.iio.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  environment = {
    sessionVariables = {
      # ENABLE_HDR_WSI = "1";
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = with pkgs; [
      xbacklight
    ];
    shells = with pkgs; [
      bashInteractive
      fish
      nushell
      zsh
    ];
  };

  # Needed if not using GNOME
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
