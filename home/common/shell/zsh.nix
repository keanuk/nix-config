{...}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    shellAliases = import ./config/aliases.nix;
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
