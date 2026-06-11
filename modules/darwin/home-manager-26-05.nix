{ inputs, ... }:
{
  flake.modules.darwin.home-manager-26-05 = {
    imports = [ inputs.home-manager-darwin-x86.darwinModules.home-manager ];

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
