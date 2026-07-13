{ config, ... }:
{
  flake.modules.homeManager.shell =
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
          dig
          ffmpeg
          fh
          file
          fortune
          gping
          stable.immich-cli
          jq
          just
          libnatpmp
          mediainfo
          ncdu
          nixos-anywhere
          nix-index
          nix-tree
          nmap
          onefetch
          openssl
          proton-pass-cli
          sops
          ssh-to-age
          statix
          tlrc
          tree
          wget

          unstable.antigravity-cli
        ])
        ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [
          pkgs.proton-vpn-cli
        ];
    };

  flake.modules.homeManager.base = config.flake.modules.homeManager.shell;
}
