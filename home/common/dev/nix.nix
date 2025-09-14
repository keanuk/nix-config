{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    nil
    nixd
    nixdoc
    nixfmt-rfc-style
    nix-diff
  ];
}
