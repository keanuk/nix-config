# open-webui: v0.9.5 fails to build due to missing peer dependency resolution
# Issue: https://github.com/NixOS/nixpkgs/issues/523304
# Description: npm --legacy-peer-deps prevents proper resolution of @internationalized/date
#   (a peer dependency of bits-ui) during the open-webui-frontend build.
# Status: Active workaround
# Last checked: 2026-05-23
# Removal condition: Remove when nixpkgs includes PR #523213 (remove --legacy-peer-deps)

_final: prev: {
  open-webui = prev.open-webui.overrideAttrs (_oldAttrs: {
    makeWrapperArgs = [
      "--set FRONTEND_BUILD_DIR ${
        prev.open-webui.frontend.overrideAttrs (_frontendOldAttrs: {
          npmFlags = [ "--force" ];
        })
      }/share/open-webui"
    ];
  });
}
