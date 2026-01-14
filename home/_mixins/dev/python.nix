{ pkgs, ... }:
{
  home.packages = with pkgs; [
    python3

    python313Packages.python-lsp-server
  ];
}
