{pkgs, ...}: {
  home.packages = with pkgs; [
    age
    bitwarden-cli
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
