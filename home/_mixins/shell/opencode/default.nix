{ pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    enableMcpIntegration = true;
    web.enable = true;

    settings = {
      model = "opencode-go/glm-5.1";
      autoshare = false;
      autoupdate = true;
      theme = "catppuccin";
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
      reviewer = ./agents/reviewer.md;
    };

    commands = {
      changelog = ./commands/changelog.md;
      commit = ./commands/commit.md;
      fix-issue = ./commands/fix-issue.md;
    };

    tools = {
      git-blame = ./tools/git-blame.ts;
      git-log = ./tools/git-log.ts;
      nix-eval = ./tools/nix-eval.ts;
      nix-check = ./tools/nix-check.ts;
      just-run = ./tools/just-run.ts;
    };
  };
}
