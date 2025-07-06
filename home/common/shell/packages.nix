{pkgs, ...}: {
  home.packages = with pkgs; [
    age
    bitwarden-cli
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
    ramfetch
    sops
    ssh-to-age
    tlrc
    tree
    wget
  ];
}
