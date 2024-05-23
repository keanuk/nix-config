{ pkgs, ... }:

{

  imports = [
    ../dev/default.nix
  ];

  environment.systemPackages = with pkgs; [
    acpid
    bcachefs-tools
    cachix
    hwdata
    iptables
    linux-wifi-hotspot
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
    bitwarden-cli
    cpufetch
    fastfetch
    ffmpeg
    fortune
    git-crypt
    just
    libnatpmp
    nix-index
    nmap
    onefetch
    ramfetch
    ripgrep
    sops
    ssh-to-age
    tlrc
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
