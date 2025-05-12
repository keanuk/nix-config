{pkgs, ...}: {
  home.packages = with pkgs; [
    haskell.compiler.ghcHEAD
  ];
}
