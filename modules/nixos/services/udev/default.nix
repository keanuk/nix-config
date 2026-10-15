{ config, ... }:
{
  flake.modules.nixos.udev = { pkgs, ... }: {
    # Numbered rules file: rules in 99-local.rules (extraRules) are processed
    # after 73-seat-late.rules, so their TAG+="uaccess" is never seen by the
    # uaccess builtin and no ACL is applied.
    services.udev = {
      packages = [
        (pkgs.writeTextFile {
          name = "ploopy-udev-rules";
          destination = "/lib/udev/rules.d/60-ploopy.rules";
          text = ''
            # Ploopy A+ Trackball (VIA config via usevia.app in Chrome/WebHID)
            KERNEL=="hidraw*", ATTRS{idVendor}=="5043", ATTRS{idProduct}=="81db", TAG+="uaccess"
          '';
        })
      ];

      # Ploopy A+ Trackball: the VIA-mapped macOS buttons emit HID Consumer
      # usages KC_MISSION_CONTROL (0x29F) and KC_LAUNCHPAD (0x2A0), which the
      # kernel turns into KEY_SCALE and KEY_UNKNOWN. Neither maps to a usable
      # XKB keysym (KEY_UNKNOWN gets NoSymbol; KEY_SCALE only gets XF86LaunchA
      # via xkeyboard-config). Remap to KEY_PROG1/KEY_PROG2, whose default
      # keysyms are XF86Launch1/XF86Launch2, which niri binds.
      extraHwdb = ''
        evdev:input:b0003v5043p81DB*
         KEYBOARD_KEY_c029f=prog1
         KEYBOARD_KEY_c02a0=prog2
      '';

      # Stadia conroller fixes
      extraRules = ''
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
  };

  flake.modules.nixos.desktop = config.flake.modules.nixos.udev;
}
