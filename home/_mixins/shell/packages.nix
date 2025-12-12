{pkgs, ...}: {
  home.packages = with pkgs; [
    age
    authelia
    # TODO: re-enable when no longer marked as broken on Darwin
    # bitwarden-cli
    circumflex
    cpufetch
    deadnix
    ffmpeg
    fh
    fortune
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
