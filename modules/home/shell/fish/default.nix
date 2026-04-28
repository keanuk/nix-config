{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        package = pkgs.fish;
        interactiveShellInit = ''
          function fish_greeting
          	fastfetch
          end
        '';
        shellAliases = import ../_aliases.nix;
      };
    };
}
