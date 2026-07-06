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

      # Persist the GitHub token into nix.conf so `nix flake update` (and any
      # non-interactive caller: just, nh, scripts) authenticates the github:
      # fetcher via access-tokens instead of hitting the 60 req/hr anon limit.
      home.activation.nix-github-access-token = lib.mkIf (config.sops.secrets ? github-token) (
        lib.hm.dag.entryAfter [ "sops-nix" ] ''
          tokenPath=${config.sops.secrets.github-token.path}
          for i in $(seq 1 30); do
            [ -f "$tokenPath" ] && break
            sleep 1
          done
          # Bail to warn-only: an exit here aborts the entire home-manager
          # activation script, skipping every subsequent DAG entry (do NOT
          # restore exit 0).
          if [ ! -f "$tokenPath" ]; then
            echo "warning: github-token secret not available; skipping nix.conf access-tokens" >&2
          else
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
          fi
        ''
      );

      # Export OLLAMA_API_KEY into the user session so GUI-launched apps
      # (Zed's ollama integration reads it from env per its docs) inherit it
      # without relying on an interactive shell. Darwin: GUI apps inherit env
      # from launchd, so populate it via launchctl.
      home.activation.ollama-api-key-env = lib.mkIf (config.sops.secrets ? ollama_api_key) (
        lib.hm.dag.entryAfter [ "sops-nix" ] ''
          secretPath=${config.sops.secrets.ollama_api_key.path}
          for i in $(seq 1 30); do
            [ -f "$secretPath" ] && break
            sleep 1
          done
          # Bail to warn-only: an exit here aborts the entire home-manager
          # activation script, skipping every subsequent DAG entry (do NOT
          # restore exit 0).
          if [ ! -f "$secretPath" ]; then
            echo "warning: ollama_api_key secret not available; skipping OLLAMA_API_KEY export" >&2
          else
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
          fi
        ''
      );
    };
}
