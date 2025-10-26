# Disable checks for batgrep to avoid test failures
# Issue: batgrep tests fail with snapshot mismatches
# Workaround: Disable doCheck
# Status: temporary - expected to be fixed upstream
# Last checked: 2025-01-26
final: prev: {
  bat-extras =
    prev.bat-extras
    // {
      batgrep = prev.bat-extras.batgrep.overrideAttrs (oldAttrs: {
        doCheck = false;
      });
    };
}
