{ pkgs, ... }:
{
  home.packages = with pkgs.unstable; [
    age
    authelia
    bitwarden-cli
    circumflex
    # TODO: re-enable when build is fixed
    # claude-code
    cloudflared
    codex
    copilot-language-server
    cosign
    cpufetch
    ddgr
    deadnix
    deploy-rs
    ffmpeg
    fh
    file
    fortune
    gemini-cli
    github-copilot-cli
    gping
    immich-cli
    jq
    just
    libnatpmp
    mediainfo
    mistral-vibe
    ncdu
    nixos-anywhere
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
