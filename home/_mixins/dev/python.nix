{ pkgs, ... }:
{
  home.packages = with pkgs; [
    python314

    python314Packages.python-lsp-server
  ];
}
