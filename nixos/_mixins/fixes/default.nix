# Active workarounds in this directory
# This file serves as a registry of all fixes applied at the NixOS system level
{
  imports = [
    # Temporary fixes (check periodically if still needed)
    ./network-manager-wait-online-timeout.nix # Issue #180175, check after 24.11
    ./orca-always-enabled.nix # Issue #462935, check after 25.05

    # Permanent workarounds (hardware/vendor specific)
    # Add permanent fixes here as needed
  ];

  # To use these fixes in your configuration, import this file:
  # imports = [ ./nixos/_mixins/fixes ];
}
