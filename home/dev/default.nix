{ pkgs, ... }:

{
  imports = [
    ./c.nix
    ./flutter.nix
    ./go.nix
    ./haskell.nix
    ./java.nix
    ./lua.nix
    ./markup.nix
    ./nim.nix
    ./nix.nix
    ./node.nix
    ./python.nix
    ./rust.nix
    ./zig.nix
  ];

  home.packages = with pkgs; [
    bash-language-server
    devenv
    gcc
    shellcheck
  ];
}
