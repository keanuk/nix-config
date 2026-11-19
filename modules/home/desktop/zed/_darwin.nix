# Darwin-specific Zed overrides layered on top of homeManager.zed.
#
# On macOS, Zed is installed via Homebrew (see darwin/homebrew.nix), so we
# set package = null to manage only the configuration.
_: {
  programs.zed-editor = {
    package = null;
    installRemoteServer = false;
    userSettings = {
      ui_font_size = 14;
      buffer_font_size = 14;
      theme = {
        light = "Catppuccin Latte (Blur)";
        dark = "Catppuccin Mocha (Blur)";
      };
    };
  };
}
