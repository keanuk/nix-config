{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jdk
    jdt-language-server
    kotlin
    kotlin-language-server
  ];
}
