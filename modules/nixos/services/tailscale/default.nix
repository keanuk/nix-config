{ config, ... }:
{
  flake.modules.nixos.tailscale =
    { pkgs, ... }:
    {
      services.tailscale = {
        enable = true;
        package = pkgs.unstable.tailscale;
      };
    };

  # tailscale opts itself into the base role.
  flake.modules.nixos.base = config.flake.modules.nixos.tailscale;
}
