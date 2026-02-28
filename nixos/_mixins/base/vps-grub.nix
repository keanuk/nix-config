# Shared base configuration for VPS hosts using GRUB (no EFI)
#
# Combines the common VPS settings with GRUB bootloader config.
# This eliminates the repeated `boot.loader.grub` block in each VPS host.
#
# Usage in VPS host configs:
#   imports = [
#     ../../_mixins/base
#     ../../_mixins/base/vps-grub.nix
#     ...
#   ];
_: {
  imports = [
    ./vps.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
  };
}
