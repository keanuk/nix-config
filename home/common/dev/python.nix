{pkgs, ...}: {
  home.packages = with pkgs; [
    python3Full

    python313Packages.python-lsp-server
    python313Packages.xkbcommon
  ];
}
