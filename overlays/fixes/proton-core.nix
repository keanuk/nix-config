# Disable tests for python3.13-proton-core due to bcrypt password length limitation
# Issue: proton-core tests fail with bcrypt.hashpw() when using passwords >72 bytes
#        Error: "ValueError: password cannot be longer than 72 bytes, truncate manually if necessary"
#        The tests use a test password that exceeds bcrypt's 72-byte limit:
#        'PasswordThatIsLongerThan72CharsAndContainsSomeRandomStuffThatNoOneCaresAbout'
# Workaround: Disable doCheck for the proton-core Python package
# Status: temporary - waiting for upstream to fix tests or handle long passwords properly
# Reference: https://github.com/ProtonVPN/python-proton-core
# Last checked: 2025-01-26
_final: prev: {
  python3 = prev.python3.override {
    packageOverrides = _: pyprev: {
      proton-core = pyprev.proton-core.overridePythonAttrs (_: {
        doCheck = false;
      });
    };
  };

  python313 = prev.python313.override {
    packageOverrides = _: pyprev: {
      proton-core = pyprev.proton-core.overridePythonAttrs (_: {
        doCheck = false;
      });
    };
  };
}
