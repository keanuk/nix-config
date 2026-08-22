# NOTE: Not imported by any host; kept intentionally for future use.
{
  flake.modules.homeManager.appearance =
    { ... }:
    {
      imports = [
        ./_font.nix
      ];
    };
}
