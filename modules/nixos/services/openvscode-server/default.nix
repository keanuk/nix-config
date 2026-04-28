{ config, ... }:
{
  flake.modules.nixos.openvscode-server =
    { pkgs, ... }:
    {
      services.openvscode-server = {
        enable = true;
        package = pkgs.unstable.openvscode-server;
        user = "keanu";
        group = "users";
        serverDataDir = "/home/keanu/.openvscode-server";
        port = 3000;
        host = "0.0.0.0";
        withoutConnectionToken = true;
      };
    };

  flake.modules.nixos.server = config.flake.modules.nixos.openvscode-server;
}
