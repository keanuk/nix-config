# Disable checks for bat-extras packages to avoid nushell dependency
# Issue: bat-extras tests require nushell as nativeCheckInputs
# Workaround: Disable doCheck for affected packages
# Status: temporary - nushell build fails on darwin
# Last checked: 2026-02-02
_final: prev: {
  bat-extras = prev.bat-extras // {
    batdiff = prev.bat-extras.batdiff.overrideAttrs (_oldAttrs: {
      doCheck = false;
    });
    batgrep = prev.bat-extras.batgrep.overrideAttrs (_oldAttrs: {
      doCheck = false;
    });
    batman = prev.bat-extras.batman.overrideAttrs (_oldAttrs: {
      doCheck = false;
    });
    batpipe = prev.bat-extras.batpipe.overrideAttrs (_oldAttrs: {
      doCheck = false;
    });
  };
}
