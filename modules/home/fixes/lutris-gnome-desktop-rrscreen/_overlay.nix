# Issue: https://github.com/lutris/lutris/issues/6965 (dup of #6828, fixed only
#   in lutris git master, no fixed release yet)
# Description: gnome-desktop 51 removed `GnomeDesktop.RRScreen` from the
#   GnomeDesktop-3.0 typelib. Lutris 0.5.22 tests the import success only
#   (`except ValueError`), then instantiates `GnomeDesktop.RRScreen` during
#   import while only catching `GLib.Error`, so lutris aborts with
#   `AttributeError: ... has no attribute 'RRScreen'`. This patch mirrors the
#   upstream master fix: probe the attribute at import and catch
#   `AttributeError` so lutris falls back to the legacy XRandR display manager.
# Status: active
# Last-checked: 2026-11-09
# Removal condition: Remove when nixpkgs ships a lutris release (>= 0.5.23)
#   containing the upstream fix.
# Applied via the `lutris-gnome-desktop-rrscreen` entry in
#   modules/nixpkgs/overlays.nix (home-manager resolves with `useGlobalPkgs`,
#   so it cannot be patched from a home-manager `nixpkgs.overlays` option).
_: prev: {
  lutris = prev.lutris.override {
    lutris-unwrapped = prev.lutris-unwrapped.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [ ./lutris-rrscreen-gnome-desktop-51.patch ];
    });
  };
}
