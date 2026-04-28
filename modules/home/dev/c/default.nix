{ config, ... }:
{
  flake.modules.homeManager.c =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        clang-tools
        cmake
        cmake-language-server
        lldb
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.c;
}
