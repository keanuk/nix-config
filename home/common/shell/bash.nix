{...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = "fastfetch";
    shellAliases = import ./config/aliases.nix;
  };
}
