# Darwin-specific Zed configuration
#
# On macOS, Zed is installed via Homebrew (see darwin/_mixins/base/homebrew.nix),
# so we set package = null to skip the Nix package installation.
# We import the shared default.nix to get all LSP binary paths (nixd, etc.)
# properly resolved to Nix store paths, avoiding the issue where Zed.app
# launched from /Applications can't find LSPs on the Nix-managed $PATH.
_: {
  programs.zed-editor = {
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
