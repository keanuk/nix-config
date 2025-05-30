{...}: {
  programs.git = {
    enable = true;
    userName = "Keanu Kerr";
    userEmail = "keanu@kerr.us";
    lfs.enable = true;
    delta = {
      enable = true;
    };
    extraConfig = {
      github.user = "keanuk";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
