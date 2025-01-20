{ pkgs, ... }:

{
  programs = {
    fish.enable = true;
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
    pciutils
    polkit
    psmisc
    sbctl
    snapper
    starship
    transmission_4
    usbutils
    util-linux
    wireguard-tools
  ];
}
