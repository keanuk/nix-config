{ config, ... }:
{
  flake.modules.homeManager.darwin = {
    imports =
      (with config.flake.modules.homeManager; [
        nh
        # Same dev languages as the original darwin mixin — excludes csharp
        # and flutter, which weren't wanted on macOS.
        c
        go
        haskell
        java
        lua
        markup
        nim
        nix
        node
        python
        rust
        zig
      ])
      ++ [
        ./desktop/ghostty/_darwin.nix
        ./desktop/halloy/_darwin.nix
        ./desktop/zed/_darwin.nix
        ./shell/atuin/_darwin.nix
      ];
  };
}
