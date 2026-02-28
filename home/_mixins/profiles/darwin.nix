# Shared home-manager profile for Darwin hosts
# Provides the common import set used by most macOS machines.
#
# Usage in host files:
#   imports = [ ../_mixins/profiles/darwin.nix ];
#   home.stateVersion = "24.05";
{ ... }:
{
  imports = [
    ../base

    ../darwin
  ];

  home = {
    username = "keanu";
    homeDirectory = "/Users/keanu";
  };
}
