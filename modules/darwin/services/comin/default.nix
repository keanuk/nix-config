{ inputs, ... }:
{
  flake.modules.darwin.svc-comin = _: {
    imports = [ inputs.comin.darwinModules.comin ];

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
