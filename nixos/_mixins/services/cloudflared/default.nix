{
  config,
  lib,
  pkgs,
  domains,
  ...
}:
let
  tunnelId = "c7967aa7-6b7a-4f93-bb49-7663fe2ab21b";
  baseDomain = domains.primary;

  # Build ingress rules from the centralized service definitions
  ingress = lib.mapAttrs' (
    _name: cfg:
    let
      fqdn = if cfg.subdomain == null then baseDomain else "${cfg.subdomain}.${baseDomain}";
    in
    lib.nameValuePair fqdn "http://localhost:${toString cfg.proxyPort}"
  ) domains.services;
in
{
  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
    description = "Cloudflare Tunnel daemon user";
  };

  users.groups.cloudflared = { };

  sops.secrets.cloudflared-tunnel-credentials = {
    owner = "cloudflared";
    group = "cloudflared";
    mode = "0400";
  };

  services.cloudflared = {
    enable = true;
    package = pkgs.unstable.cloudflared;
    tunnels = {
      "${tunnelId}" = {
        credentialsFile = config.sops.secrets.cloudflared-tunnel-credentials.path;
        default = "http_status:404";
        inherit ingress;
      };
    };
  };

  systemd.services."cloudflared-tunnel-${tunnelId}" = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = lib.mkForce "cloudflared";
      Group = lib.mkForce "cloudflared";
      Environment = "TUNNEL_EDGE_IP_VERSION=4";
    };
  };
}
