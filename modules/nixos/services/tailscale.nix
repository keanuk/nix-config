{
  flake.modules.nixos.svc-tailscale =
    { pkgs, ... }:
    {
      services.tailscale = {
        enable = true;
        package = pkgs.unstable.tailscale;
      };
    };
}
