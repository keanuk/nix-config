# FIXME: patool 4.0.5 test suite fails on python 3.14 (and 3.13).
#   - tests look for non-existent list_bzip2 / list_lzma / list_xz /
#     list_lzip functions in the program modules (these compressors have
#     no "list" action).
#   - test_mime expects `application/x-tar' for `t.tar.bz2.foo' but
#     libmagic now returns `application/x-bzip2'.
#   This is a test-only failure; patool works correctly at runtime.
# Issue: https://github.com/wummel/patool/issues
# Description: Disable checks for patool to unblock bottles (and any other
#   reverse dependency pulling it in).
# Status: Active workaround
# Last checked: 2026-07-12
# Removal condition: Remove when patool's test suite is fixed upstream or
#   when nixpkgs ships a patched patool.

_final: prev: {
  python313Packages = prev.python313Packages.overrideScope (
    _self: super: {
      patool = super.patool.overridePythonAttrs (_oldAttrs: {
        doCheck = false;
      });
    }
  );

  python314Packages = prev.python314Packages.overrideScope (
    _self: super: {
      patool = super.patool.overridePythonAttrs (_oldAttrs: {
        doCheck = false;
      });
    }
  );
}
