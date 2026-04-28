{ config, inputs, ... }:
{
  flake.modules.nixos.comin = _: {
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

  flake.modules.nixos.base = config.flake.modules.nixos.comin;
}
