# Darwin-specific Zed configuration
#
# On macOS, Zed is installed via Homebrew (see darwin/homebrew.nix), so we
# enable the HM module with package = null to manage only the configuration.
# The shared default.nix is NOT imported here (it belongs to the Linux-only
# desktop role), so LSPs are expected on the PATH rather than as store paths.
_: {
  programs.zed-editor = {
    enable = true;
    package = null;
    installRemoteServer = false;
    # Darwin-specific overrides
    userSettings = {
      ui_font_size = 14;
      buffer_font_size = 14;
      theme = {
        light = "Catppuccin Latte (Blur)";
        dark = "Catppuccin Mocha (Blur)";
      };
      icon_theme = "Catppuccin Mocha";
    };
  };
}
