# Disable checks for batpipe to avoid nushell dependency
# Issue: batpipe tests require nushell as nativeCheckInputs
# Workaround: Disable doCheck
# Status: temporary - nushell build fails on darwin
# Last checked: 2025-01-26
_final: prev: {
  bat-extras = prev.bat-extras // {
    batpipe = prev.bat-extras.batpipe.overrideAttrs (_oldAttrs: {
      doCheck = false;
    });
  };
}
