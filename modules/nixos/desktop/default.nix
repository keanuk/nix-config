_: {
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
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

        xserver.enable = true;
      };

      networking.networkmanager.enable = true;

      fonts.fontDir.enable = true;

      programs = {
        appimage = {
          enable = true;
          binfmt = true;
        };
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

      xdg.portal.enable = true;
    };
}
