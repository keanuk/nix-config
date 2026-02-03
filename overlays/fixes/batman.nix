# Disable checks for batman to avoid nushell dependency
# Issue: batman tests require nushell as nativeCheckInputs
# Workaround: Disable doCheck
# Status: temporary - nushell build fails on darwin
# Last checked: 2026-02-02
_final: prev: {
  bat-extras = prev.bat-extras // {
    batman = prev.bat-extras.batman.overrideAttrs (_oldAttrs: {
      doCheck = false;
    });
  };
}
