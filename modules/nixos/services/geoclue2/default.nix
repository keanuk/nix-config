{ config, ... }:
{
  flake.modules.nixos.geoclue2 =
    { pkgs, lib, ... }:
    {
      services.geoclue2 = {
        enable = true;
        package = pkgs.geoclue2;
      };

      location.provider = "geoclue2";

      # The demo agent doesn't exit on SIGTERM during session teardown, which
      # stalls user-session stop for 90s and then cascades into user@.service's
      # own 120s stop timeout. Cap its stop timeout so shutdown stays fast.
      systemd.user.services.geoclue-agent.serviceConfig.TimeoutStopSec = lib.mkDefault "5s";
    };

  flake.modules.nixos.desktop = config.flake.modules.nixos.geoclue2;
}
