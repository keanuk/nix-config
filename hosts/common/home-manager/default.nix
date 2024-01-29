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
    bottom = {
      enable = true;
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        function fish_greeting
          fastfetch
        end
      '';
      shellAliases = {
        cleanup = "nix-store --gc && nix-store --optimize";
        ll = "ls -l";
        rebuild = "sudo nixos-rebuild switch --upgrade";
        repair = "sudo nix-store --verify --check-contents --repair";
        update = "nix flake update ~/nix-config";
      };
    };
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
    git = {
      enable = true;
      userName = "Keanu Kerr";
      userEmail = "keanu@kerr.us";
      delta = {
        enable = true;
      };
      extraConfig = {
        github.user = "keanuk";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
    helix = {
      enable = true;
      # defaultEditor = true;
      settings = {
        theme = "base16_default";
        editor = {
          lsp.display-messages = true;
        };
      };
      themes = import ./helix_theme.nix;
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
        tabsize = 2;
        wordwrap = true;
        ft.nix = {
          tabsize = 2;
          tabstospaces = true;
        };
      };
    };
    neovim = {
      enable = true;
    };
    starship = {
      enable = true;
      enableTransience = true;
      settings = import ./starship_nerd.nix;
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
      # syntaxHighlighting.enable = true;
      shellAliases = {
        cleanup = "nix-store --gc && nix-store --optimize";
        ll = "ls -l";
        rebuild = "sudo nixos-rebuild switch --upgrade";
        repair = "sudo nix-store --verify --check-contents --repair";
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
