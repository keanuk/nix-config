{
  flake.modules.nixos.network-manager-wait-online =
    {
      pkgs,
      lib,
      ...
    }:
    {
      warnings = lib.optional true "NetworkManager wait-online workaround (issue #180175) may no longer be needed. Last checked: 2025-07-28.";

      systemd.services.NetworkManager-wait-online = {
        serviceConfig = {
          ExecStart = [
            ""
            "${pkgs.networkmanager}/bin/nm-online -q"
          ];
        };
      };
    };
}
