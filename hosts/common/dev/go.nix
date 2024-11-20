{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    go
    delve
    gopls
  ];
}
