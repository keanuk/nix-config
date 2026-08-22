{ config, ... }:
{
  flake.modules.nixos.open-webui =
    { pkgs, ... }:
    {
      services.open-webui = {
        enable = true;
        package = pkgs.unstable.open-webui;
        # Exposed on the tailnet for direct use (open-webui has its own login);
        # web access goes through the Authelia proxy.
        openFirewall = true;
        host = "0.0.0.0";
        port = 11435;
      };
    };

  flake.modules.nixos.server = config.flake.modules.nixos.open-webui;
}
