{ config, ... }:
{
  flake.modules.nixos.system-packages =
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
        ghostty.terminfo
        cachix
        cifs-utils
        iptables
        libsecret
        lsof
        nfs-utils
        nix-output-monitor
        pciutils
        polkit
        psmisc
        util-linux
        wireguard-tools
      ];
    };

  flake.modules.nixos.base = config.flake.modules.nixos.system-packages;
}
