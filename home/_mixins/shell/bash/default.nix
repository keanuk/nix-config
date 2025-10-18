{pkgs, ...}: {
  programs.bash = {
    enable = true;
    package = pkgs.bash;
    enableCompletion = true;
    initExtra = "fastfetch";
    shellAliases = import ../aliases.nix;
  };
}
