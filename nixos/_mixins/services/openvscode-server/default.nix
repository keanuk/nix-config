{pkgs, ...}: {
  services.openvscode-server = {
    enable = true;
    package = pkgs.unstable.openvscode-server;
    serverDataDir = "/opt/openvscode-server";
    port = 3000;
    host = "127.0.0.1";
    # Disable connection token since we're protecting access with Authelia 2FA
    withoutConnectionToken = true;
  };
}
