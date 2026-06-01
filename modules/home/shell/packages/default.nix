{ config, ... }:
{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs.unstable;
        [
          age
          antigravity-cli
          circumflex
          cloudflared
          cosign
          cpufetch
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
        ]
        ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [
          pkgs.unstable.authelia
          pkgs.unstable.proton-vpn-cli
        ];
    };

  flake.modules.homeManager.base = config.flake.modules.homeManager.shell;
}
