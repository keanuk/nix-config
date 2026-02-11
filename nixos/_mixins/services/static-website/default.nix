# Shared mixin for static website VPS hosts
# Provides nginx + ACME + firewall configuration
#
# Usage:
#   imports = [
#     (import ../../_mixins/services/static-website {
#       domain = "example.com";
#       webRoot = "/var/www/example";
#     })
#   ];
{
  domain,
  webRoot,
}:
{ lib, ... }:
{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      root = webRoot;
      serverAliases = [ "www.${domain}" ];
      locations."/" = {
        tryFiles = "$uri $uri/ =404";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = (import ../../../../lib/domains.nix).email;
  };

  systemd.tmpfiles.rules = [
    "d ${webRoot} 0755 keanu users -"
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
