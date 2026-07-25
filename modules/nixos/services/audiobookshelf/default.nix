{
  flake.modules.nixos.audiobookshelf =
    { pkgs, ... }:
    {
      services.audiobookshelf = {
        enable = false;
        openFirewall = true;
        user = "audiobookshelf";
        group = "media";
        package = pkgs.unstable.audiobookshelf;
      };
    };
}
