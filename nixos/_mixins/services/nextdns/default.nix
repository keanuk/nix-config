{
  config,
  pkgs,
  lib,
  ...
}: {
  # Disable the built-in nextdns module as we're using a custom service
  # that reads the profile ID from sops at runtime
  nextdns.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    nextdns
  ];

  # Custom nextdns service that reads profile ID from sops secret
  systemd.services.nextdns = {
    description = "NextDNS DNS/DNS-over-HTTPS proxy";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "5s";
      DynamicUser = true;
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
    };

    script = ''
      PROFILE_ID=$(cat ${config.sops.secrets.nextdns_id.path})
      exec ${pkgs.nextdns}/bin/nextdns run -profile "$PROFILE_ID" -listen localhost:53
    '';
  };
}
