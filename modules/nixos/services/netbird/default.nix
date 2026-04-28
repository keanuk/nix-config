{
  flake.modules.nixos.netbird =
    { pkgs, ... }:
    {
      services.netbird = {
        enable = true;
        package = pkgs.unstable.netbird;
      };
    };
}
