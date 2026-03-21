# Active workarounds in this directory
# This file serves as a registry of all fixes applied at the NixOS system level
{
  imports = [
    # Temporary fixes (check periodically if still needed)
    ./network-manager-wait-online-timeout.nix # Issue #180175, check after 24.11
    ./nixarr-autobrr-dasel-v3.nix # nixarr uses dasel v2 syntax incompatible with dasel v3

    # Permanent workarounds (hardware/vendor specific)
    # Add permanent fixes here as needed
  ];

  # To use these fixes in your configuration, import this file:
  # imports = [ ./nixos/_mixins/fixes ];
}
