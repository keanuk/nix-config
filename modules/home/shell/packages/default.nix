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
          copilot-language-server
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
          mistral-vibe
          ncdu
          nixos-anywhere
          nix-index
          nix-tree
          nmap
          onefetch
          openssl
          sops
          ssh-to-age
          statix
          tlrc
          tree
          wget
        ]
        ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [
          pkgs.unstable.authelia
        ];
    };
}
