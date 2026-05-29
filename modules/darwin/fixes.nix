# Active workarounds in this directory
# This file serves as a registry of all fixes applied at the Darwin system level
{ config, ... }:
{
  flake.modules.darwin.fixes =
    { ... }:
    {
      imports = [
        # Temporary fixes (check periodically if still needed)
        # Add temporary fixes here as needed

        # Permanent workarounds (hardware/vendor specific)
        # Add permanent fixes here as needed
      ];
    };

  flake.modules.darwin.base = config.flake.modules.darwin.fixes;
}
