{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      package = pkgs.git;
      lfs.enable = true;
      settings = {
        user = {
          name = "Keanu Kerr";
          email = "keanu@kerr.us";
        };
        github.user = "keanuk";
        init.defaultBranch = "main";
        pull.rebase = false;
        push.autoSetupRemote = true;
        merge.conflictStyle = "zdiff3";
        rerere.enabled = true;
        diff.algorithm = "histogram";
        transfer.fsckobjects = true;
        fetch.fsckobjects = true;
        receive.fsckObjects = true;
      };
    };

    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
      };
    };
  };
}
