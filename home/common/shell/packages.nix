{pkgs, ...}: {
  home.packages = with pkgs; [
    age
    # TODO: uncomment when issue is resolved: https://github.com/bitwarden/clients/issues/15000
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
    nmap
    onefetch
    sops
    ssh-to-age
    tlrc
    tree
    wget
  ];
}
