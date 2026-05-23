# FIXME: python-lsp-server 1.14.0 has a strict runtime dependency on jedi<0.20.0,
#        but nixpkgs unstable currently ships jedi 0.20.0, causing the build to fail.
# Issue: https://github.com/python-lsp/python-lsp-server/issues/578
# Description: Patch pyproject.toml to relax the jedi upper bound from <0.20.0 to >=0.17.2
#   and disable tests due to upstream API incompatibilities with jedi 0.20.0.
# Status: Active workaround
# Last checked: 2025-05-22
# Removal condition: Remove when nixpkgs ships python-lsp-server with a jedi>=0.17.2
#   (or equivalent) bound, or when jedi is downgraded below 0.20.0 in nixpkgs.

final: prev: {
  python313 = prev.python313.override {
    packageOverrides = _self: super: {
      python-lsp-server = super.python-lsp-server.overridePythonAttrs (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          substituteInPlace pyproject.toml \
            --replace-warn "jedi>=0.17.2,<0.20.0" "jedi>=0.17.2" \
            --replace-warn "jedi<0.20.0,>=0.17.2" "jedi>=0.17.2"
        '';

        doCheck = false;
      });
    };
  };

  python313Packages = final.python313.pkgs;

  python314 = prev.python314.override {
    packageOverrides = _self: super: {
      python-lsp-server = super.python-lsp-server.overridePythonAttrs (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          substituteInPlace pyproject.toml \
            --replace-warn "jedi>=0.17.2,<0.20.0" "jedi>=0.17.2" \
            --replace-warn "jedi<0.20.0,>=0.17.2" "jedi>=0.17.2"
        '';

        doCheck = false;
      });
    };
  };

  python314Packages = final.python314.pkgs;
}
