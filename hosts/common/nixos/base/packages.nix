{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nix-ld.nixosModules.nix-ld
  ];

  programs = {
    fish.enable = true;
    nix-ld.dev.enable = true;
    zsh.enable = true;
  };

  services.atuin.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ ];
  };

  environment.sessionVariables = { };

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
    libsecret
    linux-wifi-hotspot
    lsof
    nushell
    pass
    pass-wayland
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
}
