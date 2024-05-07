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
    loginFile = {
      text = ''
        fastfetch
      '';
    };
    shellAliases = {
      cleanup = "nix-store --gc && nix-store --optimize";
      ll = "ls -l";
      rebuild = "sudo nixos-rebuild switch --upgrade";
      rebuild-offline = "sudo nixos-rebuild switch --option substitute false";
      repair = "sudo nix-store --verify --check-contents --repair";
      update = "nix flake update ~/.config/nix-config";
    };
  };
}
