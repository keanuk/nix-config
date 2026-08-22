# NOTE: Not imported by any host; kept intentionally for future use.
# (ursa runs audiobookshelf via the nixarr role instead.)
{
  flake.modules.nixos.audiobookshelf =
    { pkgs, ... }:
    {
      services.audiobookshelf = {
        enable = false;
        user = "audiobookshelf";
        group = "media";
        package = pkgs.unstable.audiobookshelf;
      };
    };
}
