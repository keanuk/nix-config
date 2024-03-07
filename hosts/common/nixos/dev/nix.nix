{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    nil
  ];
}
