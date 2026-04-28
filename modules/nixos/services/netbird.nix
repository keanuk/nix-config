{
  flake.modules.nixos.svc-netbird =
    { pkgs, ... }:
    {
      services.netbird = {
        enable = true;
        package = pkgs.unstable.netbird;
      };
    };
}
