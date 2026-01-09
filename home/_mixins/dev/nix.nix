{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    nil
    nixd
    nixdoc
    nixfmt
    nix-diff
  ];
}
