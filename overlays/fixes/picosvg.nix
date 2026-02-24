# Disable checks for Python picosvg package to avoid SVG test failures
# Issue: 5 SVG tests fail in picosvg 0.22.3 with Python 3.13
#   FAILED tests/svg_test.py::test_topicosvg[stroke-capjoinmiterlimit-before.svg-...]
#   FAILED tests/svg_test.py::test_topicosvg[stroke-circle-dasharray-before.svg-...]
#   FAILED tests/svg_test.py::test_topicosvg[arcs-before.svg-...]
#   FAILED tests/svg_test.py::test_topicosvg[clipped-strokes-before.svg-...]
#   FAILED tests/svg_test.py::test_topicosvg[pathops-tricky-path-before.svg-...]
# This breaks: picosvg → nanoemoji → gftools → jetbrains-mono → fonts → system
# Workaround: Disable doCheck for picosvg in both python3 and python313
# Status: temporary - expected to be fixed upstream
# Last checked: 2026-02-24
# Remove after: picosvg > 0.22.3 or nixpkgs updates the package
_final: prev: {
  python3 = prev.python3.override {
    packageOverrides = _pyfinal: pyprev: {
      picosvg = pyprev.picosvg.overridePythonAttrs (_oldAttrs: {
        doCheck = false;
      });
    };
  };
  python313 = prev.python313.override {
    packageOverrides = _pyfinal: pyprev: {
      picosvg = pyprev.picosvg.overridePythonAttrs (_oldAttrs: {
        doCheck = false;
      });
    };
  };
}
