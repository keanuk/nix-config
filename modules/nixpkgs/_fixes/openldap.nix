_final: prev: {
  lutris = prev.lutris.override {
    buildFHSEnv =
      args:
      prev.buildFHSEnv (
        args
        // {
          multiPkgs =
            envPkgs:
            let
              originalPkgs = args.multiPkgs envPkgs;
              customLdap = envPkgs.openldap.overrideAttrs (_oldAttrs: {
                doCheck = false;
              });
            in
            builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
        }
      );
  };

  lutris-free = prev.lutris-free.override {
    lutris = prev.lutris.override {
      buildFHSEnv =
        args:
        prev.buildFHSEnv (
          args
          // {
            multiPkgs =
              envPkgs:
              let
                originalPkgs = args.multiPkgs envPkgs;
                customLdap = envPkgs.openldap.overrideAttrs (_oldAttrs: {
                  doCheck = false;
                });
              in
              builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
          }
        );
    };
  };
}
