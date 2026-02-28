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
{ domains, ... }:
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
      extraConfig = ''
        # Security headers
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options "DENY" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;
      '';
      locations."/" = {
        tryFiles = "$uri $uri/ =404";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = domains.email;
  };

  systemd.tmpfiles.rules = [
    "d ${webRoot} 0755 keanu users -"
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
