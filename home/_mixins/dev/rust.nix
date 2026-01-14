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
}
