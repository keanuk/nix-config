{ config, ... }:
let
  inherit (config.flake.modules.homeManager)
    nh
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
    ;
in
{
  flake.modules.homeManager.darwin = {
    imports = [
      nh
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
      ./desktop/ghostty/_darwin.nix
      ./desktop/halloy/_darwin.nix
      ./desktop/zed/_darwin.nix
      ./shell/atuin/_darwin.nix
    ];
  };
}
