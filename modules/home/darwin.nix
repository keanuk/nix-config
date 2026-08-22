{ config, ... }:
let
  # All language toolchains opt into `dev`, so importing `dev` covers them.
  inherit (config.flake.modules.homeManager)
    nh
    dev
    ;
in
{
  flake.modules.homeManager.darwin = {
    imports = [
      nh
      dev
      ./desktop/ghostty/_darwin.nix
      ./desktop/halloy/_darwin.nix
      ./desktop/zed/_darwin.nix
      ./shell/atuin/_darwin.nix
    ];
  };
}
