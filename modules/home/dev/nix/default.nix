{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixd
        nixdoc
        nixfmt
        nix-diff
      ];
    };
}
