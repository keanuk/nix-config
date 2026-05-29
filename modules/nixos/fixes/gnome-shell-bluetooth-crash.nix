# Issue: GNOME Shell crashes when Bluetooth headset connects (GNOME issue #8961)
# Description: Disables Bluetooth SCO/MSBC and auto-switch in WirePlumber to avoid crash
# Status: active
# Last-checked: 2025-05-25
# Removal condition: Remove when GNOME Shell >= 50 no longer crashes on Bluetooth headset connect
{
  flake.modules.nixos.gnome-shell-bluetooth-crash =
    {
      lib,
      pkgs,
      ...
    }:
    {
      warnings = lib.optional (lib.versionAtLeast pkgs.gnome-shell.version "50") "Check if GNOME Shell Bluetooth crash workaround is still needed (issue #8961)";

      services.pipewire.wireplumber.extraConfig = {
        "51-gnome-bluetooth-crash-fix" = {
          "wireplumber.settings" = {
            "bluetooth.autoswitch-to-headset-profile" = false;
          };
          "monitor.bluez.properties" = {
            "bluez5.enable-sco" = false;
            "bluez5.hfphsp-backend" = "none";
            "bluez5.enable-a2dp" = true;
            "bluez5.auto-profile" = false;
            "bluez5.enable-msbc" = false;
          };
        };
      };
    };
}
