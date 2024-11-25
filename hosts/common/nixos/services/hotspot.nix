{ config, lib, ... }:

{
  # services.create_ap = {
  #   enable = true;
  #   settings = {
  #     INTERNET_IFACE = "enp4s0f3u1c2";
  #     WIFI_IFACE = "wlp1s0";
  #     SSID = "enterprise";
  #     PASSPHRASE = "keanukerr";
  #   };
  # };
  services.hostapd = {
    enable = true;
    radios = {
      wlp1s0 = {
        networks.wlp1s0 = {
          ssid = "electronic-thumb";
          authentication.saePasswords = [{ password = "keanukerr"; }];
        };
      };
    };
  };

  networking = {
    bridges.br0.interfaces = [ "enp4s0f3u1c2" "wlp1s0" ];
    firewall.allowedUDPPorts = lib.optionals config.services.hostapd.enable [ 53 67 ];
    # interfaces.wlp1s0.ipv4.addresses = lib.optionals config.services.hostapd.enable [{ address = "10.1.9.1"; prefixLength = 24; }];
    networkmanager.unmanaged = [ "interface-name:wl*" ] ++ lib.optional config.services.hostapd.enable "interface-name:wlp1s0";
    wireless.enable = true;
  };

  services.dnsmasq = lib.optionalAttrs config.services.hostapd.enable {
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

  services.haveged.enable = config.services.hostapd.enable;
}
