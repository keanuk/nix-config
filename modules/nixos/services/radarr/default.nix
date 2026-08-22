# NOTE: Not imported by any host; kept intentionally for future use.
{
  flake.modules.nixos.radarr =
    { pkgs, ... }:
    {
      services.radarr = {
        enable = true;
        openFirewall = true;
        user = "radarr";
        group = "media";
        package = pkgs.unstable.radarr;
      };

      users.users.radarr.extraGroups = [
        "data"
      ];
    };
}
