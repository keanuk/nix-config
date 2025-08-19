{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    package = pkgs.zsh;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    shellAliases = import ../common/aliases.nix;
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
