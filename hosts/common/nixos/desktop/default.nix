{ pkgs, ... }:

{
  imports = [
    ./packages.nix

    ../services/geoclue2.nix
    ../services/ollama.nix
    ../services/udev.nix

    ../programs/evolution.nix
    ../programs/steam.nix

    ../../desktop/fonts.nix
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
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      xorg.xbacklight
    ];
    shells = with pkgs; [ bashInteractive fish nushell zsh ];
  };

  # Needed if not using GNOME
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
