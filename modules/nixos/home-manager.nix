{ inputs, ... }:
let
  sharedHmSettings = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupCommand = "rm -rf \"$1.backup\" && mv \"$1\" \"$1.backup\"";
    extraSpecialArgs = { inherit inputs; };
  };
in
{
  flake.modules = {
    nixos = {
      home-manager = {
        imports = [ inputs.home-manager.nixosModules.home-manager ];
        home-manager = sharedHmSettings;
      };

      home-manager-stable = {
        imports = [ inputs.home-manager-stable.nixosModules.home-manager ];
        home-manager = sharedHmSettings;
      };
    };

    darwin.home-manager = {
      imports = [ inputs.home-manager.darwinModules.home-manager ];
      home-manager = sharedHmSettings;
    };
  };
}
