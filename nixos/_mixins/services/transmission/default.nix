{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.vpn-confinement.nixosModules.default
  ];

  services.transmission = {
    enable = true;
    openPeerPorts = true;
    openRPCPort = true;
    user = "transmission";
    group = "media";
    home = "/data/Downloads/Torrent/transmission";
    credentialsFile = "/data/Downloads/Torrent/transmission/secrets/settings.json";
    package = pkgs.unstable.transmission_4;
    settings = {
      anti-brute-force-enabled = true;
      anti-brute-force-threshold = 20;
      blocklist-enabled = true;
      blocklist-url = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz";
      download-dir = "/data/Downloads/Torrent/complete";
      download-queue-enabled = true;
      download-queue-size = 5;
      encryption = 1;
      idle-seeding-limit = 30;
      incomplete-dir = "/data/Downloads/Torrent/incomplete";
      peer-port = 12340;
      port-forwarding-enabled = true;
      rpc-authentication-required = true;
      rpc-bind-address = "192.168.15.1";
      rpc-port = 9091;
      rpc-whitelist = "127.0.0.1,10.19.5.*,192.168.15.1";
      watch-dir-enabled = true;
      watch-dir = "/data/Downloads/Torrent/watch";
    };
  };

  vpnNamespaces.proton = {
    enable = true;
    wireguardConfigFile = "/data/.secret/wg.conf";
    accessibleFrom = [
      "10.19.5.0/24"
    ];
    portMappings = [
      {
        from = 9091;
        to = 9091;
      }
    ];
    # openVPNPorts = [
    #   {
    #     port = 12340;
    #     protocol = "both";
    #   }
    # ];
  };

  systemd.services.transmission.vpnconfinement = {
    enable = true;
    vpnnamespace = "proton";
  };
}
