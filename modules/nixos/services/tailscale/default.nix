{ config, ... }:
{
  flake.modules.nixos.tailscale =
    { pkgs, ... }:
    {
      services.tailscale = {
        enable = true;
        package = pkgs.unstable.tailscale;
        openFirewall = true;
      };

      # Trust the tailnet interface so private services (SSH, Ollama, homelab
      # apps) stay unreachable on LAN/public WiFi without per-port firewall holes.
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
    };

  # tailscale opts itself into the base role.
  flake.modules.nixos.base = config.flake.modules.nixos.tailscale;
}
