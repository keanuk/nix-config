{...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      function fish_greeting
      	fastfetch
      end
    '';
    shellAliases = import ./config/aliases.nix;
  };
}
