{ config, ... }:
{
  flake.modules.homeManager.opencode =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.opencode =
        lib.mkIf (!(pkgs.stdenv.hostPlatform.isx86_64 && pkgs.stdenv.hostPlatform.isDarwin))
          {
            enable = true;
            package = pkgs.opencode;
            enableMcpIntegration = true;
            web.enable = true;

            settings = {
              model = "opencode-go/kimi-k2.7-code";
              autoshare = false;
              autoupdate = false;

              mcp = {
                nixos = {
                  command = "uvx";
                  args = [ "mcp-nixos" ];
                };
                context7 = {
                  url = "https://mcp.context7.com/mcp";
                };
                github = lib.mkIf (lib.hasAttrByPath [ "sops" "secrets" "github-token" ] config) {
                  command = pkgs.writeShellScript "opencode-mcp-github" ''
                    export GITHUB_PERSONAL_ACCESS_TOKEN="$(cat ${config.sops.secrets.github-token.path})"
                    exec ${pkgs.uv}/bin/uvx mcp-server-github
                  '';
                  args = [ ];
                };
                fetch = {
                  command = "uvx";
                  args = [ "mcp-server-fetch" ];
                };
                playwright = {
                  command = pkgs.writeShellScript "opencode-mcp-playwright" ''
                    export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver}
                    exec ${pkgs.uv}/bin/uvx mcp-playwright
                  '';
                  args = [ ];
                };
              };
            };

            extraPackages = [
              pkgs.uv
              pkgs.playwright
            ];

            tui = {
              theme = "system";
            };

            context = ./context/default.md;

            agents = {
              architect = ./agents/architect.md;
              coder = ./agents/coder.md;
              debugger = ./agents/debugger.md;
              documentation = ./agents/documentation.md;
              explainer = ./agents/explainer.md;
              reviewer = ./agents/reviewer.md;
              tester = ./agents/tester.md;
            };

            commands = {
              changelog = ./commands/changelog.md;
              commit = ./commands/commit.md;
              explain = ./commands/explain.md;
              fix-issue = ./commands/fix-issue.md;
              implement = ./commands/implement.md;
              pr = ./commands/pr.md;
              refactor = ./commands/refactor.md;
              test = ./commands/test.md;
            };

            # TODO: enable when tools work again
            # currently causes issue that prevents opencode from working
            # tools = {
            #   git-blame = ./tools/git-blame.ts;
            #   git-diff = ./tools/git-diff.ts;
            #   git-log = ./tools/git-log.ts;
            #   grep-search = ./tools/grep-search.ts;
            #   just-run = ./tools/just-run.ts;
            #   nix-check = ./tools/nix-check.ts;
            #   nix-eval = ./tools/nix-eval.ts;
            #   nix-lint = ./tools/nix-lint.ts;
            # };
          };
    };

  flake.modules.homeManager = {
    desktop = config.flake.modules.homeManager.opencode;
    darwin-profile = config.flake.modules.homeManager.opencode;
  };
}
