{ ... }:

{
  imports = [
    ./shell/default.nix
  ];
  
  nixpkgs.config.allowUnfree = true;

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "weekly";
  };

  programs.home-manager = {
    enable = true;
    path = "$HOME/.config/nix-config";
  };

  news.display = "notify";
  
  home = {
    sessionVariables = {
      # EDITOR = "micro";
      # SYSTEMD_EDITOR = "micro";
      # VISUAL = "micro";
    };
  };
}
