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
      cleanup = "nix-store --gc and nix-store --optimize";
      find = "fd";
      grep = "rg";
      ll = "eza -l";
      ls = "eza";
      nano = "micro";
      rebuild = "sudo nixos-rebuild switch --upgrade";
      rebuild-offline = "sudo nixos-rebuild switch --option substitute false";
      repair = "sudo nix-store --verify --check-contents --repair";
      top = "btm";
      update = "nix flake update ~/.config/nix-config";
      vi = "hx";
      vim = "nvim";
    };
  };
}
