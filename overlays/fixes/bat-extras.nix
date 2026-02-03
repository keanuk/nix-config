# Disable checks for bat-extras packages to avoid nushell dependency
# Issue: bat-extras tests require nushell as nativeCheckInputs
# Workaround: Override the entire bat-extras scope to pass a dummy nushell
# Status: temporary - nushell build fails on darwin
# Last checked: 2026-02-02
_final: prev: {
  bat-extras = prev.bat-extras.overrideScope (
    selfBat: _superBat: {
      buildBatExtrasPkg =
        selfBat.callPackage "${prev.path}/pkgs/tools/misc/bat-extras/buildBatExtrasPkg.nix"
          {
            nushell = null;
          };
      core =
        (selfBat.callPackage "${prev.path}/pkgs/tools/misc/bat-extras/modules/core.nix" { }).overrideAttrs
          (_oldAttrs: {
            doCheck = false;
            nativeCheckInputs = [ ];
          });
    }
  );
}
