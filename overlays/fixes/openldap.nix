# Fix openldap tests failing and breaking lutris-free build
# Issue: https://github.com/NixOS/nixpkgs/issues/513245
# Upstream PR: N/A
# Workaround: Disable checks for openldap only for lutris and lutris-free to avoid system rebuilds
# Status: temporary
# Last checked: 2026-04-25
# Remove after: upstream issue is resolved
_final: prev: {
  lutris = prev.lutris.override {
    buildFHSEnv = args: prev.buildFHSEnv (args // {
      multiPkgs = envPkgs:
        let
          originalPkgs = args.multiPkgs envPkgs;
          customLdap = envPkgs.openldap.overrideAttrs (_oldAttrs: { doCheck = false; });
        in
        builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
    });
  };

  lutris-free = prev.lutris-free.override {
    lutris = prev.lutris.override {
      buildFHSEnv = args: prev.buildFHSEnv (args // {
        multiPkgs = envPkgs:
          let
            originalPkgs = args.multiPkgs envPkgs;
            customLdap = envPkgs.openldap.overrideAttrs (_oldAttrs: { doCheck = false; });
          in
          builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
      });
    };
  };
}
