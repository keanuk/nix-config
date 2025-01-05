{ inputs, pkgs, ... }:

{
  imports = [
    inputs.vpn-confinement.nixosModules.default
  ];

  services.transmission = {
    enable = true;
    openPeerPorts = true;
    openRPCPort = true;
    user = "transmission";
    group = "transmission";
    credentialsFile = "/home/keanu/secrets/transmission/settings.json";
    package = pkgs.transmission_4;
    settings = {
      download-dir = "/internal/Downloads/Torrent/complete";
      incomplete-dir = "/internal/Downloads/Torrent/incomplete";
      rpc-bind-address = "0.0.0.0";
      rpc-port = 9091;
      rpc-whitelist = "127.0.0.1,10.19.5.*";
      watch-dir-enabled = true;
      watch-dir = "/internal/Downloads/Watch";
    };
  };

  vpnNamespaces.wg = {
    enable = true;
    wireguardConfigFile = "/home/keanu/secrets/wg0.conf";
    accessibleFrom = [
      "10.19.5.0/24"
    ];
    portMappings = [
      { from = 9091; to = 9091; }
    ];
  };

  systemd.services.transmission.vpnconfinement = {
    enable = true;
    vpnnamespace = "wg";
  };

}
