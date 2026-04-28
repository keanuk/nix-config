# Active workarounds in this directory
# This file serves as a registry of all fixes applied at the Darwin system level
{
  flake.modules.darwin.fixes = _: {
    imports = [
      # Temporary fixes (check periodically if still needed)
      # Add temporary fixes here as needed

      # Permanent workarounds (hardware/vendor specific)
      # Add permanent fixes here as needed
    ];
  };
}
