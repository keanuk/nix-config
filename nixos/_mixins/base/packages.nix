{ pkgs, ... }:
{
  programs = {
    fish.enable = true;
    zsh.enable = true;
  };

  services.atuin.enable = true;

  environment.sessionVariables = { };

  environment.systemPackages = with pkgs; [
    acpid
    unstable.bcachefs-tools
    busybox
    cachix
    dmidecode
    hwdata
    iptables
    libsecret
    linux-wifi-hotspot
    lsof
    nix-output-monitor
    pciutils
    polkit
    psmisc
    sbctl
    smartmontools
    snapper
    tpm2-tools
    tpm2-tss
    usbutils
    util-linux
    wireguard-tools
  ];
}
