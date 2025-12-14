{pkgs, ...}: {
  home.packages = with pkgs; [
    age
    authelia
    # TODO: re-enable when no longer marked as broken on Darwin
    # bitwarden-cli
    circumflex
    copilot-language-server
    cpufetch
    deadnix
    ffmpeg
    fh
    fortune
    gemini-cli-bin
    github-copilot-cli
    immich-cli
    just
    libnatpmp
    nix-index
    nix-tree
    nmap
    onefetch
    openssl
    sops
    ssh-to-age
    statix
    tlrc
    tree
    wget
  ];
}
