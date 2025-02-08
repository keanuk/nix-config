{ ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
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
      rebuild = "sudo nixos-rebuild switch --upgrade --flake /etc/nixos/nix-config";
      rebuild-darwin = "darwin-rebuild switch --flake ~/.config/nix-config";
      rebuild-offline = "sudo nixos-rebuild switch --option substitute false";
      repair = "sudo nix-store --verify --check-contents --repair";
      top = "btm";
      update = "nix flake update --flake /etc/nixos/nix-config";
      update-darwin = "nix flake update --flake /Users/keanu/.config/nix-config";
      vi = "hx";
      vim = "nvim";
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
}
