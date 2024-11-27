{ ... }:

{
  programs.nushell = {
    enable = true;
    configFile = {
      text = ''
        let $config = {
          filesize_metric: true
          table_mode: rounded
          use_ls_colors: true
        }
      '';
    };
    extraConfig = ''
      let carapace_completer = {|spans|
        carapace $spans.0 nushell $spans | from json
      }
      $env.config = {
        show_banner: false,
        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "fuzzy"
          external: {
            enable: true
            max_results: 100
            completer: $carapace_completer
          }
        }
      }
      $env.PATH = ($env.PATH |
      split row (char esep) |
      prepend /home/myuser/.apps |
      append /usr/bin/env
      )
      fastfetch
    '';
    shellAliases = {
      cat = "bat";
      cd = "z";
      cleanup = "nix-store --gc";
      find = "fd";
      grep = "rg";
      ll = "eza -l";
      ls = "eza";
      nano = "micro";
      optimize = "nix-store --optimize";
      rebuild = "sudo nixos-rebuild switch --upgrade";
      rebuild-darwin = "darwin-rebuild switch --flake ~/.config/nix-config";
      rebuild-offline = "sudo nixos-rebuild switch --option substitute false";
      repair = "sudo nix-store --verify --check-contents --repair";
      top = "btm";
      update = "nix flake update --flake ~/.config/nix-config";
      update-darwin = "nix flake update --flake /Users/keanu/.config/nix-config";
      vi = "hx";
      vim = "nvim";
    };
  };
}
