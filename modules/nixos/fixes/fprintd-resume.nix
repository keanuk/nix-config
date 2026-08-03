# Issue: Synaptics 06cb:0123 fingerprint sensor wedges after s2idle resume:
# the first post-resume identify fails with "endpoint stalled or request not
# supported" and fprintd keeps the device open ("Device 06cb:0123 is already
# open"), so every later fingerprint auth (e.g. noctalia lockscreen) prompts
# but never reacts to a finger press until fprintd is restarted.
# Description: Restart fprintd after resume so it re-opens the sensor from a
# clean state. fprintd is D-Bus-activated, so try-restart is a no-op when it
# was idle-stopped; the next auth then activates a fresh instance anyway.
# Status: active
# Last-checked: 2026-08-02
# Removal condition: Remove when libfprint/fprintd recover the synaptics
# device cleanly across suspend/resume without wedging.
{
  flake.modules.nixos.fprintd-resume =
    { config, pkgs, ... }:
    {
      systemd.services.fprintd-resume-restart = {
        description = "Restart fprintd after resume to unwedge the fingerprint sensor";
        after = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
          "suspend-then-hibernate.target"
        ];
        wantedBy = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
          "suspend-then-hibernate.target"
        ];

        serviceConfig = {
          Type = "oneshot";
          # Give USB resume a moment to settle before re-opening the sensor.
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
          ExecStart = "${config.systemd.package}/bin/systemctl try-restart fprintd.service";
        };
      };
    };
}
