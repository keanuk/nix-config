{
  flake.modules.nixos.svc-flaresolverr =
    { pkgs, ... }:
    {
      services.flaresolverr = {
        enable = true;
        openFirewall = true;
        package = pkgs.unstable.flaresolverr;
      };
    };
}
