{ config, ... }:
{
  flake.modules.nixos.udev = _: {
    # Stadia conroller fixes
    services.udev.extraRules = ''
      # SDP protocol
      KERNEL=="hidraw*", ATTRS{idVendor}=="1fc9", MODE="0666"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1fc9", MODE="0666"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", MODE="0666"
      # Flashloader
      KERNEL=="hidraw*", ATTRS{idVendor}=="15a2", MODE="0666"
      # Controller
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="18d1", MODE="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="9400", MODE="0660", TAG+="uaccess"
      # USB Serial / ESP32 / Arduino / Microcontroller flashing rules
      SUBSYSTEM=="tty", KERNEL=="ttyACM[0-9]*", GROUP="dialout", MODE="0660", TAG+="uaccess"
      SUBSYSTEM=="tty", KERNEL=="ttyUSB[0-9]*", GROUP="dialout", MODE="0660", TAG+="uaccess"
      # ESP32 / Espressif native USB CDC
      SUBSYSTEM=="tty", ATTRS{idVendor}=="303a", GROUP="dialout", MODE="0660", TAG+="uaccess"
      # WCH CH340/CH341
      SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", GROUP="dialout", MODE="0660", TAG+="uaccess"
      # Silicon Labs CP210x
      SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", GROUP="dialout", MODE="0660", TAG+="uaccess"
      # FTDI
      SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", GROUP="dialout", MODE="0660", TAG+="uaccess"
    '';
  };

  flake.modules.nixos.desktop = config.flake.modules.nixos.udev;
}
