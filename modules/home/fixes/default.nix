# Active workarounds in this directory
# This file serves as a registry of all fixes applied at the home-manager level
{
  flake.modules.homeManager.fixes = _: {
    imports = [
      # Temporary fixes (check periodically if still needed)
      # lutris-gnome-desktop-rrscreen: lutris crashes on gnome-desktop 51
      #   (lutris/lutris#6965); applied as a base overlay from
      #   modules/home/fixes/lutris-gnome-desktop-rrscreen/_overlay.nix
      # Add temporary fixes here as needed

      # Permanent workarounds (hardware/vendor specific)
      # Add permanent fixes here as needed
    ];
  };
}
