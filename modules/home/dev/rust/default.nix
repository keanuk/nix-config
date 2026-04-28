{ config, ... }:
{
  flake.modules.homeManager.rust =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        rustc
        cargo
        cargo-generate
        cargo-readme
        cargo-tauri
        crate2nix
        rust-analyzer
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.rust;
}
