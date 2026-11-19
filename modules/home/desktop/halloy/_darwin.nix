# Darwin-specific Halloy overrides layered on top of homeManager.halloy.
#
# On macOS, Halloy is installed via Homebrew (see darwin/homebrew.nix), so we
# set package = null to manage only the configuration.
_: {
  programs.halloy = {
    package = null;
    settings.servers = {
      liberachat.nickname = "keanu2";
      hackint.nickname = "keanu2";
      oftc.nickname = "keanu2";
    };
  };
}
