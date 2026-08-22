# NOTE: Not imported by any host; kept intentionally for future use.
{
  flake.modules.nixos.prowlarr =
    { pkgs, ... }:
    {
      services.prowlarr = {
        enable = true;
        openFirewall = true;
        package = pkgs.unstable.prowlarr;
      };
    };
}
