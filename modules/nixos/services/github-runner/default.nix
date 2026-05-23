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
          description = "Path to a file containing the GitHub personal access token with 'repo' scope.";
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

              if [ ! -f ${runnerDir}/.runner ]; then
                echo "Registering GitHub Actions runner..."
                ${pkgs.github-runner}/bin/config.sh \
                  --unattended \
                  --url "${cfg.url}" \
                  --token "$(cat "${cfg.tokenFile}")" \
                  --name "beehive" \
                  --labels "${lib.concatStringsSep "," cfg.labels}" \
                  --replace \
                  --work "${runnerDir}/_work"
              fi
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
          ];
        };
      };
    };
}
