{
  pkgs,
  lib,
  ...
}: {
  services.cockpit = {
    enable = true;
    package = pkgs.cockpit;
    openFirewall = true;
    port = 9090;
    settings = {
      WebService = {
        Origins = lib.mkForce "https://localhost:9090 https://beehive:9090 wss://beehive:9090 https://cockpit.oranos.me wss://cockpit.oranos.me";
      };
    };
  };

  # TODO: Remove when issue is resolved: https://github.com/trifectatechfoundation/sudo-rs/issues/1249
  security.sudo-rs.enable = lib.mkForce false;
}
