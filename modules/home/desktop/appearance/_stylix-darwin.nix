# NOTE: Not imported by any host; kept intentionally for future use.
{ inputs, ... }:
{
  imports = [
    inputs.stylix.darwinModules.stylix
  ];

  stylix = {
    enable = true;
  };
}
