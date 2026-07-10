# FIXME: python3-frictionless tests fail due to pandas/fastparquet deprecations
#   and network tests requiring internet access.
# Issue: https://github.com/frictionlessdata/frictionless-py/issues
# Description: Disable checks for frictionless python package.
# Status: Active workaround
# Last checked: 2026-07-10
# Removal condition: Remove when tests are fixed upstream.

_final: prev: {
  python313Packages = prev.python313Packages.overrideScope (
    _self: super: {
      frictionless = super.frictionless.overridePythonAttrs (oldAttrs: {
        doCheck = false;
      });
    }
  );

  python314Packages = prev.python314Packages.overrideScope (
    _self: super: {
      frictionless = super.frictionless.overridePythonAttrs (oldAttrs: {
        doCheck = false;
      });
    }
  );
}
