{
  config,
  lib,
  ...
}:
{
  services = {
    hostapd = {
      enable = true;
      radios = {
        wlp1s0 = {
          networks.wlp1s0 = {
            ssid = "electronic-thumb";
            authentication.saePasswords = [ { password = "keanukerr"; } ];
          };
        };
      };
    };

    dnsmasq = lib.optionalAttrs config.services.hostapd.enable {
      enable = true;
      settings = {
        bind-interfaces = true;
        dhcp-range = [ "10.1.9.10,10.1.9.254" ];
        interface = "wlp1s0";
        server = [
          "8.8.8.8"
          "8.8.4.4"
        ];
      };
    };

    haveged.enable = config.services.hostapd.enable;
  };

  networking = {
    bridges.br0.interfaces = [
      "enp4s0f3u1c2"
      "wlp1s0"
    ];
    firewall.allowedUDPPorts = lib.optionals config.services.hostapd.enable [
      53
      67
    ];

    networkmanager.unmanaged = [
      "interface-name:wl*"
    ]
    ++ lib.optional config.services.hostapd.enable "interface-name:wlp1s0";
    wireless.enable = true;
  };
}
