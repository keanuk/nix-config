{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      programs.bash = {
        enable = true;
        package = pkgs.bash;
        enableCompletion = true;
        initExtra = "fastfetch";
        shellAliases = import ./_aliases.nix;
      };
    };
}
