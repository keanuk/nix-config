# Helper function to create NixOS host configurations with standard specialArgs
#
# Usage in flake.nix:
#   titan = mkNixosHost { modules = [ ./nixos/titan ]; };
{
  self,
  inputs,
  outputs,
  mkHomeManagerHost,
  lib,
}:
{ modules }:
lib.nixosSystem {
  specialArgs = {
    inherit
      self
      inputs
      outputs
      mkHomeManagerHost
      ;
  };
  inherit modules;
}
