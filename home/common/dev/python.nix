{pkgs, ...}: {
  home.packages = with pkgs; [
    python3

    python312Packages.python-lsp-server
    python313Packages.xkbcommon
  ];
}
