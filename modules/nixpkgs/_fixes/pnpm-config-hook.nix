# FIXME: pnpm 11 introduced a default minimumReleaseAge of 1440 minutes.
#   During sandboxed builds using pnpmConfigHook, `pnpm install --offline`
#   attempts to query registry.npmjs.org to verify package release ages,
#   failing with ERR_PNPM_MINIMUM_RELEASE_AGE_VIOLATION due to lack of network access.
# Issue: https://github.com/NixOS/nixpkgs/issues (pnpmConfigHook missing pnpm_config_minimum_release_age=0)
# Description: Set pnpm_config_minimum_release_age=0 in pnpmConfigHook for pnpm 11+
#   so offline installations in Nix derivations do not fail supply-chain age checks.
# Status: Active workaround
# Last checked: 2026-08-30
# Removal condition: Remove when upstream nixpkgs pnpmConfigHook sets
#   export pnpm_config_minimum_release_age=0 for pnpm 11+.

_final: prev:
prev.lib.optionalAttrs (prev ? pnpmConfigHook) {
  pnpmConfigHook =
    prev.makeSetupHook
      {
        name = "pnpm-config-hook";
        propagatedBuildInputs = [
          prev.sqlite
          prev.writableTmpDirAsHomeHook
          prev.zstd
        ];
        substitutions = {
          npmArch = prev.stdenvNoCC.targetPlatform.node.arch;
          npmPlatform = prev.stdenvNoCC.targetPlatform.node.platform;
        };
      }
      (
        prev.runCommand "pnpm-config-hook.sh" { } ''
          substitute "${prev.path}/pkgs/build-support/node/fetch-pnpm-deps/pnpm-config-hook.sh" $out \
            --replace-fail "export pnpm_config_trust_lockfile=true" "export pnpm_config_trust_lockfile=true
            export pnpm_config_minimum_release_age=0"
        ''
      );
}
