{ config, inputs, ... }:
{
  flake.modules.nixos.home-manager =
    {
      config,
      ...
    }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "backup";
        extraSpecialArgs = { inherit inputs; };
      };
    };

  flake.modules.nixos.home-manager-stable =
    {
      config,
      ...
    }:
    {
      imports = [ inputs.home-manager-stable.nixosModules.home-manager ];

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "backup";
        extraSpecialArgs = { inherit inputs; };
      };
    };
}
