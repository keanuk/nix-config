{ pkgs, ... }:
{
  home.packages = with pkgs; [
    haskell.compiler.ghc98
  ];
}
