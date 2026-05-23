{
  flake.modules.nixos.github-runner =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.services.nix-config.github-runner;
      runnerDir = "/var/lib/github-runner/nix-config";
    in
    {
      options.services.nix-config.github-runner = {
        enable = lib.mkEnableOption "GitHub Actions self-hosted runner for nix-config CI builds";

        url = lib.mkOption {
          type = lib.types.str;
          default = "https://github.com/keanuk/nix-config";
          description = "GitHub repository URL for the runner.";
        };

        tokenFile = lib.mkOption {
          type = lib.types.path;
          description = ''
            Path to a file containing a GitHub personal access token (classic)
            with 'repo' scope. The module uses this PAT to fetch a short-lived
            runner registration token from the GitHub API on every service start.
          '';
        };

        labels = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "self-hosted"
            "nixos"
            "x86_64-linux"
          ];
          description = "Extra labels to assign to this runner.";
        };
      };

      config = lib.mkIf cfg.enable {
        nixpkgs.config.permittedInsecurePackages = [
          "nodejs-20.20.2"
          "nodejs-slim-20.20.2"
        ];

        users.users.github-runner = {
          isSystemUser = true;
          group = "github-runner";
          home = runnerDir;
          createHome = true;
          description = "GitHub Actions runner user";
        };

        users.groups.github-runner = { };

        systemd.services.github-runner-nix-config = {
          description = "GitHub Actions self-hosted runner for nix-config";
          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          requires = [ "network-online.target" ];

          serviceConfig = {
            Type = "simple";
            User = "github-runner";
            Group = "github-runner";
            WorkingDirectory = runnerDir;
            ExecStartPre = pkgs.writeShellScript "github-runner-config" ''
              set -euo pipefail
              export HOME=${runnerDir}

              echo "Fetching runner registration token from GitHub API..."

              PAT=$(${pkgs.coreutils}/bin/cat "${cfg.tokenFile}")
              API_URL="https://api.github.com/repos/keanuk/nix-config/actions/runners/registration-token"

              # Fetch a fresh registration token (expires in 1 hour)
              RESPONSE=$(${pkgs.curl}/bin/curl -sS -w "\n%{http_code}" -X POST \
                -H "Authorization: token $PAT" \
                -H "Accept: application/vnd.github.v3+json" \
                "$API_URL")

              HTTP_CODE=$(${pkgs.coreutils}/bin/echo "$RESPONSE" | ${pkgs.coreutils}/bin/tail -n 1)
              BODY=$(${pkgs.coreutils}/bin/echo "$RESPONSE" | ${pkgs.coreutils}/bin/head -n -1)

              if [ "$HTTP_CODE" != "201" ]; then
                echo "Failed to fetch registration token (HTTP $HTTP_CODE):"
                echo "$BODY"
                exit 1
              fi

              REG_TOKEN=$(${pkgs.coreutils}/bin/echo "$BODY" | ${pkgs.jq}/bin/jq -r '.token')
              if [ "$REG_TOKEN" = "null" ] || [ -z "$REG_TOKEN" ]; then
                echo "Failed to extract registration token from API response:"
                echo "$BODY"
                exit 1
              fi

              echo "Registering GitHub Actions runner..."

              ${pkgs.github-runner}/bin/config.sh \
                --unattended \
                --url "${cfg.url}" \
                --token "$REG_TOKEN" \
                --name "beehive" \
                --labels "${lib.concatStringsSep "," cfg.labels}" \
                --replace \
                --work "${runnerDir}/_work"

              echo "Runner registered successfully."
            '';
            ExecStart = "${pkgs.github-runner}/bin/run.sh";
            Restart = "always";
            RestartSec = "30";
            KillMode = "process";
          };

          path = [
            pkgs.nix
            pkgs.cachix
            pkgs.git
            pkgs.gnutar
            pkgs.gzip
            pkgs.curl
            pkgs.jq
            pkgs.coreutils
          ];
        };
      };
    };
}
