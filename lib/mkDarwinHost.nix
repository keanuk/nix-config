# Helper function to create nix-darwin host configurations with standard specialArgs
#
# Usage in flake.nix:
#   salacia = mkDarwinHost { modules = [ ./darwin/salacia ]; };
{
  self,
  inputs,
  outputs,
  domains,
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
      domains
      mkHomeManagerHost
      ;
  };
  inherit modules;
}
