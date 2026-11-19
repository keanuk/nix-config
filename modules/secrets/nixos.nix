{ config, inputs, ... }:
let
  sopsFile = config._module.args.rootPath + "/secrets/sops/secrets.yaml";
in
{
  flake.modules.nixos.sops =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        defaultSopsFile = sopsFile;
        defaultSopsFormat = "yaml";

        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

        secrets = {
          github-token = {
            owner = config.users.users.keanu.name;
          };
          user-keanu-password = {
            neededForUsers = true;
          };
          ollama_api_key = {
            owner = config.users.users.keanu.name;
          };
        };
      };

      # Wire the decrypted github-token into keanu's nix.conf so the
      # github: flake fetcher authenticates (access-tokens) instead of hitting
      # GitHub's 60 req/hr anonymous limit during `nix flake update` / nh / etc.
      # Per-user nix.conf is writable and not determinate-managed, unlike
      # /etc/nix/nix.custom.conf (a read-only store symlink).
      system.activationScripts.nix-github-access-token =
        let
          owner = config.users.users.keanu;
        in
        lib.stringAfter (lib.optional (!config.sops.useSystemdActivation) "setupSecrets") ''
          tokenPath="${config.sops.secrets.github-token.path}"
          # Bail to warn-only: an exit here aborts the whole activate script in the initrd chroot before /run/current-system is symlinked, breaking systemd switch_root (do NOT restore exit 0).
          if [ ! -f "$tokenPath" ]; then
            echo "warning: github-token secret not available; skipping nix.conf access-tokens" >&2
          else
            token=$(tr -d '\n\r' < "$tokenPath")
            user="${owner.name}"
            home="${owner.home}"
            if [ -d "$home" ]; then
              uid=$(id -u "$user" 2>/dev/null || echo 0)
              gid=$(id -g "$user" 2>/dev/null || echo 0)
              confDir="$home/.config/nix"
              confFile="$confDir/nix.conf"
              install -d -o "$uid" -g "$gid" "$home/.config" "$confDir"
              tmp=$(mktemp)
              {
                if [ -f "$confFile" ]; then
                  grep -v '^access-tokens *=' "$confFile" 2>/dev/null || true
                fi
                printf 'access-tokens = github.com=%s\n' "$token"
              } > "$tmp"
              chown "$uid:$gid" "$tmp"
              chmod 600 "$tmp"
              mv "$tmp" "$confFile"
            fi
          fi
        '';

      # Surface OLLAMA_API_KEY into keanu's systemd-user environment.d so
      # GUI-launched apps (Zed's ollama integration is the consumer here; it
      # reads OLLAMA_API_KEY from env per the Zed docs) inherit it without
      # needing an interactive shell.
      system.activationScripts.ollama-api-key-env =
        let
          owner = config.users.users.keanu;
        in
        lib.stringAfter (lib.optional (!config.sops.useSystemdActivation) "setupSecrets") ''
          secretPath="${config.sops.secrets.ollama_api_key.path}"
          # Bail to warn-only: an exit here aborts the whole activate script in the initrd chroot before /run/current-system is symlinked, breaking systemd switch_root (do NOT restore exit 0).
          if [ ! -f "$secretPath" ]; then
            echo "warning: ollama_api_key secret not available; skipping environment.d injection" >&2
          else
            key=$(tr -d '\n\r' < "$secretPath")
            user="${owner.name}"
            home="${owner.home}"
            if [ -d "$home" ]; then
              uid=$(id -u "$user" 2>/dev/null || echo 0)
              gid=$(id -g "$user" 2>/dev/null || echo 0)
              envDir="$home/.config/environment.d"
              install -d -o "$uid" -g "$gid" "$home/.config" "$envDir"
              tmp=$(mktemp)
              {
                if [ -f "$envDir/ollama-api-key.conf" ]; then
                  grep -v '^OLLAMA_API_KEY *=' "$envDir/ollama-api-key.conf" 2>/dev/null || true
                fi
                printf 'OLLAMA_API_KEY=%s\n' "$key"
              } > "$tmp"
              chown "$uid:$gid" "$tmp"
              chmod 600 "$tmp"
              mv "$tmp" "$envDir/ollama-api-key.conf"
            fi
          fi
        '';
    };

  flake.modules.nixos.base = config.flake.modules.nixos.sops;
}
