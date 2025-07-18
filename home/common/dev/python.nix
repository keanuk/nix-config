{pkgs, ...}: {
  home.packages = with pkgs; [
    python3Full

    # TODO: re-enable when build succeeds
    # python313Packages.python-lsp-server
    python313Packages.xkbcommon
  ];
}
