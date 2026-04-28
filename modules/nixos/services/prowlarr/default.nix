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
