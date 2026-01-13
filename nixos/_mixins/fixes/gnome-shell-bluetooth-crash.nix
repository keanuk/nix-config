# GNOME Shell crashes when connecting Bluetooth headphones (SIGABRT in gvc_mixer_stream_get_port)
# Issue: https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/8961
# Primary fix: overlays/fixes/gnome-shell-libgvc.nix (patches libgvc to not abort on missing port)
# This file: Supplementary WirePlumber config to reduce likelihood of triggering the race condition
# Status: temporary - waiting for upstream fix in GNOME Shell's libgvc
# Last checked: 2026-01-12
# Remove after: GNOME Shell > 49.2 or when upstream issue #8961 is resolved
{
  lib,
  pkgs,
  ...
}: {
  # Add assertion to remind to check if fix is still needed
  warnings =
    lib.optional (lib.versionAtLeast pkgs.gnome-shell.version "50")
    "Check if GNOME Shell Bluetooth crash workaround in gnome-shell-bluetooth-crash.nix is still needed (issue #8961)";

  # Configure WirePlumber to reduce the likelihood of triggering the race condition
  # in GNOME Shell's volume control when Bluetooth devices with multiple audio ports connect.
  #
  # NOTE: The primary fix is the overlay in overlays/fixes/gnome-shell-libgvc.nix which patches
  # libgvc to return NULL instead of aborting when a port is not found. This WirePlumber config
  # is supplementary and helps by:
  # 1. Disabling HFP/HSP profiles which create additional ports
  # 2. Preventing automatic profile switching during connection
  services.pipewire.wireplumber.extraConfig = {
    "51-gnome-bluetooth-crash-fix" = {
      # Disable automatic switching to headset profile (HFP/HSP)
      "wireplumber.settings" = {
        "bluetooth.autoswitch-to-headset-profile" = false;
      };
      "monitor.bluez.properties" = {
        # Disable HFP (Hands-Free Profile) which creates additional ports
        # This means headset/hands-free profile won't work (no microphone over Bluetooth)
        # but reduces the chance of port enumeration issues
        "bluez5.enable-sco" = false;
        "bluez5.hfphsp-backend" = "none";

        # Keep A2DP enabled for high-quality audio playback
        "bluez5.enable-a2dp" = true;

        # Disable automatic profile switching which can trigger race conditions
        "bluez5.auto-profile" = false;

        # Disable mSBC codec (used for HFP wideband speech)
        "bluez5.enable-msbc" = false;
      };
    };
  };

  # Note: This workaround disables Bluetooth microphone functionality.
  # If you need to use a Bluetooth headset microphone, you can:
  # 1. Comment out the bluez5.enable-sco and bluez5.hfphsp-backend lines above
  # 2. The overlay fix should still prevent crashes, but YMMV
}
