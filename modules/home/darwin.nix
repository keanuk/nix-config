{ config, ... }:
{
  flake.modules.homeManager.darwin = {
    imports =
      (with config.flake.modules.homeManager; [
        shell-nh
        dev
      ])
      ++ [
        ./desktop/ghostty/_darwin.nix
        ./desktop/halloy/_darwin.nix
        ./desktop/zed/_darwin.nix
        ./shell/atuin/_darwin.nix
      ];
  };
}
