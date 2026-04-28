# Darwin-specific Halloy configuration
#
# On macOS, Halloy is installed via Homebrew (see darwin/_mixins/base/homebrew.nix),
# so we set package = null to skip the Nix package installation.
# We import the shared default.nix to get the base settings, then apply
# Darwin-specific overrides (nickname, theme).
_: {
  programs.halloy = {
    package = null;
    settings = {
      theme = {
        light = "catppuccin-latte";
        dark = "catppuccin-mocha";
      };
      servers = {
        liberachat.nickname = "keanu2";
        hackint.nickname = "keanu2";
        oftc.nickname = "keanu2";
      };
    };
  };
}
