{ config, inputs, ... }:
let
  sopsFile = config._module.args.rootPath + "/secrets/sops/secrets.yaml";
in
{
  flake.modules.homeManager.sops =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      sops = {
        defaultSopsFile = sopsFile;
        defaultSopsFormat = "yaml";

        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

        secrets = {
          github-token = { };
          ollama_api_key = { };
        };
      };

      programs = lib.mkMerge [
        {
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
        }
        {
          fish.interactiveShellInit = lib.mkIf (config.sops.secrets ? ollama_api_key) (
            lib.mkBefore ''
              set -gx OLLAMA_API_KEY (cat ${config.sops.secrets.ollama_api_key.path})
            ''
          );

          zsh.initExtra = lib.mkIf (config.sops.secrets ? ollama_api_key) (
            lib.mkBefore ''
              export OLLAMA_API_KEY=$(cat ${config.sops.secrets.ollama_api_key.path})
            ''
          );

          bash.initExtra = lib.mkIf (config.sops.secrets ? ollama_api_key) (
            lib.mkBefore ''
              export OLLAMA_API_KEY=$(cat ${config.sops.secrets.ollama_api_key.path})
            ''
          );
        }
      ];

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

      # Export OLLAMA_API_KEY into the user session so GUI-launched apps
      # (Zed's ollama integration reads it from env per its docs) inherit it
      # without relying on an interactive shell. Linux: write the systemd-user
      # environment.d snippet and import it into the running user manager.
      # Darwin: GUI apps inherit env from launchd, so populate it via launchctl.
      home.activation.ollama-api-key-env = lib.mkIf (config.sops.secrets ? ollama_api_key) (
        lib.hm.dag.entryAfter [ "sops-nix" ] ''
          secretPath=${config.sops.secrets.ollama_api_key.path}
          for i in $(seq 1 30); do
            [ -f "$secretPath" ] && break
            sleep 1
          done
          if [ ! -f "$secretPath" ]; then
            echo "warning: ollama_api_key secret not available; skipping OLLAMA_API_KEY export" >&2
            exit 0
          fi
          key=$(cat "$secretPath" | tr -d '\n\r')
          ${
            if pkgs.stdenv.hostPlatform.isDarwin then
              ''
                launchctl setenv OLLAMA_API_KEY "$key" 2>/dev/null || true
              ''
            else
              ''
                envDir="${config.xdg.configHome}/environment.d"
                mkdir -p "$envDir"
                tmp=$(mktemp)
                {
                  if [ -f "$envDir/ollama-api-key.conf" ]; then
                    grep -v '^OLLAMA_API_KEY *=' "$envDir/ollama-api-key.conf" 2>/dev/null || true
                  fi
                  printf 'OLLAMA_API_KEY=%s\n' "$key"
                } > "$tmp"
                mv "$tmp" "$envDir/ollama-api-key.conf"
                chmod 600 "$envDir/ollama-api-key.conf"
                systemctl --user import-environment OLLAMA_API_KEY 2>/dev/null || true
              ''
          }
        ''
      );
    };
}
