{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rustc
    cargo
    cargo-generate
    cargo-readme
    crate2nix
    rust-analyzer
  ];
}
