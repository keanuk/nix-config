# NOTE: Not imported by any host; kept intentionally for future use.
{
  flake.modules.nixos.nextdns-resolved =
    { config, ... }:
    {
      # Create a systemd service that generates resolved.conf with NextDNS settings
      # by reading the profile ID from sops secret at runtime
      systemd.services.nextdns-resolved-config = {
        description = "Generate resolved.conf with NextDNS configuration";
        before = [ "systemd-resolved.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };

        script = ''
          NEXTDNS_ID=$(cat ${config.sops.secrets.nextdns_id.path})

          mkdir -p /etc/systemd/resolved.conf.d

          {
            echo "[Resolve]"
            echo "DNS=45.90.28.0#''${NEXTDNS_ID}.dns.nextdns.io"
            echo "DNS=2a07:a8c0::#''${NEXTDNS_ID}.dns.nextdns.io"
            echo "DNS=45.90.30.0#''${NEXTDNS_ID}.dns.nextdns.io"
            echo "DNS=2a07:a8c1::#''${NEXTDNS_ID}.dns.nextdns.io"
            echo "DNSOverTLS=yes"
          } > /etc/systemd/resolved.conf.d/nextdns.conf
        '';
      };

      services.resolved = {
        enable = true;
      };

      # Ensure resolved restarts after config is generated
      systemd.services.systemd-resolved = {
        after = [ "nextdns-resolved-config.service" ];
        wants = [ "nextdns-resolved-config.service" ];
      };
    };
}
