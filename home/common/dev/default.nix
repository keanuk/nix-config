{ pkgs, ... }:

{
  imports = [
    ./c.nix
    ./go.nix
    ./haskell.nix
    ./java.nix
    ./lua.nix
    ./markup.nix
    ./nix.nix
    ./node.nix
    ./python.nix
    ./rust.nix
    ./zig.nix
  ];

  home.packages = with pkgs; [
    aider-chat
    bash-language-server
    devenv
    gcc
    lsp-ai
    shellcheck
  ];
}
