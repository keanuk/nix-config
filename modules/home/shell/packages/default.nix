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
          ddgr
          deadnix
          deploy-rs
          dig
          ffmpeg
          fh
          file
          fortune
          gemini-cli
          gping
          immich-cli
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
        ])
        ++ (pkgs.lib.optional (pkgs ? antigravity-cli) pkgs.antigravity-cli)
        ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [
          pkgs.authelia
          pkgs.cpufetch
          pkgs.proton-vpn-cli
        ];
    };

  flake.modules.homeManager.base = config.flake.modules.homeManager.shell;
}
