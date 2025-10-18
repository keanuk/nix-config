{pkgs, ...}: {
  home.packages = with pkgs; [
    age
    # TODO: re-enable when no longer marked as broken on Darwin
    # bitwarden-cli
    circumflex
    cpufetch
    ffmpeg
    fh
    fortune
    git-crypt
    just
    libnatpmp
    nix-index
    nix-tree
    nmap
    onefetch
    sops
    ssh-to-age
    tlrc
    tree
    wget
  ];
}
