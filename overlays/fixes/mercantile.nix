# Disable checks for Python mercantile package to avoid test failures
# Issue: mercantile CLI tests fail (dependency of alpaca)
# Workaround: Disable doCheck for mercantile in both python3 and python313
# Status: temporary - expected to be fixed upstream
# Last checked: 2025-01-26
_final: prev: {
  python3 = prev.python3.override {
    packageOverrides = _pyfinal: pyprev: {
      mercantile = pyprev.mercantile.overridePythonAttrs (_oldAttrs: {
        doCheck = false;
      });
    };
  };
  python313 = prev.python313.override {
    packageOverrides = _pyfinal: pyprev: {
      mercantile = pyprev.mercantile.overridePythonAttrs (_oldAttrs: {
        doCheck = false;
      });
    };
  };
}
