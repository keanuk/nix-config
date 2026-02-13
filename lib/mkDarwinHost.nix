# Helper function to create nix-darwin host configurations with standard specialArgs
#
# Usage in flake.nix:
#   salacia = mkDarwinHost { modules = [ ./darwin/salacia ]; };
{
  self,
  inputs,
  outputs,
  mkHomeManagerHost,
  lib,
}:
{ modules }:
lib.darwinSystem {
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
