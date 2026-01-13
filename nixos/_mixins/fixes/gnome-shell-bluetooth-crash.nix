# GNOME Shell crashes when connecting Bluetooth headphones (SIGABRT in gvc_mixer_stream_get_port)
# Issue: https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/8961
# Workaround: Configure WirePlumber to disable SCO/HFP profiles that trigger the race condition
#             in libgvc when multiple audio ports are enumerated simultaneously
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

  # Configure WirePlumber to avoid the race condition in GNOME Shell's volume control
  # when Bluetooth devices with multiple audio ports (A2DP + HFP/HSP) connect
  services.pipewire.wireplumber.extraConfig = {
    "51-gnome-bluetooth-crash-fix" = {
      # Disable SCO/HFP backend to prevent multi-port enumeration crash
      # This means headset/hands-free profile won't work (no microphone over Bluetooth)
      # but A2DP audio playback will work without crashing GNOME Shell
      "wireplumber.settings" = {
        "bluetooth.autoswitch-to-headset-profile" = false;
      };
      "monitor.bluez.properties" = {
        # Disable HFP (Hands-Free Profile) which causes the port enumeration crash
        "bluez5.enable-sco" = false;
        "bluez5.hfphsp-backend" = "none";

        # Keep A2DP enabled for high-quality audio playback
        "bluez5.enable-a2dp" = true;

        # Disable automatic profile switching which can trigger the race condition
        "bluez5.auto-profile" = false;

        # Disable mSBC codec (used for HFP wideband speech)
        "bluez5.enable-msbc" = false;

        # Optionally disable hardware volume control if issues persist
        # "bluez5.enable-hw-volume" = false;
      };
    };
  };

  # Note: This workaround disables Bluetooth microphone functionality.
  # If you need to use a Bluetooth headset microphone, you'll need to:
  # 1. Remove this fix
  # 2. Connect headphones via bluetoothctl in terminal instead of GNOME Settings
  # 3. Or wait for the upstream fix in GNOME Shell
}
