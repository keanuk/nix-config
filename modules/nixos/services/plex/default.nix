# NOTE: Not imported by any host; kept intentionally for future use.
{
  flake.modules.nixos.plex =
    { pkgs, ... }:
    {
      services.plex = {
        enable = true;
        openFirewall = true;
        user = "plex";
        group = "media";
        dataDir = "/var/lib/plex";
        package = pkgs.unstable.plex;
      };

      users.users.plex.extraGroups = [
        "data"
      ];
    };
}
