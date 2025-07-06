{pkgs, ...}: {
  programs.fish = {
    enable = true;
    package = pkgs.fish;
    interactiveShellInit = ''
      function fish_greeting
      	fastfetch
      end
    '';
    shellAliases = import ./config/aliases.nix;
  };
}
