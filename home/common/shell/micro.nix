{ lib, ... }:

{
  programs.micro = {
    enable = true;
    settings = {
      autosu = true;
      colorscheme = lib.mkDefault "simple";
      ignorecase = true;
      savecursor = true;
      saveundo = true;
      tabsize = 2;
      wordwrap = true;
      ft.nix = {
        tabsize = 2;
        tabstospaces = true;
      };
    };
  };
}
