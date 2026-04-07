{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jdk
    jdt-language-server
    kotlin
    kotlin-language-server
  ];
}
