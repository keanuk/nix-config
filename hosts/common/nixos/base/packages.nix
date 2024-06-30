{ pkgs, ... }:

{

  imports = [
    # ../dev/default.nix
  ];

  environment.systemPackages = with pkgs; [
    acpid
    bcachefs-tools
    cachix
    fish
    git
    helix
    home-manager
    hwdata
    iptables
    # linux-wifi-hotspot
    lsof
    nushell
    pciutils
    polkit
    psmisc
    sbctl
    snapper
    starship
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
    transmission_4
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
