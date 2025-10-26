{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.git;
    lfs.enable = true;
    userName = "Keanu Kerr";
    userEmail = "keanu@kerr.us";
    delta.enable = true;
    extraConfig = {
      github.user = "keanuk";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # TODO: Switch to this config when 25.11 is released
  # programs.git = {
  #   enable = true;
  #   package = pkgs.git;
  #   lfs.enable = true;
  #   settings = {
  #     user = {
  #       name = "Keanu Kerr";
  #       email = "keanu@kerr.us";
  #     };
  #     github.user = "keanuk";
  #     init.defaultBranch = "main";
  #     pull.rebase = false;
  #   };
  # };

  # programs.delta = {
  #   enable = true;
  #   options = {
  #     navigate = true;
  #     side-by-side = true;
  #   };
  # };
}
