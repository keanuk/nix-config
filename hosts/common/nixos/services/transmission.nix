{ inputs, ... }:

{
  imports = [
    inputs.vpn-confinement.nixosModules.default
  ];

  services.transmission = {
    enable = true;
    openPeerPorts = true;
    user = "keanu";
    group = "transmission";
    settings = {
      download-dir = "/internal/downloads";
      incomplete-dir = "/internal/incomplete";
      rpc-bind-address = "10.19.6.2";
    };
  };

  vpnnamespaces.wg = {
    enable = true;
    wireguardConfigFile = "/home/keanu/secrets/wg0.conf";
    namespaceAddress = "10.19.6.1";
    bridgeAddress = "10.19.6.2";
    accessibleFrom = [
      "10.0.2.0/24"
    ];
    portMappings = [
      {
        from = 9091;
        to = 9091;
      }
    ];
  };

  systemd.services.transmission.vpnconfinement = {
    enable = true;
    vpnnamespace = "wg";
  };
}
