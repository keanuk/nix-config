# Darwin-specific Halloy configuration
#
# On macOS, Halloy is installed via Homebrew (see darwin/homebrew.nix), so we
# enable the HM module with package = null to manage only the configuration.
# The shared default.nix is NOT imported here (it belongs to the Linux-only
# desktop role).
_: {
  programs.halloy = {
    enable = true;
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
