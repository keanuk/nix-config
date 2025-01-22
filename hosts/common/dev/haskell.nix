{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    haskell.compiler.ghcHEAD
  ];
}
