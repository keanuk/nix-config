# Shared home-manager profile for desktop Linux hosts
# Provides the common import set used by most desktop machines.
#
# Usage in host files:
#   imports = [ ../_mixins/profiles/desktop-linux.nix ];
#   home.stateVersion = "23.11";
{ ... }:
{
  imports = [
    ../base
    ../base/home-manager.nix

    ../desktop
    ../desktop/cosmic
    ../desktop/gnome
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
  };
}
