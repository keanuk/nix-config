{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.vpn-confinement.nixosModules.default
  ];

  services.transmission = {
    enable = true;
    openPeerPorts = true;
    openRPCPort = true;
    user = "transmission";
    group = "media";
    home = "/var/lib/transmission";
    credentialsFile = "/var/lib/secrets/transmission/settings.json";
    package = pkgs.unstable.transmission_4;
    settings = {
      anti-brute-force-enabled = true;
      anti-brute-force-threshold = 20;
      blocklist-enabled = true;
      blocklist-url = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz";
      download-dir = "/internal/Downloads/Torrent/complete";
      download-queue-enabled = true;
      download-queue-size = 5;
      encryption = 1;
      idle-seeding-limit = 30;
      incomplete-dir = "/internal/Downloads/Torrent/incomplete";
      peer-port = 12340;
      port-forwarding-enabled = true;
      rpc-authentication-required = true;
      rpc-bind-address = "192.168.15.1";
      rpc-port = 9091;
      rpc-whitelist = "127.0.0.1,10.19.5.*,192.168.15.1";
      watch-dir-enabled = true;
      watch-dir = "/internal/Downloads/Watch";
    };
  };

  vpnNamespaces.wg = {
    enable = true;
    wireguardConfigFile = "/var/lib/secrets/wg0.conf";
    accessibleFrom = [
      "10.19.5.0/24"
    ];
    portMappings = [
      {
        from = 9091;
        to = 9091;
      }
    ];
    openVPNPorts = [
      {
        port = 12340;
        protocol = "both";
      }
    ];
  };

  systemd.services.transmission.vpnconfinement = {
    enable = true;
    vpnnamespace = "wg";
  };
}
