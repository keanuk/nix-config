{ pkgs, ... }:

{

  imports = [
    ../dev/default.nix
  ];

  environment.systemPackages = with pkgs; [
    acpid
    bcachefs-tools
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
    btop
    cpufetch
    direnv
    fastfetch
    fd
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
    ripgrep
    sops
    ssh-to-age
    tealdeer
    transmission
    tree
    wget
    yt-dlp
    zoxide
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
