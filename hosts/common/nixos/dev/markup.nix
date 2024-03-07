{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    marksman
    taplo
    vscode-langservers-extracted
    yaml-language-server
  ];
}
