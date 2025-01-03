{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    python3
    python312Packages.python-lsp-server
  ];
}
