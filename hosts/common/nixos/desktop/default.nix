{ pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./theme/stylix.nix

    ../../dev/default.nix
    ../../dev/flutter.nix
    ../../dev/ide.nix
    ../../dev/java.nix
    ../../dev/nim.nix
    ../../dev/node.nix
    ../../dev/virtualization.nix

    ../services/geoclue2.nix
    ../services/udev.nix
  ];

  security.rtkit.enable = true;
  services = {
    dbus.enable = true;
    flatpak.enable = true;
    fprintd.enable = true;
    gnome.gnome-keyring.enable = true;
    libinput.enable = true;
    passSecretService.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    xserver.enable = true;
  };

  programs = {
    gnupg.agent.enable = true;
    seahorse.enable = true;
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
