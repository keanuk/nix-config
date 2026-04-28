{ inputs, ... }:
{
  flake.modules.nixos.svc-comin = _: {
    imports = [ inputs.comin.nixosModules.comin ];

    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/keanuk/nix-config";
          branches.main.name = "main";
        }
      ];
    };
  };
}
