{ config, ... }:
{
  flake.modules.homeManager = {
    # Lightweight CLI utilities safe to deploy everywhere (including minimal VPSes).
    shell =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          dig
          file
          gping
          jq
          ncdu
          nmap
          openssl
          tlrc
          tree
          wget
        ];
      };

    # Heavier workstation/admin CLI tools kept out of minimal VPS closures.
    shell-workstation =
      { pkgs, ... }:
      {
        home.packages =
          (with pkgs; [
            age
            circumflex
            cloudflared
            cosign
            deadnix
            deploy-rs
            ffmpeg
            fh
            flow-control
            fortune
            immich-cli
            just
            libnatpmp
            mediainfo
            nixos-anywhere
            nix-index
            nix-tree
            onefetch
            proton-pass-cli
            sops
            ssh-to-age
            statix

            unstable.antigravity-cli
          ])
          ++ pkgs.lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [
            pkgs.proton-vpn-cli
          ];
      };

    base = config.flake.modules.homeManager.shell;
    desktop = config.flake.modules.homeManager.shell-workstation;
    darwin = config.flake.modules.homeManager.shell-workstation;
    wsl = config.flake.modules.homeManager.shell-workstation;
    server = config.flake.modules.homeManager.shell-workstation;
  };
}
