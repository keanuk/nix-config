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

  # comin opts itself into the server role
  flake.modules.nixos.server = config.flake.modules.nixos.comin;
}
