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

        age = {
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          keyFile = lib.mkDefault "${config.users.users.keanu.home}/.config/sops/age/keys.txt";
          generateKey = true;
        };

        secrets = {
          github-token = { };
          google_maps_geolocation = {
            owner = config.users.users.keanu.name;
          };
          nextdns_id = {
            mode = "0444";
          };
          user-keanu-password = { };
          user-kimmy-password = { };
          hotspot-password = { };
        };
      };

      # Wire the decrypted github-token into each user's nix.conf so the
      # github: flake fetcher authenticates (access-tokens) instead of hitting
      # GitHub's 60 req/hr anonymous limit during `nix flake update` / nh / etc.
      # Per-user nix.conf is writable and not determinate-managed, unlike
      # /etc/nix/nix.custom.conf (a read-only store symlink).
      system.activationScripts.nix-github-access-token =
        let
          humanUsers = lib.filterAttrs (_: u: u.isNormalUser && u.home != null) config.users.users;
          userEntries = lib.mapAttrsToList (n: u: "${n}\t${u.home}") humanUsers;
        in
        lib.stringAfter [ "setupSecrets" ] ''
          tokenPath=${config.sops.secrets.github-token.path}
          if [ ! -f "$tokenPath" ]; then
            echo "warning: github-token secret not available; skipping nix.conf access-tokens" >&2
            exit 0
          fi
          token=$(cat "$tokenPath")
          while IFS=$'\t' read -r user home; do
            [ -d "$home" ] || continue
            confDir="$home/.config/nix"
            confFile="$confDir/nix.conf"
            mkdir -p "$confDir"
            tmp=$(mktemp)
            {
              if [ -f "$confFile" ]; then
                grep -v '^access-tokens *=' "$confFile" 2>/dev/null || true
              fi
              printf 'access-tokens = github.com=%s\n' "$token"
            } > "$tmp"
            uid=$(id -u "$user" 2>/dev/null || echo 0)
            gid=$(id -g "$user" 2>/dev/null || echo 0)
            chown "$uid:$gid" "$tmp"
            mv "$tmp" "$confFile"
            chmod 600 "$confFile"
          done <<USERS
          ${lib.concatStringsSep "\n" userEntries}
          USERS
        '';
    };

  flake.modules.nixos.base = config.flake.modules.nixos.sops;
}
