# Darwin-specific Ghostty configuration
#
# On macOS, Ghostty is installed via Homebrew (see darwin/_mixins/base/homebrew.nix),
# so we set package = null to skip the Nix package installation.
# We import the shared default.nix to get the base settings, then apply
# Darwin-specific overrides (shell command, background opacity).
{ lib, ... }:
{
  imports = [ ./. ];

  programs.ghostty = {
    package = null;
    installBatSyntax = false;
    installVimSyntax = false;
    settings = {
      command = "/etc/profiles/per-user/keanu/bin/fish --login --interactive";
      shell-integration = "fish";
      background-opacity = 0.9;
    };
  };

  programs.zellij = {
    enableBashIntegration = lib.mkForce false;
    enableFishIntegration = lib.mkForce false;
    enableZshIntegration = lib.mkForce false;
    exitShellOnExit = lib.mkForce false;
  };
}
