{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jdk
    # TODO: re-enable when build is fixed
    # jdt-language-server
    kotlin
    kotlin-language-server
  ];
}
