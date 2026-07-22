{ inputs, ... }:
{
  flake.modules.darwin.home-manager = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupCommand = "rm -rf \"$1.backup\" && mv \"$1\" \"$1.backup\"";
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
