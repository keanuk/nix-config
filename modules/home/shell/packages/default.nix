{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      home.packages = with pkgs.unstable; [
        age
        authelia
        bitwarden-cli
        circumflex
        claude-code
        cloudflared
        # codex
        copilot-language-server
        cosign
        cpufetch
        ddgr
        deadnix
        # TODO: re-enable when build succeeds
        # delta
        deploy-rs
        ffmpeg
        fh
        file
        fortune
        gemini-cli
        github-copilot-cli
        gping
        immich-cli
        jq
        just
        libnatpmp
        mediainfo
        # TODO: re-enable when build succeeds
        # mistral-vibe
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
      ];
    };
}
