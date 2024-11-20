{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    dart
    flutter
  ];
}
