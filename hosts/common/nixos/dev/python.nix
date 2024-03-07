{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    python3
    python311Packages.python-lsp-server
  ];
}
