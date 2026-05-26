{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs.unstable;
        [
          age
          circumflex
          claude-code
          cloudflared
          codex
          cosign
          cpufetch
          ddgr
          deadnix
          deploy-rs
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
          # TODO: Re-enable when build doesn't take forever
          # mistral-vibe
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
}
