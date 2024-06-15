{ pkgs, ... }:

{
  imports = [
    ./c.nix
    ./go.nix
    ./lua.nix
    ./markup.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./virtualization.nix
  ];

  environment.systemPackages = with pkgs; [
    gcc
  ];

  users.users.keanu.packages = with pkgs; [
    shellcheck
  ];
}
