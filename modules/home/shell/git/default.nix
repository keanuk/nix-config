{
  flake.modules.homeManager.shell =
    { lib, pkgs, ... }:
    {
      programs = {
        git = {
          enable = true;
          package = pkgs.git;
          lfs.enable = true;
          signing.format = "openpgp";
          settings = {
            user = {
              name = lib.mkDefault "Keanu Kerr";
              email = lib.mkDefault "keanu@kerr.us";
            };
            github.user = lib.mkDefault "keanuk";
            init.defaultBranch = "main";
            pull.rebase = false;
            push.autoSetupRemote = true;
            merge.conflictStyle = "zdiff3";
            rerere.enabled = true;
            diff.algorithm = "histogram";
            transfer.fsckObjects = true;
            fetch.fsckObjects = true;
            receive.fsckObjects = true;
          };
        };

        delta = {
          enable = true;
          enableGitIntegration = true;
          options = {
            navigate = true;
            side-by-side = true;
          };
        };
      };
    };
}
