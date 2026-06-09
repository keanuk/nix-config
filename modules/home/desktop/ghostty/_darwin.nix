# Darwin-specific Ghostty configuration
#
# On macOS, Ghostty is installed via Homebrew (see darwin/homebrew.nix),
# so we set package = null to skip the Nix package installation.
{ lib, ... }:
{

  programs.ghostty = {
    enable = true;
    package = null;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    installBatSyntax = false;
    installVimSyntax = false;
    settings = {
      theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";
      font-size = lib.mkDefault 13;
      font-family = "RobotoMono Nerd Font";
      background-blur = lib.mkDefault true;
      command = "/etc/profiles/per-user/keanu/bin/fish --login --interactive";
      shell-integration = "fish";
      background-opacity = 0.7;
    };
  };

  programs.zellij = {
    enableBashIntegration = lib.mkForce false;
    enableFishIntegration = lib.mkForce false;
    enableZshIntegration = lib.mkForce false;
    exitShellOnExit = lib.mkForce false;
  };
}
