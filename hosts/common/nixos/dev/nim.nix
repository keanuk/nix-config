{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    nim
    nimlangserver
  ];
}
