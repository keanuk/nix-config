# Darwin-specific Ghostty overrides layered on top of homeManager.ghostty.
#
# On macOS, Ghostty is installed via Homebrew (see darwin/homebrew.nix),
# so we set package = null to manage only the configuration.
{ config, ... }:
{
  programs.ghostty = {
    package = null;
    installBatSyntax = false;
    installVimSyntax = false;
    settings = {
      command = "/etc/profiles/per-user/${config.home.username}/bin/fish --login --interactive";
      shell-integration = "fish";
      background-opacity = 0.7;
    };
  };
}
