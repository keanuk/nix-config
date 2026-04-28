{ inputs, ... }:
{
  flake.modules.nixos.lanzaboote =
    { lib, ... }:
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      boot = {
        bootspec.enable = true;
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
        loader.systemd-boot.enable = lib.mkForce false;
      };
    };
}
