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

  environment.variables = {
    RUST_LOG = "debug";
    # RUST_SRC_PATH = "${pkgs.rust.pacakges.stable.rustPlatform.rustLibSrc}";
  };
}
