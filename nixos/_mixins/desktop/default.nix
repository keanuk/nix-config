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
    dbus.enable = true;
    flatpak.enable = true;
    fprintd.enable = true;
    gnome.gnome-keyring.enable = true;
    gnome.at-spi2-core.enable = true;
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
    passSecretService.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    pulseaudio.enable = false;
    xserver.enable = true;
  };

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

  # Needed if not using GNOeE
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
