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
    bat = {
      enable = true;
      config = {
        theme = "base16";
      };
    };
    fish = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "Keanu Kerr";
      userEmail = "keanu@kerr.us";
      delta = {
        enable = true;
      };
    };
    helix = {
      enable = true;
      # defaultEditor = true;
      settings = {
        theme = "base16_terminal";
        editor = {
          lsp.display-messages = true;
        };
      };
      languages = {
        language = [
          {
            name = "go";
            auto-format = true;
          }
          {
            name = "nix";
            auto-format = true;
          }
          {
            name = "rust";
            auto-format = true;
          }
        ];
      };
    };
    micro = {
      enable = true;
      settings = {
        autosu = true;
        colorscheme = "simple";
        ignorecase = true;
        savecursor = true;
        saveundo = true;
        tabsize = 4;
        wordwrap = true;
        ft.nix = {
          tabsize = 2;
          tabstospaces = true;
        };
      };
    };
    neovim = {
      enable = true;
      defaultEditor = false;	
    };
    starship = {
      enable = true;
#      enableTransience = true;
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
#      syntaxHighlighting.enable = true;
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
}
