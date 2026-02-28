# Shared home-manager profile for VPS hosts
# Provides the common import set used by all VPS machines.
#
# Usage in host files:
#   imports = [ ../../_mixins/profiles/vps.nix ];
#   home.stateVersion = "25.11";
{ ... }:
{
  imports = [
    ../base
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
  };
}
