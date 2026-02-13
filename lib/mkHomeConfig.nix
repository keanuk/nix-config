# Helper function to create standalone home-manager configurations
#
# Usage in flake.nix:
#   "keanu@titan" = mkHomeConfig {
#     pkgs = pkgsFor.x86_64-linux;
#     modules = [ ./home/titan/keanu.nix ];
#   };
{
  inputs,
  outputs,
  lib,
}:
{ pkgs, modules }:
lib.homeManagerConfiguration {
  extraSpecialArgs = { inherit inputs outputs; };
  inherit pkgs modules;
}
