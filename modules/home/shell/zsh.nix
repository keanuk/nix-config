{
  flake.modules.homeManager.shell-zsh =
    { pkgs, ... }:
    {
      programs.zsh = {
        enable = true;
        package = pkgs.zsh;
        autocd = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases = import ./_aliases.nix;
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
