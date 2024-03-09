{ pkgs, ... }:

{

  imports = [
    ../dev/default.nix
  ];

  environment.systemPackages = with pkgs; [
    acpid
    pciutils
    polkit
    psmisc
    sbctl
    snapper
    usbutils
  ];

  users.users.keanu.packages = with pkgs; [
    age
    btop
    cpufetch
    direnv
    fastfetch
    ffmpeg
    fortune
    git-crypt
    htop
    just
    nix-index
    nmap
    onefetch
    ramfetch
    sops
    ssh-to-age
    tealdeer
    tree
    wget
    yt-dlp
  ];

  # Shell
  programs.zsh.enable = true;
  programs.fish.enable = true;
  services.atuin.enable = true;

  # nixpkgs
  nixpkgs.config = {
    allowUnfree = true;
    # permittedInsecurePackages = [];
  };

  environment.sessionVariables = {};
}
