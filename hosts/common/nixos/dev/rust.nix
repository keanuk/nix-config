{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    rustc
    cargo
    rust-analyzer
  ];
}
