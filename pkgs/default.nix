# Custom packages
#
# This directory is reserved for custom packages that aren't available
# in nixpkgs or need custom modifications beyond what overlays provide.
# Currently empty, but custom packages can be added here.
#
# Example structure:
# pkgs: {
#   my-package = pkgs.callPackage ./my-package { };
#   another-package = pkgs.callPackage ./another-package { };
# }
#
# These packages are exposed through the overlays.additions overlay
# and become available as pkgs.my-package in all configurations.
_pkgs: { }
