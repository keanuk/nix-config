{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };
}
