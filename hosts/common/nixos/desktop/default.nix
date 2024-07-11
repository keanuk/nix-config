{ pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./theme/stylix.nix

    ../services/geoclue2.nix
    ../services/udev.nix
  ];

  security.rtkit.enable = true;
  services = {
    dbus.enable = true;
    flatpak.enable = true;
    libinput.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    xserver.enable = true;
  };


  hardware = {
    pulseaudio.enable = false;
    sensor.iio.enable = true;
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      xorg.xbacklight
    ];
  };
}
