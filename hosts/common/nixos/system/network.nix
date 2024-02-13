{ config, pkgs, lib, ... }:

{
  services = {
    automatic-timezoned.enable = true;
    fail2ban.enable = true;
    geoclue2.enable = true;
    localtimed.enable = true;
    # netbird.enable = true;
    nextdns = {
      enable = true;
      arguments = [ 
        "-config" "c773e8" 
        ];
    };
    openssh = {
      enable = true;
      ports = [
      	22
      ];
      settings = {
      	PasswordAuthentication = false;
      };
    };
    printing.enable = true;
    resolved = { 
      enable = true;
      extraConfig = ''
        DNS=45.90.28.0#c773e8.dns.nextdns.io
        DNS=2a07:a8c0::#c773e8.dns.nextdns.io
        DNS=45.90.30.0#c773e8.dns.nextdns.io
        DNS=2a07:a8c1::#c773e8.dns.nextdns.io
        DNSOverTLS=yes
      '';
    };
    tailscale.enable = true;
  };

  networking = {
    firewall.enable = true;
    # firewall.trustedInterfaces = [ "wt0" ];
    networkmanager.enable = true;
  };
}
