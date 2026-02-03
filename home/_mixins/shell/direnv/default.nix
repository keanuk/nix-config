{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    enableBashIntegration = false;
    enableNushellIntegration = false;
    enableZshIntegration = false;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };
}
