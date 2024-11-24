{ ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      			function fish_greeting
      				fastfetch
      			end
      		'';
    shellAliases = {
      cat = "bat";
      cd = "z";
      cleanup = "nix-store --gc";
      drebuild = "darwin-rebuild switch --flake ~/.config/nix-config";
      dupdate = "nix flake update --flake /Users/keanu/.config/nix-config";
      find = "fd";
      grep = "rg";
      ls = "eza";
      ll = "eza -l";
      nano = "micro";
      optimize = "nix-store --optimize";
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
