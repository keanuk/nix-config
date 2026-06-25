{ config, inputs, ... }:
let
  sopsFile = config._module.args.rootPath + "/secrets/sops/secrets.yaml";
in
{
  flake.modules.homeManager.sops =
    { config, lib, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      sops = {
        defaultSopsFile = sopsFile;
        defaultSopsFormat = "yaml";

        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

        secrets = {
          github-token = { };
        };
      };

      programs = {
        fish.interactiveShellInit = lib.mkIf (config.sops.secrets ? github-token) (
          lib.mkBefore ''
            set -gx NIX_GITHUB_TOKEN (cat ${config.sops.secrets.github-token.path})
            set -gx NIX_CONFIG "extra-access-tokens = github.com=$NIX_GITHUB_TOKEN"
          ''
        );

        zsh.initExtra = lib.mkIf (config.sops.secrets ? github-token) (
          lib.mkBefore ''
            export NIX_GITHUB_TOKEN=$(cat ${config.sops.secrets.github-token.path})
            export NIX_CONFIG="extra-access-tokens = github.com=$NIX_GITHUB_TOKEN"
          ''
        );

        bash.initExtra = lib.mkIf (config.sops.secrets ? github-token) (
          lib.mkBefore ''
            export NIX_GITHUB_TOKEN=$(cat ${config.sops.secrets.github-token.path})
            export NIX_CONFIG="extra-access-tokens = github.com=$NIX_GITHUB_TOKEN"
          ''
        );
      };

      # Persist the GitHub token into nix.conf so `nix flake update` (and any
      # non-interactive caller: just, nh, scripts) authenticates the github:
      # fetcher via access-tokens instead of hitting the 60 req/hr anon limit.
      # The shell init above only fires in interactive sessions.
      home.activation.nix-github-access-token = lib.mkIf (config.sops.secrets ? github-token) (
        lib.hm.dag.entryAfter [ "sops-nix" ] ''
          tokenPath=${config.sops.secrets.github-token.path}
          for i in $(seq 1 30); do
            [ -f "$tokenPath" ] && break
            sleep 1
          done
          if [ ! -f "$tokenPath" ]; then
            echo "warning: github-token secret not available; skipping nix.conf access-tokens" >&2
            exit 0
          fi
          token=$(cat "$tokenPath")
          confDir=${config.xdg.configHome}/nix
          confFile=$confDir/nix.conf
          mkdir -p "$confDir"
          tmp=$(mktemp)
          {
            if [ -f "$confFile" ]; then
              grep -v '^access-tokens *=' "$confFile" 2>/dev/null || true
            fi
            printf 'access-tokens = github.com=%s\n' "$token"
          } > "$tmp"
          mv "$tmp" "$confFile"
          chmod 600 "$confFile"
        ''
      );
    };
}
