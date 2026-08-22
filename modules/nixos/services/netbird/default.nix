# NOTE: Not imported by any host; kept intentionally for future use.
{
  flake.modules.nixos.netbird =
    { pkgs, ... }:
    {
      services.netbird = {
        enable = true;
        package = pkgs.unstable.netbird;
      };
    };
}
