{ pkgs, ... }:
{
  services.openvscode-server = {
    enable = true;
    # TODO: switch back to unstable when build is resolved
    package = pkgs.openvscode-server;
    user = "keanu";
    group = "users";
    serverDataDir = "/home/keanu/.openvscode-server";
    port = 3000;
    host = "0.0.0.0";
    withoutConnectionToken = true;
  };
}
