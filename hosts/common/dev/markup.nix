{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    marksman
    taplo
    vscode-langservers-extracted
    yaml-language-server
  ];
}
