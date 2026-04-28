{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        jdk
        jdt-language-server
        kotlin
        kotlin-language-server
      ];
    };
}
