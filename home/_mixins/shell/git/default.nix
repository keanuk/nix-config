{pkgs, ...}: {
  programs.git = {
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
    };
  };

  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      side-by-side = true;
    };
  };
}
