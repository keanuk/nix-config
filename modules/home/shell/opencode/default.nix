{ config, ... }:
{
  flake.modules.homeManager.opencode =
    { pkgs, lib, ... }:
    {
      programs.opencode =
        lib.mkIf (!(pkgs.stdenv.hostPlatform.isx86_64 && pkgs.stdenv.hostPlatform.isDarwin))
          {
            enable = true;
            package = pkgs.opencode;
            enableMcpIntegration = true;
            web.enable = true;

            settings = {
              model = "opencode-go/kimi-k2.6";
              autoshare = false;
              autoupdate = false;

              mcp = {
                git = {
                  type = "local";
                  command = [
                    "npx"
                    "-y"
                    "@modelcontextprotocol/server-git"
                  ];
                  enabled = true;
                };
              };
            };

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

            tools = {
              git-blame = ./tools/git-blame.ts;
              git-diff = ./tools/git-diff.ts;
              git-log = ./tools/git-log.ts;
              grep-search = ./tools/grep-search.ts;
              just-run = ./tools/just-run.ts;
              nix-check = ./tools/nix-check.ts;
              nix-eval = ./tools/nix-eval.ts;
              nix-lint = ./tools/nix-lint.ts;
            };
          };
    };

  flake.modules.homeManager = {
    desktop = config.flake.modules.homeManager.opencode;
    darwin-profile = config.flake.modules.homeManager.opencode;
  };
}
