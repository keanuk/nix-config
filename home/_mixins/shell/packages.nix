{pkgs, ...}: {
  home.packages = with pkgs; [
    age
    # TODO: re-enable when no longer marked as broken on Darwin
    # bitwarden-cli
    circumflex
    cpufetch
    deadnix
    ffmpeg
    fh
    fortune
    git-crypt
    immich-cli
    just
    libnatpmp
    nix-index
    nix-tree
    nmap
    onefetch
    sops
    ssh-to-age
    statix
    tlrc
    tree
    wget
  ];
}
