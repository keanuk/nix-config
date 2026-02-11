{ pkgs, ... }:
{
  programs = {
    fish.enable = true;
    zsh.enable = true;
  };

  services.atuin.enable = true;

  environment.sessionVariables = { };

  environment.systemPackages = with pkgs; [
    busybox
    cachix
    iptables
    libsecret
    lsof
    nix-output-monitor
    pciutils
    polkit
    psmisc
    util-linux
    wireguard-tools
  ];
}
