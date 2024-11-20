{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    lua
    lua-language-server
  ];
}
