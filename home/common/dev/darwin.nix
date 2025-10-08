{pkgs, ...}: {
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
  ];

  home.packages = with pkgs; [
    awk-language-server
    bash-language-server
    devenv
    gcc
    prettier
    shellcheck
  ];
}
