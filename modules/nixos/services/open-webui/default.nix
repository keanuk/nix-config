{ config, ... }:
{
  flake.modules.nixos.open-webui =
    { pkgs, ... }:
    {
      services.open-webui = {
        enable = true;
        package = pkgs.unstable.open-webui;
        openFirewall = true;
        host = "0.0.0.0";
        port = 11435;
      };
    };

  flake.modules.nixos.server = config.flake.modules.nixos.open-webui;
}
