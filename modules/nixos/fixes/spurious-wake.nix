# Issue: luna (ThinkPad X1 Carbon Gen 13) wakes from s2idle 1-2s after suspend
# entry, sometimes with the lid closed (verified: lid closed 17:49:12, suspend
# entry 17:49:14, wake 17:49:16 on 2026-07-31). Devices that never need to
# wake the laptop are armed as wakeup sources. Prime suspect is the Synaptics
# touchpad (i2c-SNSL0028:00): ~66k wakeup events per boot vs 4 for the modem,
# and lid-closing pressure on the palmrest explains the lid-closed wakes. The
# Quectel RM520N-GL modem path (mhi0 behind root port 0000:00:1c.6) is armed
# too; the root port logged 50 wake events per boot on an 18%-signal
# connection. Bluetooth was exonerated (controller reported wake event 0x0).
# Description: Disable power/wakeup via udev for the touchpad and the modem
# PCI/MHI path. Keyboard (serio0), lid switch, and power button stay armed so
# normal wake gestures keep working. Healthy suspends keep full S0ix residency
# (verified 17.7 min hardware sleep matching wall time), so nothing else
# should change.
# Status: active
# Last-checked: 2026-08-03
# Removal condition: Revisit if a kernel/firmware update stops arming these
# devices by default (check power/wakeup in sysfs), or if wake-on-touch or
# wake-on-modem is ever actually wanted.
{
  flake.modules.nixos.spurious-wake = {
    services.udev.extraRules = ''
      # Synaptics touchpad: phantom/pressure touches must not wake the system
      ACTION=="add|change", SUBSYSTEM=="i2c", KERNEL=="i2c-SNSL0028:00", ATTR{power/wakeup}="disabled"

      # Quectel RM520N-GL modem path: mobile network events must not wake the system
      ACTION=="add|change", SUBSYSTEM=="mhi", KERNEL=="mhi0", ATTR{power/wakeup}="disabled"
      ACTION=="add|change", SUBSYSTEM=="pci", KERNEL=="0000:08:00.0", ATTR{power/wakeup}="disabled"
      ACTION=="add|change", SUBSYSTEM=="pci", KERNEL=="0000:00:1c.6", ATTR{power/wakeup}="disabled"
    '';
  };
}
