{
  flake.modules.nixos.geoclue2 =
    { pkgs, ... }:
    {
      services.geoclue2 = {
        enable = true;
        package = pkgs.geoclue2;
      };

      location.provider = "geoclue2";
    };
}
