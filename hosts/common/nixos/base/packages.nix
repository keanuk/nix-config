{ pkgs, ... }:

{

  imports = [
    ../dev/default.nix
  ];

  environment.systemPackages = with pkgs; [
    acpid
    bcachefs-tools
    iptables
    lsof
    pciutils
    polkit
    psmisc
    sbctl
    snapper
    usbutils
    util-linux
    wireguard-tools
  ];

  users.users.keanu.packages = with pkgs; [
    age
    btop
    cpufetch
    direnv
    fastfetch
    ffmpeg
    fortune
    fzf
    git-crypt
    htop
    just
    libnatpmp
    nix-index
    nmap
    onefetch
    ramfetch
    sops
    ssh-to-age
    tealdeer
    transmission
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

  environment.sessionVariables = { };
}
