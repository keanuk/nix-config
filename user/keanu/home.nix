
{
	nixpkgs.config.allowUnfree = true;
  home = {
    sessionVariables = {
      EDITOR = "micro";
      SYSTEMD_EDITOR = "micro";
      VISUAL = "micro";
    };
  };
  programs = {
    fish = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "Keanu Kerr";
      userEmail = "keanu@kerr.us";
    };
    micro = {
      enable = true;
      settings.colorscheme = "simple";
    };
    neovim = {
      enable = true;
      defaultEditor = false;	
    };
    starship = {
      enable = true;
      enableTransience = true;
      settings = import ./starship.nix;
    };
    zellij = {
      enable = true;
      # enableBashIntegration = true;
      # enableZshIntegration = true;
      # enableFishIntegration = true;
    };
    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        cleanup = "nix-store --gc && nix-store --optimize";
          ll = "ls -l";
          rebuild = "sudo nixos-rebuild switch --upgrade";
          update = "nix flake update ~/.config/nixos-config";
      };
      oh-my-zsh = {
        enable = true;
        theme = "fletcherm";
        plugins = [
          "gh"
          "git"
          "golang"
          "rust"
          "sudo"
          "systemd"
        ];
      };
    };
  };
  # home.stateVersion = "23.11";
}
