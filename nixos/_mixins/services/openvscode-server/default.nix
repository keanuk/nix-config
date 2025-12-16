{pkgs, ...}: {
  services.openvscode-server = {
    enable = true;
    package = pkgs.unstable.openvscode-server;
    user = "keanu";
    group = "users";
    serverDataDir = "/home/keanu/.openvscode-server";
    port = 3000;
    host = "127.0.0.1";
    # Disable connection token since we're protecting access with Authelia 2FA
    withoutConnectionToken = true;
  };
}
