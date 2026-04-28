{
  flake.modules.homeManager.appearance =
    { ... }:
    {
      imports = [
        ./_font.nix
      ];
    };
}
