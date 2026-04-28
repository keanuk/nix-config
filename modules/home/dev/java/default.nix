{ config, ... }:
{
  flake.modules.homeManager.java =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        jdk
        jdt-language-server
        kotlin
        kotlin-language-server
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.java;
}
