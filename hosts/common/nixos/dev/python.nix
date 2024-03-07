{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    python3
  ];
}
